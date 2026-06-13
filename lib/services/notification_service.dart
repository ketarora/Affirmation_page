// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/notification_service.dart                      ║
// ║  Daily affirmation push + 55×5 reminder + mood check-in      ║
// ╚══════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart'       as tz;
import 'package:timezone/data/latest.dart'    as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId    = 'nishaffs_daily';
  static const _channelName  = 'Daily Affirmations';
  static const _channelDesc  = 'Daily affirmation and wellness reminders';

  static const kAffirmationId = 1;
  static const kMoodCheckId   = 2;
  static const k55x5RemId     = 3;

  // ── Init — call once in main() after Firebase.initializeApp ────
  static Future<void> init() async {
    if (kIsWeb) return; // Local notifications not supported on web

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings(
      requestAlertPermission : false,
      requestBadgePermission : false,
      requestSoundPermission : false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  // ── Request permissions (show dialog to user) ─────────────────
  static Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    // iOS
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true, badge: true, sound: true) ??
          false;
    }

    // Android 13+
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    return true;
  }

  // ── Schedule daily affirmation at user-chosen time ────────────
  static Future<void> scheduleDailyAffirmation({
    int hour   = 8,
    int minute = 0,
    String? affirmationText,
  }) async {
    if (kIsWeb) return;

    await _plugin.zonedSchedule(
      kAffirmationId,
      '✨ Good morning, soul',
      affirmationText ?? 'Your daily affirmation is waiting for you 💫',
      _nextInstanceOf(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription : _channelDesc,
          importance         : Importance.high,
          priority           : Priority.high,
          styleInformation   : const BigTextStyleInformation(''),
          color              : const Color(0xFFFF82A9),
          icon               : '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode  : AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notif_hour',   hour);
    await prefs.setInt('notif_minute', minute);
    await prefs.setBool('notif_daily', true);
  }

  // ── Schedule evening mood check-in ────────────────────────────
  static Future<void> scheduleMoodCheckIn({int hour = 20, int minute = 0}) async {
    if (kIsWeb) return;

    await _plugin.zonedSchedule(
      kMoodCheckId,
      '🌙 How are you feeling?',
      'Take a moment to check in with yourself today.',
      _nextInstanceOf(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId, _channelName,
          channelDescription: _channelDesc,
          importance        : Importance.defaultImportance,
          color             : const Color(0xFFAC7BED),
          icon              : '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true, presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ── 55×5 challenge reminder ────────────────────────────────────
  static Future<void> schedule55x5Reminder({int hour = 7, int minute = 30}) async {
    if (kIsWeb) return;

    await _plugin.zonedSchedule(
      k55x5RemId,
      '📝 55×5 Challenge',
      'Don\'t forget your manifestation practice today! Keep the streak alive 🔥',
      _nextInstanceOf(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId, _channelName,
          channelDescription: _channelDesc,
          importance        : Importance.defaultImportance,
          color             : const Color(0xFFE6B861),
          icon              : '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true, presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ── Cancel individual or all ───────────────────────────────────
  static Future<void> cancelDailyAffirmation() async {
    if (kIsWeb) return;
    await _plugin.cancel(kAffirmationId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_daily', false);
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  // ── Load saved time preference ─────────────────────────────────
  static Future<Map<String, int>> getSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour'  : prefs.getInt('notif_hour')   ?? 8,
      'minute': prefs.getInt('notif_minute') ?? 0,
    };
  }

  static Future<bool> isDailyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notif_daily') ?? false;
  }

  // ── Private helpers ────────────────────────────────────────────
  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now      = tz.TZDateTime.now(tz.local);
    var   scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static void _onNotificationTap(NotificationResponse res) {
    // Handle deep-link on notification tap
    // e.g. navigate to affirmations screen
    debugPrint('Notification tapped: ${res.payload}');
  }
}

// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/notification_service_web_stub.dart             ║
// ║  Web-safe stub for NotificationService                       ║
// ╚══════════════════════════════════════════════════════════════╝

class NotificationService {
  static Future<void> init() async {}
  static Future<bool> requestPermissions() async => false;
  static Future<void> scheduleDailyAffirmation({int hour = 8, int minute = 0, String? affirmationText}) async {}
  static Future<void> scheduleMoodCheckIn({int hour = 20, int minute = 0}) async {}
  static Future<void> schedule55x5Reminder({int hour = 7, int minute = 30}) async {}
  static Future<void> cancelDailyAffirmation() async {}
  static Future<void> cancelAll() async {}
  static Future<Map<String, int>> getSavedTime() async => {'hour': 8, 'minute': 0};
  static Future<bool> isDailyEnabled() async => false;
}

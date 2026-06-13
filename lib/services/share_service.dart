// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/share_service.dart                             ║
// ║  Platform-aware share — Web Blob + Mobile Share.shareXFiles  ║
// ╚══════════════════════════════════════════════════════════════╝

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File;

// Web-only import — conditional so mobile doesn't break
import 'share_service_web.dart'  if (dart.library.io) 'share_service_stub.dart'
    as web_share;

class ShareService {

  // ── Share affirmation as text (works everywhere) ───────────────
  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(
      '✨ $text\n\n— NishAffs',
      subject: subject ?? 'Daily Affirmation',
    );
  }

  // ── Copy to clipboard ─────────────────────────────────────────
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: '✨ $text'));
  }

  // ── Share screenshot as image ─────────────────────────────────
  // imageBytes: output of screenshotController.capture()
  static Future<void> shareImage({
    required Uint8List imageBytes,
    String fileName = 'nishaffs_affirmation.png',
    String shareText = '✨ My affirmation today — NishAffs',
  }) async {
    if (kIsWeb) {
      // Web: trigger a Blob download — Share API not reliable on web browsers
      web_share.downloadBlob(imageBytes, fileName);
    } else {
      // Mobile: write to temp dir → share via share_plus
      final tempDir = await getTemporaryDirectory();
      final file    = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: shareText,
      );
    }
  }

  // ── Share journal entry as text ─────────────────────────────────
  static Future<void> shareJournalEntry(String content, DateTime date) async {
    final formatted = '📖 Journal — ${_formatDate(date)}\n\n$content\n\n— Written with NishAffs';
    await Share.share(formatted, subject: 'My Journal Entry');
  }

  // ── Share book recommendation ──────────────────────────────────
  static Future<void> shareBook(String bookName, String author) async {
    final text = '📚 I\'m reading "$bookName" by $author on NishAffs — a spiritual wellness app. Highly recommend! ✨';
    await Share.share(text);
  }

  static String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
}

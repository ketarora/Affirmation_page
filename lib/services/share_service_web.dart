// lib/services/share_service_web.dart
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

void downloadBlob(Uint8List bytes, String filename) {
  final blob = html.Blob([bytes], 'image/png');
  final url  = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..style.display = 'none'
    ..click();
  html.Url.revokeObjectUrl(url);
}

// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/share_service_web.dart                         ║
// ║  Web-only: triggers a PNG download via <a> tag              ║
// ╚══════════════════════════════════════════════════════════════╝

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

void downloadBlob(Uint8List bytes, String fileName) {
  final blob = html.Blob([bytes], 'image/png');
  final url  = html.Url.createObjectUrlFromBlob(blob);
  final a    = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';
  html.document.body!.append(a);
  a.click();
  a.remove();
  html.Url.revokeObjectUrl(url);
}

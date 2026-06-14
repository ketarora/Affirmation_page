// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/share_service_stub.dart                        ║
// ║  Mobile stub — imported instead of share_service_web.dart    ║
// ╚══════════════════════════════════════════════════════════════╝

import 'dart:typed_data';

// Mobile doesn't use blob download — Share.shareXFiles is used instead.
void downloadBlob(Uint8List bytes, String fileName) {
  // No-op on mobile. share_service.dart uses Share.shareXFiles directly.
}

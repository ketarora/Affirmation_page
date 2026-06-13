// lib/services/share_service_stub.dart
// Mobile stub — web blob download not applicable on native platforms
import 'dart:typed_data';

void downloadBlob(Uint8List bytes, String filename) {
  // No-op on mobile — share_service.dart handles native sharing via File
}

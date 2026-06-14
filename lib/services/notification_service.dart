// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/notification_service.dart                      ║
// ║  Dispatcher for NotificationService                          ║
// ╚══════════════════════════════════════════════════════════════╝

export 'notification_service_mobile.dart'
    if (dart.library.html) 'notification_service_web_stub.dart';

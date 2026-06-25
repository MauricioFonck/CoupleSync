import '../value_objects/ids.dart';

/// Puerto de gestión de tokens FCM (recepción en cliente). El **envío** de push
/// lo hace el emisor externo de GitHub Actions, no el dominio (ver D3).
abstract interface class NotificationTokenPort {
  /// Token FCM actual del dispositivo/navegador, o `null`.
  Future<String?> currentToken();

  Future<void> register(UserId userId, String token);
  Future<void> unregister(UserId userId, String token);
}

import '../entities/user.dart';

/// Puerto del directorio de los (dos) usuarios de la pareja. Se usa para
/// resolver los UIDs de A y B (necesarios para generar la agenda y evaluar
/// confirmaciones).
abstract interface class UserRepositoryPort {
  Future<List<User>> getAll();

  /// Inserta/actualiza el perfil del usuario (merge; no toca otros campos como
  /// los tokens FCM).
  Future<void> upsert(User user);
}

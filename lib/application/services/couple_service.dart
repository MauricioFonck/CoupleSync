import '../../domain/entities/user.dart';
import '../../domain/ports/user_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../result.dart';

/// Servicio del directorio de la pareja: registra el perfil del usuario y
/// resuelve los UIDs de los dos miembros.
class CoupleService {
  const CoupleService({required UserRepositoryPort userRepository})
    : _repository = userRepository;

  final UserRepositoryPort _repository;

  Future<Result<void>> registerProfile(User user) =>
      runCatching(() => _repository.upsert(user));

  Future<Result<List<UserId>>> coupleUserIds() => runCatching(
    () async => (await _repository.getAll()).map((u) => u.id).toList(),
  );
}

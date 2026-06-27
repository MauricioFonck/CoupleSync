import '../entities/penalty.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de penitencias.
abstract interface class PenaltyRepositoryPort {
  Future<List<Penalty>> getAll();

  /// Flujo en tiempo real de todas las penitencias.
  Stream<List<Penalty>> watchAll();
  Future<List<Penalty>> getActive();
  Future<Penalty?> getById(PenaltyId id);
  Future<void> save(Penalty penalty);
  Future<void> delete(PenaltyId id);
}

import '../entities/penalty.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de penitencias.
abstract interface class PenaltyRepositoryPort {
  Future<List<Penalty>> getAll();
  Future<List<Penalty>> getActive();
  Future<Penalty?> getById(PenaltyId id);
  Future<void> save(Penalty penalty);
  Future<void> delete(PenaltyId id);
}

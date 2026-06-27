import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/penalty.dart';
import '../../domain/ports/penalty_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/penalty_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestorePenaltyRepository implements PenaltyRepositoryPort {
  FirestorePenaltyRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.penalties);

  @override
  Future<List<Penalty>> getAll() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => PenaltyDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Stream<List<Penalty>> watchAll() => _col.snapshots().map(
    (snap) =>
        snap.docs.map((d) => PenaltyDto.fromJson(d.data()).toDomain()).toList(),
  );

  @override
  Future<List<Penalty>> getActive() async {
    final snap = await _col.where('active', isEqualTo: true).get();
    return snap.docs
        .map((d) => PenaltyDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Future<Penalty?> getById(PenaltyId id) async {
    final doc = await _col.doc(id.value).get();
    final data = doc.data();
    return data == null ? null : PenaltyDto.fromJson(data).toDomain();
  }

  @override
  Future<void> save(Penalty penalty) =>
      _col.doc(penalty.id.value).set(penalty.toDto().toJson());

  @override
  Future<void> delete(PenaltyId id) => _col.doc(id.value).delete();
}

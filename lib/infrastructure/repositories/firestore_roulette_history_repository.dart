import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/roulette_spin.dart';
import '../../domain/ports/roulette_history_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/roulette_spin_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreRouletteHistoryRepository
    implements RouletteHistoryRepositoryPort {
  FirestoreRouletteHistoryRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.rouletteHistory);

  @override
  Future<void> add(RouletteSpin spin) =>
      _col.doc(spin.id.value).set(spin.toDto().toJson());

  @override
  Future<List<RouletteSpin>> getAll() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => RouletteSpinDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Future<RouletteSpin?> getById(RouletteSpinId id) async {
    final doc = await _col.doc(id.value).get();
    final data = doc.data();
    return data == null ? null : RouletteSpinDto.fromJson(data).toDomain();
  }

  @override
  Future<void> save(RouletteSpin spin) =>
      _col.doc(spin.id.value).set(spin.toDto().toJson());
}

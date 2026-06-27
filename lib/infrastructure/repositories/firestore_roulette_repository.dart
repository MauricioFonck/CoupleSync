import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/roulette_item.dart';
import '../../domain/ports/roulette_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/roulette_item_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreRouletteRepository implements RouletteRepositoryPort {
  FirestoreRouletteRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.rouletteItems);

  @override
  Future<List<RouletteItem>> getAll() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => RouletteItemDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Future<RouletteItem?> getById(RouletteItemId id) async {
    final doc = await _col.doc(id.value).get();
    final data = doc.data();
    return data == null ? null : RouletteItemDto.fromJson(data).toDomain();
  }

  @override
  Future<void> save(RouletteItem item) =>
      _col.doc(item.id.value).set(item.toDto().toJson());

  @override
  Future<void> saveAll(List<RouletteItem> items) async {
    // Firestore limita a 500 operaciones por batch; troceamos por seguridad.
    const chunkSize = 400;
    for (var i = 0; i < items.length; i += chunkSize) {
      final batch = _db.batch();
      for (final item in items.skip(i).take(chunkSize)) {
        batch.set(_col.doc(item.id.value), item.toDto().toJson());
      }
      await batch.commit();
    }
  }

  @override
  Future<void> delete(RouletteItemId id) => _col.doc(id.value).delete();
}

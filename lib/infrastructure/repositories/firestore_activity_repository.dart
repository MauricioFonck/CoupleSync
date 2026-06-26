import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/activity.dart';
import '../../domain/ports/activity_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/activity_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreActivityRepository implements ActivityRepositoryPort {
  FirestoreActivityRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.activities);

  @override
  Future<List<Activity>> getAll() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => ActivityDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Future<List<Activity>> getActive() async {
    final snap = await _col.where('active', isEqualTo: true).get();
    return snap.docs
        .map((d) => ActivityDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Future<Activity?> getById(ActivityId id) async {
    final doc = await _col.doc(id.value).get();
    final data = doc.data();
    return data == null ? null : ActivityDto.fromJson(data).toDomain();
  }

  @override
  Future<void> save(Activity activity) =>
      _col.doc(activity.id.value).set(activity.toDto().toJson());

  @override
  Future<void> delete(ActivityId id) => _col.doc(id.value).delete();
}

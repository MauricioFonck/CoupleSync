import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/availability.dart';
import '../../domain/ports/availability_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/availability_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreAvailabilityRepository implements AvailabilityRepositoryPort {
  FirestoreAvailabilityRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.availability);

  @override
  Future<Availability> getForUser(UserId userId) async {
    final doc = await _col.doc(userId.value).get();
    final data = doc.data();
    return data == null
        ? Availability.empty(userId)
        : AvailabilityDto.fromJson(data).toDomain();
  }

  @override
  Stream<Availability> watchForUser(UserId userId) =>
      _col.doc(userId.value).snapshots().map((doc) {
        final data = doc.data();
        return data == null
            ? Availability.empty(userId)
            : AvailabilityDto.fromJson(data).toDomain();
      });

  @override
  Future<void> save(Availability availability) =>
      _col.doc(availability.userId.value).set(availability.toDto().toJson());
}

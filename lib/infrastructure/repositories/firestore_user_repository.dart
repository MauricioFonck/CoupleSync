import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';
import '../../domain/ports/user_repository_port.dart';
import '../firebase/dtos/user_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreUserRepository implements UserRepositoryPort {
  FirestoreUserRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.users);

  @override
  Future<List<User>> getAll() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => d.data())
        // Solo docs con perfil (puede haber docs con solo fcmTokens).
        .where((data) => data['displayName'] != null && data['id'] != null)
        .map((data) => UserDto.fromJson(data).toDomain())
        .toList();
  }

  @override
  Future<void> upsert(User user) => _col
      .doc(user.id.value)
      .set(user.toDto().toJson(), SetOptions(merge: true));
}

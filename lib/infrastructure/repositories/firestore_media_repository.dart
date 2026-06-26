import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/media_blob.dart';
import '../../domain/ports/media_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/media_blob_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

/// Repositorio de imágenes Base64 en la colección `media` (separada de las
/// entidades, ver D1).
class FirestoreMediaRepository implements MediaRepositoryPort {
  FirestoreMediaRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.media);

  @override
  Future<MediaId> save(MediaBlob blob) async {
    await _col.doc(blob.id.value).set(blob.toDto().toJson());
    return blob.id;
  }

  @override
  Future<MediaBlob?> getById(MediaId id) async {
    final doc = await _col.doc(id.value).get();
    final data = doc.data();
    return data == null ? null : MediaBlobDto.fromJson(data).toDomain();
  }

  @override
  Future<void> delete(MediaId id) => _col.doc(id.value).delete();
}

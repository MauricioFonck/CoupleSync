import '../entities/media_blob.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de imágenes Base64 (colección `media`, ver D1).
abstract interface class MediaRepositoryPort {
  /// Persiste el blob y devuelve su id.
  Future<MediaId> save(MediaBlob blob);
  Future<MediaBlob?> getById(MediaId id);
  Future<void> delete(MediaId id);
}

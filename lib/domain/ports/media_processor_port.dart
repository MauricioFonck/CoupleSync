import '../entities/media_blob.dart';
import '../value_objects/ids.dart';

/// Puerto que comprime/redimensiona una imagen y la codifica en Base64,
/// produciendo un [MediaBlob] listo para persistir (ver D1). La implementación
/// concreta (web-compatible) vive en infraestructura.
abstract interface class MediaProcessorPort {
  MediaBlob process({required List<int> bytes, required UserId createdBy});
}

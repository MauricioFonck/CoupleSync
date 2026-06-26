import '../exceptions/domain_exception.dart';
import '../value_objects/ids.dart';

/// Imagen comprimida almacenada en Base64 en la colección `media/{mediaId}`
/// (decisión D1). El blob se separa de la entidad dueña, que solo guarda
/// `imageId`, para no descargar imágenes al listar.
final class MediaBlob {
  MediaBlob({
    required this.id,
    required this.base64,
    required this.mime,
    required this.width,
    required this.height,
    required this.byteSize,
    required this.createdBy,
    required this.createdAt,
  }) {
    if (base64.isEmpty) {
      throw const DomainValidationException('El Base64 no puede estar vacío.');
    }
    if (byteSize <= 0) {
      throw const DomainValidationException('byteSize debe ser positivo.');
    }
    if (byteSize > maxBytes) {
      throw DomainValidationException(
        'Imagen demasiado grande: $byteSize bytes (máx $maxBytes). '
        'Comprime/redimensiona antes de codificar (ver D1).',
      );
    }
    if (width <= 0 || height <= 0) {
      throw const DomainValidationException('Dimensiones inválidas.');
    }
  }

  /// Umbral de guarda muy por debajo del límite de 1 MiB/documento de Firestore.
  static const int maxBytes = 700 * 1024;

  final MediaId id;
  final String base64;
  final String mime;
  final int width;
  final int height;
  final int byteSize;
  final UserId createdBy;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaBlob &&
          other.id == id &&
          other.base64 == base64 &&
          other.mime == mime &&
          other.width == width &&
          other.height == height &&
          other.byteSize == byteSize &&
          other.createdBy == createdBy &&
          other.createdAt == createdAt);

  @override
  int get hashCode => Object.hash(
    id,
    base64,
    mime,
    width,
    height,
    byteSize,
    createdBy,
    createdAt,
  );

  @override
  String toString() =>
      'MediaBlob($id, $mime, ${width}x$height, $byteSize bytes)';
}

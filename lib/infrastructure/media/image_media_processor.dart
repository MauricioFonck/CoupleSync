import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../domain/entities/media_blob.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/ports/clock_port.dart';
import '../../domain/ports/id_generator_port.dart';
import '../../domain/ports/media_processor_port.dart';
import '../../domain/value_objects/ids.dart';

/// Implementación de [MediaProcessorPort] con el paquete `image` (Dart puro,
/// funciona en web): redimensiona el lado mayor a [maxDimension], comprime a
/// JPEG calidad [quality] y codifica en Base64 (ver D1).
class ImageMediaProcessor implements MediaProcessorPort {
  ImageMediaProcessor({
    required IdGeneratorPort idGenerator,
    required ClockPort clock,
    this.maxDimension = 1000,
    this.quality = 80,
  })  : _idGenerator = idGenerator,
        _clock = clock;

  final IdGeneratorPort _idGenerator;
  final ClockPort _clock;
  final int maxDimension;
  final int quality;

  @override
  MediaBlob process({required List<int> bytes, required UserId createdBy}) {
    img.Image? decoded;
    try {
      decoded = img.decodeImage(Uint8List.fromList(bytes));
    } on Object {
      decoded = null;
    }
    if (decoded == null) {
      throw const DomainValidationException(
        'La imagen no se pudo decodificar.',
      );
    }

    final resized = decoded.width >= decoded.height
        ? img.copyResize(
            decoded,
            width: decoded.width > maxDimension ? maxDimension : decoded.width,
          )
        : img.copyResize(
            decoded,
            height:
                decoded.height > maxDimension ? maxDimension : decoded.height,
          );

    final jpg = img.encodeJpg(resized, quality: quality);
    final base64Str = base64Encode(jpg);

    // El constructor de MediaBlob valida que byteSize <= umbral (< 1 MiB).
    return MediaBlob(
      id: MediaId(_idGenerator.newId()),
      base64: base64Str,
      mime: 'image/jpeg',
      width: resized.width,
      height: resized.height,
      byteSize: base64Str.length,
      createdBy: createdBy,
      createdAt: _clock.now(),
    );
  }
}

import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/infrastructure/media/image_media_processor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import '../domain/use_cases/_fakes.dart';

void main() {
  final userA = UserId('A');

  ImageMediaProcessor processor() => ImageMediaProcessor(
    idGenerator: SeqIdGenerator(),
    clock: FakeClock(DateTime.utc(2026, 6, 21)),
    maxDimension: 1000,
    quality: 80,
  );

  test('redimensiona el lado mayor a maxDimension y codifica JPEG/Base64', () {
    final source = img.Image(width: 2000, height: 1000);
    final png = img.encodePng(source);

    final blob = processor().process(bytes: png, createdBy: userA);

    expect(blob.mime, 'image/jpeg');
    expect(blob.width, 1000);
    expect(blob.height, 500);
    expect(blob.base64, isNotEmpty);
    expect(blob.byteSize, blob.base64.length);
    expect(blob.createdBy, userA);
  });

  test('no amplía imágenes más pequeñas que maxDimension', () {
    final source = img.Image(width: 400, height: 300);
    final png = img.encodePng(source);
    final blob = processor().process(bytes: png, createdBy: userA);
    expect(blob.width, 400);
    expect(blob.height, 300);
  });

  test('rechaza bytes no decodificables', () {
    expect(
      () => processor().process(bytes: [1, 2, 3], createdBy: userA),
      throwsA(isA<DomainValidationException>()),
    );
  });
}

import 'package:couplesync/domain/entities/media_blob.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MediaBlob build({int byteSize = 1000, String base64 = 'AAAA'}) => MediaBlob(
    id: MediaId('m1'),
    base64: base64,
    mime: 'image/jpeg',
    width: 800,
    height: 600,
    byteSize: byteSize,
    createdBy: UserId('A'),
    createdAt: DateTime.utc(2026, 6, 1),
  );

  group('MediaBlob', () {
    test('válido bajo el umbral', () {
      expect(build().byteSize, 1000);
    });

    test('rechaza base64 vacío', () {
      expect(
        () => build(base64: ''),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('rechaza tamaño por encima del umbral (1 MiB Firestore)', () {
      expect(
        () => build(byteSize: MediaBlob.maxBytes + 1),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });
}

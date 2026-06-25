import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityCategory', () {
    test('normaliza recortando espacios', () {
      expect(ActivityCategory('  Cine  ').value, 'Cine');
    });

    test('rechaza vacío', () {
      expect(
        () => ActivityCategory('   '),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('rechaza longitud excesiva', () {
      expect(
        () => ActivityCategory('x' * 41),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('igualdad por valor normalizado', () {
      expect(ActivityCategory('Cena'), ActivityCategory(' Cena '));
    });
  });
}

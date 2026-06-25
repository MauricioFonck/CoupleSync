import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Identifiers', () {
    test('aceptan un valor no vacío', () {
      expect(ActivityId('act-1').value, 'act-1');
      expect(UserId('uid-A').value, 'uid-A');
    });

    test('rechazan vacío o solo espacios', () {
      expect(() => ActivityId(''), throwsA(isA<DomainValidationException>()));
      expect(() => UserId('   '), throwsA(isA<DomainValidationException>()));
    });

    test('igualdad por valor dentro del mismo tipo', () {
      expect(ActivityId('x'), ActivityId('x'));
      expect(ActivityId('x').hashCode, ActivityId('x').hashCode);
      expect(ActivityId('x'), isNot(ActivityId('y')));
    });

    test('tipos distintos con mismo valor NO son iguales', () {
      expect(ActivityId('same'), isNot(PenaltyId('same')));
      // ignore: unrelated_type_equality_checks
      expect(UserId('same') == MediaId('same'), isFalse);
    });
  });
}

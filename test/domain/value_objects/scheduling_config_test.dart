import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/scheduling_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchedulingConfig', () {
    test('defaults razonables', () {
      final c = SchedulingConfig.defaults();
      expect(c.daysPerWeek, 3);
      expect(c.activitiesPerDay, 1);
    });

    test('rechaza daysPerWeek fuera de 1..7', () {
      expect(
        () => SchedulingConfig(daysPerWeek: 8, activitiesPerDay: 1),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('rechaza activitiesPerDay < 1', () {
      expect(
        () => SchedulingConfig(daysPerWeek: 3, activitiesPerDay: 0),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });
}

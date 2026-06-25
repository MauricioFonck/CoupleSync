import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/time_slot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeSlot', () {
    test('válido con start < end', () {
      final s = TimeSlot.fromHm(
        startHour: 9,
        startMinute: 0,
        endHour: 11,
        endMinute: 30,
      );
      expect(s.startMinutes, 540);
      expect(s.endMinutes, 690);
    });

    test('rechaza start >= end', () {
      expect(
        () => TimeSlot(startMinutes: 600, endMinutes: 600),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('rechaza valores fuera de rango', () {
      expect(
        () => TimeSlot(startMinutes: -1, endMinutes: 100),
        throwsA(isA<DomainValidationException>()),
      );
      expect(
        () => TimeSlot(startMinutes: 0, endMinutes: 1500),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('overlaps adyacentes no se solapan', () {
      final a = TimeSlot(startMinutes: 540, endMinutes: 600);
      final b = TimeSlot(startMinutes: 600, endMinutes: 660);
      final c = TimeSlot(startMinutes: 580, endMinutes: 620);
      expect(a.overlaps(b), isFalse);
      expect(a.overlaps(c), isTrue);
    });
  });
}

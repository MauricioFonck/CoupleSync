import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/date_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRange', () {
    final start = DateTime.utc(2026, 6, 1);
    final end = DateTime.utc(2026, 6, 7);

    test('válido cuando end >= start', () {
      final r = DateRange(start: start, end: end);
      expect(r.duration, const Duration(days: 6));
    });

    test('rechaza end anterior a start', () {
      expect(
        () => DateRange(start: end, end: start),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('contains es inclusivo en los extremos', () {
      final r = DateRange(start: start, end: end);
      expect(r.contains(start), isTrue);
      expect(r.contains(end), isTrue);
      expect(r.contains(DateTime.utc(2026, 6, 4)), isTrue);
      expect(r.contains(DateTime.utc(2026, 5, 31)), isFalse);
    });

    test('overlaps detecta solapes y exclusiones', () {
      final r = DateRange(start: start, end: end);
      final touching = DateRange(end: DateTime.utc(2026, 6, 10), start: end);
      final apart = DateRange(
        start: DateTime.utc(2026, 6, 8),
        end: DateTime.utc(2026, 6, 9),
      );
      expect(r.overlaps(touching), isTrue);
      expect(r.overlaps(apart), isFalse);
    });
  });
}

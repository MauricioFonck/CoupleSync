import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeekId', () {
    test('acepta formato canónico y expone año/semana', () {
      final w = WeekId('2026-W26');
      expect(w.isoYear, 2026);
      expect(w.isoWeek, 26);
    });

    test('rechaza formatos inválidos', () {
      expect(
        () => WeekId('2026-26'),
        throwsA(isA<DomainValidationException>()),
      );
      expect(() => WeekId('26-W01'), throwsA(isA<DomainValidationException>()));
      expect(
        () => WeekId('2026-W99'),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('fromDate calcula la semana ISO correcta', () {
      // 2026-01-01 es jueves -> semana ISO 1 de 2026.
      expect(WeekId.fromDate(DateTime.utc(2026, 1, 1)).value, '2026-W01');
      // 25-jun-2026 (jueves) -> semana 26.
      expect(WeekId.fromDate(DateTime.utc(2026, 6, 25)).value, '2026-W26');
    });

    test(
      'fromDate maneja el borde de año (1-ene pertenece a semana previa)',
      () {
        // 2023-01-01 es domingo -> pertenece a la semana 52 de 2022.
        expect(WeekId.fromDate(DateTime.utc(2023, 1, 1)).value, '2022-W52');
      },
    );

    test('igualdad por valor', () {
      expect(WeekId('2026-W26'), WeekId('2026-W26'));
      expect(WeekId('2026-W26'), isNot(WeekId('2026-W27')));
    });
  });
}

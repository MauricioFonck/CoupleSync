import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Jerarquía de excepciones de dominio', () {
    test('todas son DomainException y Exception', () {
      final exceptions = <DomainException>[
        const DomainValidationException('v'),
        const DomainInvariantException('i'),
        const EntityNotFoundException('nf', entity: 'Activity', id: 'a1'),
        const ScheduleGenerationConflictException('c', weekId: '2026-W26'),
      ];
      for (final e in exceptions) {
        expect(e, isA<DomainException>());
        expect(e, isA<Exception>());
        expect(e.message, isNotEmpty);
      }
    });

    test('toString incluye contexto útil', () {
      expect(
        const EntityNotFoundException('no existe', entity: 'Activity', id: 'a1')
            .toString(),
        contains('Activity'),
      );
      expect(
        const ScheduleGenerationConflictException('dup', weekId: '2026-W26')
            .toString(),
        contains('2026-W26'),
      );
    });
  });
}

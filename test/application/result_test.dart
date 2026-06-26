import 'package:couplesync/application/app_failure.dart';
import 'package:couplesync/application/result.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Ok expone value y fold', () {
      const r = Ok<int>(42);
      expect(r.isOk, isTrue);
      expect(r.valueOrNull, 42);
      expect(r.failureOrNull, isNull);
      expect(r.fold((v) => 'v$v', (f) => 'e'), 'v42');
    });

    test('Err expone failure y fold', () {
      const r = Err<int>(
        AppFailure(kind: FailureKind.notFound, message: 'x'),
      );
      expect(r.isErr, isTrue);
      expect(r.valueOrNull, isNull);
      expect(r.failureOrNull!.kind, FailureKind.notFound);
      expect(r.fold((v) => 'v', (f) => 'e:${f.message}'), 'e:x');
    });
  });

  group('AppFailure.fromException', () {
    test('clasifica excepciones de dominio', () {
      expect(
        AppFailure.fromException(const DomainValidationException('a')).kind,
        FailureKind.validation,
      );
      expect(
        AppFailure.fromException(const DomainInvariantException('a')).kind,
        FailureKind.invariant,
      );
      expect(
        AppFailure.fromException(const EntityNotFoundException('a')).kind,
        FailureKind.notFound,
      );
      expect(
        AppFailure.fromException(
          const ScheduleGenerationConflictException('a', weekId: '2026-W26'),
        ).kind,
        FailureKind.conflict,
      );
    });

    test('cualquier otra excepción es unexpected', () {
      expect(
        AppFailure.fromException(StateError('boom')).kind,
        FailureKind.unexpected,
      );
    });
  });

  group('runCatching', () {
    test('envuelve el éxito en Ok', () async {
      final r = await runCatching<int>(() async => 7);
      expect(r.valueOrNull, 7);
    });

    test('traduce la excepción a Err', () async {
      final r = await runCatching<int>(
        () async => throw const DomainValidationException('no'),
      );
      expect(r.failureOrNull!.kind, FailureKind.validation);
    });
  });
}

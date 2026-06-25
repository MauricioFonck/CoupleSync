import 'package:couplesync/domain/value_objects/severity.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Severity', () {
    test('orden por peso', () {
      expect(Severity.high > Severity.low, isTrue);
      expect(Severity.low < Severity.medium, isTrue);
    });
  });

  group('CompletionStatus', () {
    test('pending y closed', () {
      expect(CompletionStatus.pending.isPending, isTrue);
      expect(CompletionStatus.completed.isClosed, isTrue);
      expect(CompletionStatus.missed.isClosed, isTrue);
      expect(CompletionStatus.rescheduled.isClosed, isFalse);
    });
  });

  group('ConfirmationStatus', () {
    test('approved y resolved', () {
      expect(ConfirmationStatus.approved.isApproved, isTrue);
      expect(ConfirmationStatus.pending.isResolved, isFalse);
      expect(ConfirmationStatus.rejected.isResolved, isTrue);
    });
  });
}

import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/penalty.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/severity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Activity buildActivity() => Activity(
    id: ActivityId('a1'),
    title: 'Cena',
    description: 'Cena romántica',
    category: ActivityCategory('Comida'),
    createdBy: UserId('A'),
    active: true,
    imageId: MediaId('m1'),
    createdAt: DateTime.utc(2026, 6, 1),
    updatedAt: DateTime.utc(2026, 6, 1),
  );

  group('Activity', () {
    test('copyWith preserva id/createdBy/createdAt y cambia campos', () {
      final a = buildActivity();
      final b = a.copyWith(active: false, updatedAt: DateTime.utc(2026, 6, 2));
      expect(b.id, a.id);
      expect(b.createdBy, a.createdBy);
      expect(b.createdAt, a.createdAt);
      expect(b.active, isFalse);
      expect(b.updatedAt, DateTime.utc(2026, 6, 2));
    });

    test('clearImage elimina la imagen', () {
      final a = buildActivity();
      expect(a.copyWith(clearImage: true).imageId, isNull);
    });

    test('igualdad por valor', () {
      expect(buildActivity(), buildActivity());
    });
  });

  group('Penalty', () {
    test('copyWith cambia severidad y conserva id', () {
      final p = Penalty(
        id: PenaltyId('p1'),
        title: 'Lavar platos',
        description: 'Por una semana',
        severity: Severity.low,
        active: true,
      );
      final p2 = p.copyWith(severity: Severity.high);
      expect(p2.id, p.id);
      expect(p2.severity, Severity.high);
    });
  });
}

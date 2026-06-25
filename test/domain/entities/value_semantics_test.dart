import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/confirmation.dart';
import 'package:couplesync/domain/entities/media_blob.dart';
import 'package:couplesync/domain/entities/penalty.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/entities/streak_stats.dart';
import 'package:couplesync/domain/entities/user.dart';
import 'package:couplesync/domain/entities/weekly_schedule.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/date_range.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/severity.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/time_slot.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userA = UserId('A');

  test('User igualdad/copyWith/toString', () {
    final u1 = User(id: userA, displayName: 'Ana');
    final u2 = User(id: userA, displayName: 'Ana');
    expect(u1, u2);
    expect(u1.hashCode, u2.hashCode);
    expect(u1.copyWith(displayName: 'Bea').displayName, 'Bea');
    expect(u1.toString(), contains('Ana'));
  });

  test('Activity igualdad/hashCode/copyWith/toString', () {
    Activity a() => Activity(
          id: ActivityId('a1'),
          title: 'Cena',
          description: 'd',
          category: ActivityCategory('Comida'),
          createdBy: userA,
          active: true,
          imageId: MediaId('m1'),
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        );
    expect(a(), a());
    expect(a().hashCode, a().hashCode);
    expect(a().copyWith(title: 'Otra').title, 'Otra');
    expect(a().copyWith(description: 'x', category: ActivityCategory('C2')).category,
        ActivityCategory('C2'));
    expect(a().copyWith(imageId: MediaId('m2')).imageId, MediaId('m2'));
    expect(a().toString(), contains('Cena'));
    expect(a(), isNot(a().copyWith(active: false)));
  });

  test('Penalty igualdad/hashCode/copyWith/toString', () {
    Penalty p() => Penalty(
          id: PenaltyId('p1'),
          title: 'Lavar',
          description: 'd',
          severity: Severity.low,
          active: true,
          imageId: MediaId('m1'),
        );
    expect(p(), p());
    expect(p().hashCode, p().hashCode);
    expect(p().copyWith(clearImage: true).imageId, isNull);
    expect(p().copyWith(title: 't', description: 'q').title, 't');
    expect(p().toString(), contains('Lavar'));
    expect(p(), isNot(p().copyWith(active: false)));
  });

  test('Confirmation igualdad/hashCode/copyWith/toString', () {
    final c1 = Confirmation(
      userId: userA,
      activityId: ActivityId('a1'),
      status: ConfirmationStatus.pending,
    );
    final c2 = Confirmation(
      userId: userA,
      activityId: ActivityId('a1'),
      status: ConfirmationStatus.pending,
    );
    expect(c1, c2);
    expect(c1.hashCode, c2.hashCode);
    expect(c1.copyWith(status: ConfirmationStatus.approved).status,
        ConfirmationStatus.approved);
    expect(c1.toString(), contains('Confirmation'));
    expect(c1, isNot(c1.copyWith(status: ConfirmationStatus.rejected)));
  });

  test('Availability igualdad/hashCode/toString', () {
    Availability av() => Availability(
          userId: userA,
          availableWeekdays: const {1, 2},
          slotsByWeekday: {
            1: [TimeSlot(startMinutes: 540, endMinutes: 600)],
          },
          blockedDates: {DateTime.utc(2026, 6, 25)},
          unavailablePeriods: [
            DateRange(
              start: DateTime.utc(2026, 7, 1),
              end: DateTime.utc(2026, 7, 2),
            ),
          ],
        );
    expect(av(), av());
    expect(av().hashCode, av().hashCode);
    expect(av().toString(), contains('Availability'));
  });

  test('ScheduledEvent igualdad/hashCode/copyWith/toString', () {
    ScheduledEvent e() => ScheduledEvent(
          id: ScheduledEventId('e1'),
          date: DateTime.utc(2026, 6, 25),
          weekId: WeekId('2026-W26'),
          activityIds: [ActivityId('a1')],
          status: CompletionStatus.pending,
          confirmations: const [],
          notes: 'nota',
          createdAt: DateTime.utc(2026, 6, 20),
        );
    expect(e(), e());
    expect(e().hashCode, e().hashCode);
    expect(e().copyWith(clearNotes: true).notes, isNull);
    expect(e().copyWith(notes: 'otra').notes, 'otra');
    expect(e().copyWith(activityIds: [ActivityId('a2')]).activityIds.single,
        ActivityId('a2'));
    expect(e().toString(), contains('ScheduledEvent'));
    expect(e(), isNot(e().copyWith(status: CompletionStatus.missed)));
  });

  test('WeeklySchedule igualdad/hashCode/toString', () {
    WeeklySchedule w() => WeeklySchedule(
          weekId: WeekId('2026-W26'),
          eventIds: [ScheduledEventId('e1')],
          generatedAt: DateTime.utc(2026, 6, 21),
        );
    expect(w(), w());
    expect(w().hashCode, w().hashCode);
    expect(w().toString(), contains('WeeklySchedule'));
    expect(
      w(),
      isNot(
        WeeklySchedule(
          weekId: WeekId('2026-W27'),
          eventIds: const [],
          generatedAt: DateTime.utc(2026, 6, 21),
        ),
      ),
    );
  });

  test('MediaBlob igualdad/hashCode/toString', () {
    MediaBlob m() => MediaBlob(
          id: MediaId('m1'),
          base64: 'AAAA',
          mime: 'image/jpeg',
          width: 800,
          height: 600,
          byteSize: 1000,
          createdBy: userA,
          createdAt: DateTime.utc(2026),
        );
    expect(m(), m());
    expect(m().hashCode, m().hashCode);
    expect(m().toString(), contains('image/jpeg'));
  });

  test('StreakStats igualdad/hashCode/toString', () {
    final s1 = StreakStats.zero();
    final s2 = StreakStats.zero();
    expect(s1, s2);
    expect(s1.hashCode, s2.hashCode);
    expect(s1.toString(), contains('StreakStats'));
    expect(
      s1,
      isNot(
        StreakStats(
          currentStreak: 1,
          bestStreak: 1,
          weeklyCompletionRate: 0,
          monthlyCompletionRate: 0,
          yearlyCompletionRate: 0,
        ),
      ),
    );
  });
}

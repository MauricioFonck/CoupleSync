import 'dart:math' as math;

import '../entities/activity.dart';
import '../entities/scheduled_event.dart';
import '../entities/weekly_schedule.dart';
import '../exceptions/domain_exception.dart';
import '../ports/activity_repository_port.dart';
import '../ports/availability_repository_port.dart';
import '../ports/clock_port.dart';
import '../ports/random_port.dart';
import '../ports/settings_repository_port.dart';
import '../ports/weekly_schedule_repository_port.dart';
import '../value_objects/ids.dart';
import '../value_objects/statuses.dart';
import '../value_objects/week_id.dart';

/// Genera la agenda de una semana respetando la disponibilidad de **ambos**
/// usuarios, evitando repeticiones consecutivas y manteniendo variedad.
///
/// Es el núcleo del *lazy generation* (D2). La atomicidad contra doble
/// generación la garantiza `WeeklyScheduleRepositoryPort.saveGenerated`
/// (guard `weeklySchedules/{weekId}`).
class GenerateWeeklyScheduleUseCase {
  const GenerateWeeklyScheduleUseCase({
    required ActivityRepositoryPort activityRepository,
    required AvailabilityRepositoryPort availabilityRepository,
    required SettingsRepositoryPort settingsRepository,
    required WeeklyScheduleRepositoryPort weeklyScheduleRepository,
    required ClockPort clock,
    required RandomPort random,
  }) : _activities = activityRepository,
       _availability = availabilityRepository,
       _settings = settingsRepository,
       _weekly = weeklyScheduleRepository,
       _clock = clock,
       _random = random;

  final ActivityRepositoryPort _activities;
  final AvailabilityRepositoryPort _availability;
  final SettingsRepositoryPort _settings;
  final WeeklyScheduleRepositoryPort _weekly;
  final ClockPort _clock;
  final RandomPort _random;

  Future<WeeklySchedule> execute({
    required WeekId targetWeek,
    required UserId partnerA,
    required UserId partnerB,
  }) async {
    if (await _weekly.exists(targetWeek)) {
      throw ScheduleGenerationConflictException(
        'La agenda de $targetWeek ya existe.',
        weekId: targetWeek.value,
      );
    }

    final config = await _settings.getSchedulingConfig();
    final active = await _activities.getActive();
    if (active.isEmpty) {
      throw const DomainInvariantException(
        'No hay actividades activas para generar la agenda.',
      );
    }

    final availA = await _availability.getForUser(partnerA);
    final availB = await _availability.getForUser(partnerB);

    final bothAvailable = targetWeek.daysUtc
        .where((d) => availA.isDayAvailable(d) && availB.isDayAvailable(d))
        .toList();

    final dayCount = math.min(config.daysPerWeek, bothAvailable.length);
    final chosenDays = _random.shuffled(bothAvailable).take(dayCount).toList()
      ..sort((a, b) => a.compareTo(b));

    final perDayActivities = _selectActivities(
      active: active,
      days: chosenDays.length,
      perDay: config.activitiesPerDay,
    );

    final now = _clock.now();
    final events = <ScheduledEvent>[];
    for (var i = 0; i < chosenDays.length; i++) {
      final date = chosenDays[i];
      events.add(
        ScheduledEvent(
          id: _eventId(targetWeek, date),
          date: date,
          weekId: targetWeek,
          activityIds: perDayActivities[i],
          status: CompletionStatus.pending,
          confirmations: const [],
          createdAt: now,
        ),
      );
    }

    final schedule = WeeklySchedule(
      weekId: targetWeek,
      eventIds: events.map((e) => e.id).toList(),
      generatedAt: now,
    );

    await _weekly.saveGenerated(schedule: schedule, events: events);
    return schedule;
  }

  ScheduledEventId _eventId(WeekId week, DateTime date) {
    final key = '${date.year}${_pad(date.month)}${_pad(date.day)}';
    return ScheduledEventId('evt_${week.value}_$key');
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  /// Selecciona las actividades de cada día. Mantiene variedad (consume el pool
  /// barajado antes de reciclar) y evita repetir las del día anterior.
  List<List<ActivityId>> _selectActivities({
    required List<Activity> active,
    required int days,
    required int perDay,
  }) {
    final allIds = active.map((a) => a.id).toList();
    final result = <List<ActivityId>>[];
    var pool = _random.shuffled(allIds);
    var previousDay = <ActivityId>{};

    for (var d = 0; d < days; d++) {
      final dayPick = <ActivityId>[];
      while (dayPick.length < perDay) {
        var candidate = _nextCandidate(pool, previousDay, dayPick);
        if (candidate == null) {
          // Pool agotado: recicla manteniendo variedad.
          pool = _random.shuffled(allIds);
          candidate = _nextCandidate(pool, previousDay, dayPick);
        }
        // Sin distintos suficientes (perDay grande): permite repetir hoy
        // pero nunca del día anterior si hay alternativa.
        candidate ??= _random
            .shuffled(allIds)
            .firstWhere(
              (id) => !dayPick.contains(id),
              orElse: () => allIds.first,
            );
        dayPick.add(candidate);
        pool.remove(candidate);
      }
      result.add(dayPick);
      previousDay = dayPick.toSet();
    }
    return result;
  }

  ActivityId? _nextCandidate(
    List<ActivityId> pool,
    Set<ActivityId> previousDay,
    List<ActivityId> dayPick,
  ) {
    for (final id in pool) {
      if (!previousDay.contains(id) && !dayPick.contains(id)) {
        return id;
      }
    }
    return null;
  }
}

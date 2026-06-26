import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/commands/commands.dart';
import '../../application/queries/queries.dart';
import '../../domain/entities/scheduled_event.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/week_id.dart';
import 'app_providers.dart';

/// Semana visible en la agenda (por defecto, la semana actual).
final scheduleWeekProvider =
    NotifierProvider<ScheduleWeekNotifier, WeekId>(ScheduleWeekNotifier.new);

class ScheduleWeekNotifier extends Notifier<WeekId> {
  @override
  WeekId build() => WeekId.fromDate(DateTime.now());

  void setWeek(WeekId week) => state = week;
}

/// Eventos de la semana seleccionada, ordenados por fecha.
final scheduleControllerProvider =
    AsyncNotifierProvider<ScheduleController, List<ScheduledEvent>>(
  ScheduleController.new,
);

class ScheduleController extends AsyncNotifier<List<ScheduledEvent>> {
  @override
  Future<List<ScheduledEvent>> build() async {
    final week = ref.watch(scheduleWeekProvider);
    final result = await ref
        .read(schedulingServiceProvider)
        .eventsOfWeek(WeekEventsQuery(week));
    return result.fold(
      (events) => events.toList()..sort((a, b) => a.date.compareTo(b.date)),
      (failure) => throw failure,
    );
  }

  Future<AppFailure?> reschedule(ScheduledEventId id, DateTime newDate) async {
    final result = await ref.read(schedulingServiceProvider).reschedule(
          RescheduleEventCommand(eventId: id, newDate: newDate),
        );
    final failure = result.failureOrNull;
    if (failure == null) {
      state = await AsyncValue.guard(build);
    }
    return failure;
  }
}

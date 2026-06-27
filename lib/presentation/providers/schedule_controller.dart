import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/commands/commands.dart';
import '../../application/services/scheduling_service.dart';
import '../../domain/entities/scheduled_event.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/week_id.dart';
import 'app_providers.dart';

/// Semana visible en la agenda (por defecto, la semana actual).
final scheduleWeekProvider = NotifierProvider<ScheduleWeekNotifier, WeekId>(
  ScheduleWeekNotifier.new,
);

class ScheduleWeekNotifier extends Notifier<WeekId> {
  @override
  WeekId build() => WeekId.fromDate(DateTime.now());

  void setWeek(WeekId week) => state = week;
}

/// Eventos de la semana seleccionada **en tiempo real**, ordenados por fecha.
final scheduleEventsProvider = StreamProvider<List<ScheduledEvent>>((ref) {
  final week = ref.watch(scheduleWeekProvider);
  return ref
      .watch(schedulingServiceProvider)
      .watchWeek(week)
      .map(
        (events) => events.toList()..sort((a, b) => a.date.compareTo(b.date)),
      );
});

/// Acciones sobre la agenda (reprogramación). Los cambios se reflejan solos.
final scheduleActionsProvider = Provider<ScheduleActions>(
  (ref) => ScheduleActions(ref.read(schedulingServiceProvider)),
);

class ScheduleActions {
  const ScheduleActions(this._service);

  final SchedulingService _service;

  Future<AppFailure?> reschedule(ScheduledEventId id, DateTime newDate) async =>
      (await _service.reschedule(
        RescheduleEventCommand(eventId: id, newDate: newDate),
      )).failureOrNull;
}

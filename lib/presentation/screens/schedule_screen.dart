import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/scheduled_event.dart';
import '../../domain/value_objects/statuses.dart';
import '../../domain/value_objects/week_id.dart';
import '../providers/schedule_controller.dart';
import 'confirmations_screen.dart';

String statusLabel(CompletionStatus s) => switch (s) {
  CompletionStatus.pending => 'Pendiente',
  CompletionStatus.completed => 'Completado',
  CompletionStatus.missed => 'Fallido',
  CompletionStatus.rescheduled => 'Reprogramado',
};

/// Vista de la agenda semanal con navegación de semanas y reprogramación.
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  void _shiftWeek(WidgetRef ref, int deltaDays) {
    final current = ref.read(scheduleWeekProvider);
    final newMonday = current.mondayUtc.add(Duration(days: deltaDays));
    ref.read(scheduleWeekProvider.notifier).setWeek(WeekId.fromDate(newMonday));
  }

  Future<void> _reschedule(
    BuildContext context,
    WidgetRef ref,
    ScheduledEvent event,
  ) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(event.date.year - 1),
      lastDate: DateTime(event.date.year + 1),
      initialDate: event.date,
    );
    if (picked == null) return;
    await ref
        .read(scheduleControllerProvider.notifier)
        .reschedule(
          event.id,
          DateTime.utc(picked.year, picked.month, picked.day),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(scheduleWeekProvider);
    final state = ref.watch(scheduleControllerProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                key: const Key('week_prev'),
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _shiftWeek(ref, -7),
              ),
              Text(week.value, style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                key: const Key('week_next'),
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _shiftWeek(ref, 7),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (events) {
              if (events.isEmpty) {
                return const Center(child: Text('No hay eventos esta semana.'));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final e = events[index];
                  return ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(
                      '${e.date.day}/${e.date.month} · '
                      '${e.activityIds.length} actividad(es)',
                    ),
                    subtitle: Text('Estado: ${statusLabel(e.status)}'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ConfirmationsScreen(event: e),
                      ),
                    ),
                    trailing: IconButton(
                      key: Key('reschedule_${e.id.value}'),
                      icon: const Icon(Icons.edit_calendar),
                      onPressed: () => _reschedule(context, ref, e),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

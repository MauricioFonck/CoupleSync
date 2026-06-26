import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/history_controller.dart';
import 'schedule_screen.dart' show statusLabel;

/// Historial de eventos: actividad(es), fecha, estado.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('Sin historial todavía.'));
        }
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final e = events[index];
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(
                '${e.date.day}/${e.date.month}/${e.date.year} · '
                '${e.activityIds.length} actividad(es)',
              ),
              subtitle: Text('Estado: ${statusLabel(e.status)}'),
            );
          },
        );
      },
    );
  }
}

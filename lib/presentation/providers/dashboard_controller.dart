import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/streak_stats.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/statuses.dart';
import 'app_providers.dart';

/// Datos agregados para el dashboard (KPIs + rachas).
class DashboardData {
  const DashboardData({
    required this.stats,
    required this.scheduled,
    required this.completed,
    required this.pending,
    required this.missed,
  });

  final StreakStats stats;
  final int scheduled;
  final int completed;
  final int pending;
  final int missed;

  double get compliance => scheduled == 0 ? 0 : completed / scheduled;
}

/// KPIs y rachas **en tiempo real**: escucha el historial de eventos y, en cada
/// cambio, recalcula las rachas (persiste el snapshot) y agrega los contadores
/// por estado.
final dashboardProvider = StreamProvider<DashboardData>((ref) {
  final statistics = ref.watch(statisticsServiceProvider);
  final range = DateRange(start: DateTime.utc(2000), end: DateTime.utc(2100));

  return ref.watch(schedulingServiceProvider).watchHistory(range).asyncMap((
    events,
  ) async {
    final statsResult = await statistics.refresh();
    final stats = statsResult.fold(
      (value) => value,
      (failure) => throw failure,
    );

    int countBy(CompletionStatus status) =>
        events.where((e) => e.status == status).length;

    return DashboardData(
      stats: stats,
      scheduled: events.length,
      completed: countBy(CompletionStatus.completed),
      pending: countBy(CompletionStatus.pending),
      missed: countBy(CompletionStatus.missed),
    );
  });
});

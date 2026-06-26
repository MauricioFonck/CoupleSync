import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/scheduled_event.dart';
import '../../domain/value_objects/date_range.dart';
import 'app_providers.dart';

/// Historial completo de eventos, ordenado de más reciente a más antiguo.
final historyControllerProvider =
    AsyncNotifierProvider<HistoryController, List<ScheduledEvent>>(
  HistoryController.new,
);

class HistoryController extends AsyncNotifier<List<ScheduledEvent>> {
  @override
  Future<List<ScheduledEvent>> build() async {
    final range = DateRange(
      start: DateTime.utc(2000),
      end: DateTime.utc(2100),
    );
    final result = await ref.read(schedulingServiceProvider).history(range);
    return result.fold(
      (events) => events.toList()..sort((a, b) => b.date.compareTo(a.date)),
      (failure) => throw failure,
    );
  }
}

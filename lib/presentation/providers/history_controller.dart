import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/scheduled_event.dart';
import '../../domain/value_objects/date_range.dart';
import 'app_providers.dart';

/// Historial completo de eventos **en tiempo real**, de más reciente a más
/// antiguo.
final historyProvider = StreamProvider<List<ScheduledEvent>>((ref) {
  final range = DateRange(start: DateTime.utc(2000), end: DateTime.utc(2100));
  return ref
      .watch(schedulingServiceProvider)
      .watchHistory(range)
      .map(
        (events) => events.toList()..sort((a, b) => b.date.compareTo(a.date)),
      );
});

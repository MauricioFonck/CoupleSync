import '../entities/scheduled_event.dart';
import '../value_objects/date_range.dart';
import '../value_objects/ids.dart';
import '../value_objects/week_id.dart';

/// Puerto de persistencia de eventos programados.
abstract interface class ScheduledEventRepositoryPort {
  Future<ScheduledEvent?> getById(ScheduledEventId id);
  Future<List<ScheduledEvent>> getByWeek(WeekId weekId);
  Future<List<ScheduledEvent>> getByDateRange(DateRange range);
  Future<void> save(ScheduledEvent event);
}

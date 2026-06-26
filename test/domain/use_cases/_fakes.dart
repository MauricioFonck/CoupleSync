import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/confirmation.dart';
import 'package:couplesync/domain/entities/penalty.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/entities/streak_stats.dart';
import 'package:couplesync/domain/entities/user.dart';
import 'package:couplesync/domain/entities/weekly_schedule.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/ports/activity_repository_port.dart';
import 'package:couplesync/domain/ports/availability_repository_port.dart';
import 'package:couplesync/domain/ports/clock_port.dart';
import 'package:couplesync/domain/ports/confirmation_repository_port.dart';
import 'package:couplesync/domain/ports/id_generator_port.dart';
import 'package:couplesync/domain/ports/penalty_repository_port.dart';
import 'package:couplesync/domain/ports/random_port.dart';
import 'package:couplesync/domain/ports/scheduled_event_repository_port.dart';
import 'package:couplesync/domain/ports/settings_repository_port.dart';
import 'package:couplesync/domain/ports/statistics_repository_port.dart';
import 'package:couplesync/domain/ports/user_repository_port.dart';
import 'package:couplesync/domain/ports/weekly_schedule_repository_port.dart';
import 'package:couplesync/domain/value_objects/date_range.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/scheduling_config.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';

/// Reloj fijo.
class FakeClock implements ClockPort {
  FakeClock(this._now);
  final DateTime _now;
  @override
  DateTime now() => _now;
}

/// Aleatoriedad determinista: `shuffled` devuelve la lista sin cambios y
/// `nextInt` un valor fijo configurable.
class FakeRandom implements RandomPort {
  FakeRandom({this.fixedInt = 0});
  final int fixedInt;
  @override
  int nextInt(int max) => fixedInt % max;
  @override
  List<T> shuffled<T>(List<T> items) => List<T>.of(items);
}

/// Genera ids incrementales (`id-1`, `id-2`, ...).
class SeqIdGenerator implements IdGeneratorPort {
  int _n = 0;
  @override
  String newId() => 'id-${++_n}';
}

class InMemoryActivityRepository implements ActivityRepositoryPort {
  final Map<String, Activity> store = {};
  @override
  Future<void> delete(ActivityId id) async => store.remove(id.value);
  @override
  Future<List<Activity>> getActive() async =>
      store.values.where((a) => a.active).toList();
  @override
  Future<List<Activity>> getAll() async => store.values.toList();
  @override
  Future<Activity?> getById(ActivityId id) async => store[id.value];
  @override
  Future<void> save(Activity activity) async =>
      store[activity.id.value] = activity;
}

class InMemoryPenaltyRepository implements PenaltyRepositoryPort {
  final Map<String, Penalty> store = {};
  @override
  Future<void> delete(PenaltyId id) async => store.remove(id.value);
  @override
  Future<List<Penalty>> getActive() async =>
      store.values.where((p) => p.active).toList();
  @override
  Future<List<Penalty>> getAll() async => store.values.toList();
  @override
  Future<Penalty?> getById(PenaltyId id) async => store[id.value];
  @override
  Future<void> save(Penalty penalty) async => store[penalty.id.value] = penalty;
}

class InMemoryAvailabilityRepository implements AvailabilityRepositoryPort {
  final Map<String, Availability> store = {};
  @override
  Future<Availability> getForUser(UserId userId) async =>
      store[userId.value] ?? Availability.empty(userId);
  @override
  Future<void> save(Availability availability) async =>
      store[availability.userId.value] = availability;
}

class InMemoryScheduledEventRepository implements ScheduledEventRepositoryPort {
  final Map<String, ScheduledEvent> store = {};
  @override
  Future<ScheduledEvent?> getById(ScheduledEventId id) async => store[id.value];
  @override
  Future<List<ScheduledEvent>> getByWeek(WeekId weekId) async =>
      store.values.where((e) => e.weekId == weekId).toList();
  @override
  Future<List<ScheduledEvent>> getByDateRange(DateRange range) async =>
      store.values.where((e) => range.contains(e.date)).toList();
  @override
  Future<void> save(ScheduledEvent event) async =>
      store[event.id.value] = event;
}

class InMemoryConfirmationRepository implements ConfirmationRepositoryPort {
  final Map<String, List<Confirmation>> store = {};
  @override
  Future<List<Confirmation>> getForEvent(ScheduledEventId eventId) async =>
      store[eventId.value] ?? const [];
  @override
  Future<void> upsert(
    ScheduledEventId eventId,
    Confirmation confirmation,
  ) async {
    final list = store.putIfAbsent(eventId.value, () => []);
    list
      ..removeWhere(
        (c) =>
            c.userId == confirmation.userId &&
            c.activityId == confirmation.activityId,
      )
      ..add(confirmation);
  }
}

class InMemoryWeeklyScheduleRepository implements WeeklyScheduleRepositoryPort {
  final Map<String, WeeklySchedule> store = {};
  final List<ScheduledEvent> savedEvents = [];
  @override
  Future<bool> exists(WeekId weekId) async => store.containsKey(weekId.value);
  @override
  Future<WeeklySchedule?> getByWeek(WeekId weekId) async => store[weekId.value];
  @override
  Future<void> saveGenerated({
    required WeeklySchedule schedule,
    required List<ScheduledEvent> events,
  }) async {
    if (store.containsKey(schedule.weekId.value)) {
      throw ScheduleGenerationConflictException(
        'guard existente',
        weekId: schedule.weekId.value,
      );
    }
    store[schedule.weekId.value] = schedule;
    savedEvents.addAll(events);
  }
}

class InMemoryUserRepository implements UserRepositoryPort {
  final Map<String, User> store = {};
  @override
  Future<List<User>> getAll() async => store.values.toList();
  @override
  Future<void> upsert(User user) async => store[user.id.value] = user;
}

class InMemoryStatisticsRepository implements StatisticsRepositoryPort {
  StreakStats? stored;
  @override
  Future<StreakStats?> get() async => stored;
  @override
  Future<void> save(StreakStats stats) async => stored = stats;
}

class InMemorySettingsRepository implements SettingsRepositoryPort {
  InMemorySettingsRepository([SchedulingConfig? config])
    : _config = config ?? SchedulingConfig.defaults();
  SchedulingConfig _config;
  @override
  Future<SchedulingConfig> getSchedulingConfig() async => _config;
  @override
  Future<void> saveSchedulingConfig(SchedulingConfig config) async =>
      _config = config;
}

import '../../../domain/entities/activity.dart';
import '../../../domain/entities/availability.dart';
import '../../../domain/entities/confirmation.dart';
import '../../../domain/entities/media_blob.dart';
import '../../../domain/entities/penalty.dart';
import '../../../domain/entities/roulette_item.dart';
import '../../../domain/entities/roulette_spin.dart';
import '../../../domain/entities/scheduled_event.dart';
import '../../../domain/entities/streak_stats.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/weekly_schedule.dart';
import '../../../domain/value_objects/activity_category.dart';
import '../../../domain/value_objects/date_range.dart';
import '../../../domain/value_objects/ids.dart';
import '../../../domain/value_objects/intensity_level.dart';
import '../../../domain/value_objects/scheduling_config.dart';
import '../../../domain/value_objects/severity.dart';
import '../../../domain/value_objects/statuses.dart';
import '../../../domain/value_objects/time_slot.dart';
import '../../../domain/value_objects/week_id.dart';
import '../dtos/activity_dto.dart';
import '../dtos/availability_dto.dart';
import '../dtos/confirmation_dto.dart';
import '../dtos/date_range_dto.dart';
import '../dtos/media_blob_dto.dart';
import '../dtos/penalty_dto.dart';
import '../dtos/roulette_item_dto.dart';
import '../dtos/roulette_spin_dto.dart';
import '../dtos/scheduled_event_dto.dart';
import '../dtos/scheduling_config_dto.dart';
import '../dtos/streak_stats_dto.dart';
import '../dtos/time_slot_dto.dart';
import '../dtos/user_dto.dart';
import '../dtos/weekly_schedule_dto.dart';

// --- Activity ---
extension ActivityDtoMapper on ActivityDto {
  Activity toDomain() => Activity(
    id: ActivityId(id),
    title: title,
    description: description,
    category: ActivityCategory(category),
    createdBy: UserId(createdBy),
    active: active,
    imageId: imageId == null ? null : MediaId(imageId!),
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.parse(updatedAt),
  );
}

extension ActivityMapper on Activity {
  ActivityDto toDto() => ActivityDto(
    id: id.value,
    title: title,
    description: description,
    category: category.value,
    createdBy: createdBy.value,
    active: active,
    imageId: imageId?.value,
    createdAt: createdAt.toIso8601String(),
    updatedAt: updatedAt.toIso8601String(),
  );
}

// --- Penalty ---
extension PenaltyDtoMapper on PenaltyDto {
  Penalty toDomain() => Penalty(
    id: PenaltyId(id),
    title: title,
    description: description,
    severity: Severity.values.byName(severity),
    active: active,
    imageId: imageId == null ? null : MediaId(imageId!),
  );
}

extension PenaltyMapper on Penalty {
  PenaltyDto toDto() => PenaltyDto(
    id: id.value,
    title: title,
    description: description,
    severity: severity.name,
    active: active,
    imageId: imageId?.value,
  );
}

// --- Availability ---
extension AvailabilityDtoMapper on AvailabilityDto {
  Availability toDomain() => Availability(
    userId: UserId(userId),
    availableWeekdays: availableWeekdays.toSet(),
    slotsByWeekday: slotsByWeekday.map(
      (k, v) => MapEntry(
        int.parse(k),
        v
            .map(
              (s) => TimeSlot(
                startMinutes: s.startMinutes,
                endMinutes: s.endMinutes,
              ),
            )
            .toList(),
      ),
    ),
    blockedDates: blockedDates.map(DateTime.parse).toSet(),
    unavailablePeriods: unavailablePeriods
        .map(
          (r) => DateRange(
            start: DateTime.parse(r.start),
            end: DateTime.parse(r.end),
          ),
        )
        .toList(),
  );
}

extension AvailabilityMapper on Availability {
  AvailabilityDto toDto() => AvailabilityDto(
    userId: userId.value,
    availableWeekdays: availableWeekdays.toList(),
    slotsByWeekday: slotsByWeekday.map(
      (k, v) => MapEntry(
        k.toString(),
        v
            .map(
              (s) => TimeSlotDto(
                startMinutes: s.startMinutes,
                endMinutes: s.endMinutes,
              ),
            )
            .toList(),
      ),
    ),
    blockedDates: blockedDates.map((d) => d.toIso8601String()).toList(),
    unavailablePeriods: unavailablePeriods
        .map(
          (r) => DateRangeDto(
            start: r.start.toIso8601String(),
            end: r.end.toIso8601String(),
          ),
        )
        .toList(),
  );
}

// --- ScheduledEvent (confirmaciones aparte, ver D4) ---
extension ScheduledEventDtoMapper on ScheduledEventDto {
  ScheduledEvent toDomain({List<Confirmation> confirmations = const []}) =>
      ScheduledEvent(
        id: ScheduledEventId(id),
        date: DateTime.parse(date),
        weekId: WeekId(weekId),
        activityIds: activityIds.map(ActivityId.new).toList(),
        status: CompletionStatus.values.byName(status),
        confirmations: confirmations,
        notes: notes,
        createdAt: DateTime.parse(createdAt),
      );
}

extension ScheduledEventMapper on ScheduledEvent {
  ScheduledEventDto toDto() => ScheduledEventDto(
    id: id.value,
    date: date.toIso8601String(),
    weekId: weekId.value,
    activityIds: activityIds.map((a) => a.value).toList(),
    status: status.name,
    notes: notes,
    createdAt: createdAt.toIso8601String(),
  );
}

// --- Confirmation ---
extension ConfirmationDtoMapper on ConfirmationDto {
  Confirmation toDomain() => Confirmation(
    userId: UserId(userId),
    activityId: ActivityId(activityId),
    status: ConfirmationStatus.values.byName(status),
  );
}

extension ConfirmationMapper on Confirmation {
  ConfirmationDto toDto() => ConfirmationDto(
    userId: userId.value,
    activityId: activityId.value,
    status: status.name,
  );
}

// --- WeeklySchedule ---
extension WeeklyScheduleDtoMapper on WeeklyScheduleDto {
  WeeklySchedule toDomain() => WeeklySchedule(
    weekId: WeekId(weekId),
    eventIds: eventIds.map(ScheduledEventId.new).toList(),
    generatedAt: DateTime.parse(generatedAt),
  );
}

extension WeeklyScheduleMapper on WeeklySchedule {
  WeeklyScheduleDto toDto() => WeeklyScheduleDto(
    weekId: weekId.value,
    eventIds: eventIds.map((e) => e.value).toList(),
    generatedAt: generatedAt.toIso8601String(),
  );
}

// --- MediaBlob ---
extension MediaBlobDtoMapper on MediaBlobDto {
  MediaBlob toDomain() => MediaBlob(
    id: MediaId(id),
    base64: base64,
    mime: mime,
    width: width,
    height: height,
    byteSize: byteSize,
    createdBy: UserId(createdBy),
    createdAt: DateTime.parse(createdAt),
  );
}

extension MediaBlobMapper on MediaBlob {
  MediaBlobDto toDto() => MediaBlobDto(
    id: id.value,
    base64: base64,
    mime: mime,
    width: width,
    height: height,
    byteSize: byteSize,
    createdBy: createdBy.value,
    createdAt: createdAt.toIso8601String(),
  );
}

// --- StreakStats ---
extension StreakStatsDtoMapper on StreakStatsDto {
  StreakStats toDomain() => StreakStats(
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    weeklyCompletionRate: weeklyCompletionRate,
    monthlyCompletionRate: monthlyCompletionRate,
    yearlyCompletionRate: yearlyCompletionRate,
  );
}

extension StreakStatsMapper on StreakStats {
  StreakStatsDto toDto() => StreakStatsDto(
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    weeklyCompletionRate: weeklyCompletionRate,
    monthlyCompletionRate: monthlyCompletionRate,
    yearlyCompletionRate: yearlyCompletionRate,
  );
}

// --- SchedulingConfig ---
extension SchedulingConfigDtoMapper on SchedulingConfigDto {
  SchedulingConfig toDomain() => SchedulingConfig(
    daysPerWeek: daysPerWeek,
    activitiesPerDay: activitiesPerDay,
  );
}

extension SchedulingConfigMapper on SchedulingConfig {
  SchedulingConfigDto toDto() => SchedulingConfigDto(
    daysPerWeek: daysPerWeek,
    activitiesPerDay: activitiesPerDay,
  );
}

// --- User ---
extension UserDtoMapper on UserDto {
  User toDomain() => User(id: UserId(id), displayName: displayName);
}

extension UserMapper on User {
  UserDto toDto() => UserDto(id: id.value, displayName: displayName);
}

// --- RouletteItem ---
extension RouletteItemDtoMapper on RouletteItemDto {
  RouletteItem toDomain() => RouletteItem(
    id: RouletteItemId(id),
    text: text,
    favorite: favorite,
    level: IntensityLevel.fromName(level),
  );
}

extension RouletteItemMapper on RouletteItem {
  RouletteItemDto toDto() => RouletteItemDto(
    id: id.value,
    text: text,
    favorite: favorite,
    level: level.name,
  );
}

// --- RouletteSpin ---
extension RouletteSpinDtoMapper on RouletteSpinDto {
  RouletteSpin toDomain() => RouletteSpin(
    id: RouletteSpinId(id),
    itemId: RouletteItemId(itemId),
    text: text,
    level: IntensityLevel.fromName(level),
    createdAt: DateTime.parse(createdAt),
    done: done,
  );
}

extension RouletteSpinMapper on RouletteSpin {
  RouletteSpinDto toDto() => RouletteSpinDto(
    id: id.value,
    itemId: itemId.value,
    text: text,
    level: level.name,
    createdAt: createdAt.toIso8601String(),
    done: done,
  );
}

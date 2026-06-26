import 'package:collection/collection.dart';

import '../exceptions/domain_exception.dart';
import '../value_objects/date_range.dart';
import '../value_objects/ids.dart';
import '../value_objects/time_slot.dart';

const DeepCollectionEquality _deepEq = DeepCollectionEquality();

/// Disponibilidad de un usuario: días de la semana disponibles, franjas
/// horarias por día, fechas bloqueadas y periodos de indisponibilidad.
///
/// El algoritmo de generación semanal respeta esta disponibilidad (a nivel de
/// día) vía [isDayAvailable].
final class Availability {
  Availability({
    required this.userId,
    required this.availableWeekdays,
    required this.slotsByWeekday,
    required this.blockedDates,
    required this.unavailablePeriods,
  }) {
    for (final wd in availableWeekdays) {
      if (wd < DateTime.monday || wd > DateTime.sunday) {
        throw DomainValidationException(
          'Día de semana inválido: $wd (1=lunes .. 7=domingo).',
        );
      }
    }
  }

  /// Disponibilidad vacía (nada disponible) para un usuario.
  factory Availability.empty(UserId userId) => Availability(
    userId: userId,
    availableWeekdays: const <int>{},
    slotsByWeekday: const <int, List<TimeSlot>>{},
    blockedDates: const <DateTime>{},
    unavailablePeriods: const <DateRange>[],
  );

  final UserId userId;

  /// Días de la semana disponibles (1=lunes .. 7=domingo).
  final Set<int> availableWeekdays;

  /// Franjas horarias por día de la semana.
  final Map<int, List<TimeSlot>> slotsByWeekday;

  /// Fechas concretas bloqueadas (se comparan solo año/mes/día).
  final Set<DateTime> blockedDates;

  /// Periodos continuos de indisponibilidad.
  final List<DateRange> unavailablePeriods;

  /// `true` si el usuario está disponible el día de [moment]: el día de la
  /// semana está habilitado, la fecha no está bloqueada y no cae en un periodo
  /// de indisponibilidad.
  bool isDayAvailable(DateTime moment) {
    if (!availableWeekdays.contains(moment.weekday)) {
      return false;
    }
    final dayKey = DateTime.utc(moment.year, moment.month, moment.day);
    final isBlocked = blockedDates.any(
      (d) => DateTime.utc(d.year, d.month, d.day) == dayKey,
    );
    if (isBlocked) {
      return false;
    }
    return !unavailablePeriods.any((p) => p.contains(moment));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Availability &&
          other.userId == userId &&
          _deepEq.equals(other.availableWeekdays, availableWeekdays) &&
          _deepEq.equals(other.slotsByWeekday, slotsByWeekday) &&
          _deepEq.equals(other.blockedDates, blockedDates) &&
          _deepEq.equals(other.unavailablePeriods, unavailablePeriods));

  @override
  int get hashCode => Object.hash(
    userId,
    _deepEq.hash(availableWeekdays),
    _deepEq.hash(slotsByWeekday),
    _deepEq.hash(blockedDates),
    _deepEq.hash(unavailablePeriods),
  );

  @override
  String toString() => 'Availability($userId, weekdays=$availableWeekdays)';
}

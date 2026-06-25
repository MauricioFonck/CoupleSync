import '../exceptions/domain_exception.dart';

/// Franja horaria dentro de un día, en minutos desde medianoche `[0, 1440]`,
/// con `start < end`. Modela horarios disponibles de un usuario.
final class TimeSlot {
  TimeSlot({required this.startMinutes, required this.endMinutes}) {
    if (startMinutes < 0 || startMinutes > _minutesPerDay) {
      throw DomainValidationException(
        'startMinutes fuera de rango: $startMinutes (0..1440).',
      );
    }
    if (endMinutes < 0 || endMinutes > _minutesPerDay) {
      throw DomainValidationException(
        'endMinutes fuera de rango: $endMinutes (0..1440).',
      );
    }
    if (startMinutes >= endMinutes) {
      throw DomainValidationException(
        'TimeSlot inválido: start ($startMinutes) >= end ($endMinutes).',
      );
    }
  }

  /// Construye desde horas/minutos (24h).
  factory TimeSlot.fromHm({
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) =>
      TimeSlot(
        startMinutes: startHour * 60 + startMinute,
        endMinutes: endHour * 60 + endMinute,
      );

  static const int _minutesPerDay = 24 * 60;

  final int startMinutes;
  final int endMinutes;

  /// `true` si esta franja se solapa con [other].
  bool overlaps(TimeSlot other) =>
      startMinutes < other.endMinutes && other.startMinutes < endMinutes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeSlot &&
          other.startMinutes == startMinutes &&
          other.endMinutes == endMinutes);

  @override
  int get hashCode => Object.hash(startMinutes, endMinutes);

  @override
  String toString() => 'TimeSlot($startMinutes..$endMinutes)';
}

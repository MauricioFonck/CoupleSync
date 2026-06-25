import '../exceptions/domain_exception.dart';

/// Rango de fechas/horas inmutable `[start, end]` con `end >= start`.
///
/// Útil para periodos de indisponibilidad y ventanas de agenda.
final class DateRange {
  DateRange({required this.start, required this.end}) {
    if (end.isBefore(start)) {
      throw DomainValidationException(
        'DateRange inválido: end ($end) es anterior a start ($start).',
      );
    }
  }

  final DateTime start;
  final DateTime end;

  /// Duración del rango (>= 0).
  Duration get duration => end.difference(start);

  /// `true` si [moment] cae dentro de `[start, end]` (inclusive).
  bool contains(DateTime moment) =>
      !moment.isBefore(start) && !moment.isAfter(end);

  /// `true` si este rango se solapa con [other] (extremos inclusive).
  bool overlaps(DateRange other) =>
      !start.isAfter(other.end) && !other.start.isAfter(end);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DateRange && other.start == start && other.end == end);

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRange($start .. $end)';
}

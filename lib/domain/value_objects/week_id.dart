import '../exceptions/domain_exception.dart';

/// Identificador de semana ISO-8601 con formato `YYYY-Www` (p. ej. `2026-W26`).
///
/// Es la clave del *guard* de generación semanal `weeklySchedules/{weekId}`
/// (ver D2). Inmutable y con igualdad por valor.
final class WeekId {
  WeekId(this.value) {
    if (!_pattern.hasMatch(value)) {
      throw DomainValidationException(
        'WeekId inválido: "$value" (esperado YYYY-Www, p. ej. 2026-W26).',
      );
    }
    final week = int.parse(value.substring(6));
    if (week < 1 || week > 53) {
      throw DomainValidationException(
        'Semana ISO fuera de rango en "$value" (1..53).',
      );
    }
  }

  /// Construye el [WeekId] de la semana ISO a la que pertenece [date].
  factory WeekId.fromDate(DateTime date) {
    final day = DateTime.utc(date.year, date.month, date.day);
    // Lunes=0 .. Domingo=6.
    final dayNr = (day.weekday + 6) % 7;
    // El jueves de la semana decide el año ISO.
    final thursday = day.subtract(Duration(days: dayNr)).add(
          const Duration(days: 3),
        );
    final firstDayOfYear = DateTime.utc(thursday.year, 1, 1);
    final daysSinceFirst = thursday.difference(firstDayOfYear).inDays;
    final weekNr = 1 + (daysSinceFirst / 7).floor();
    final padded = weekNr.toString().padLeft(2, '0');
    return WeekId('${thursday.year}-W$padded');
  }

  static final RegExp _pattern = RegExp(r'^\d{4}-W\d{2}$');

  /// Cadena canónica `YYYY-Www`.
  final String value;

  /// Año ISO (puede diferir del año natural en los bordes de año).
  int get isoYear => int.parse(value.substring(0, 4));

  /// Número de semana ISO (1..53).
  int get isoWeek => int.parse(value.substring(6));

  /// Lunes (UTC) de esta semana ISO.
  DateTime get mondayUtc {
    // El 4 de enero siempre cae en la semana ISO 1.
    final jan4 = DateTime.utc(isoYear, 1, 4);
    final week1Monday = jan4.subtract(Duration(days: jan4.weekday - 1));
    return week1Monday.add(Duration(days: (isoWeek - 1) * 7));
  }

  /// Los 7 días (UTC) de esta semana, de lunes a domingo.
  List<DateTime> get daysUtc =>
      List<DateTime>.generate(7, (i) => mondayUtc.add(Duration(days: i)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is WeekId && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'WeekId($value)';
}

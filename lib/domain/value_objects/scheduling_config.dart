import '../exceptions/domain_exception.dart';

/// Configuración del planificador semanal: cuántos días se programan por semana
/// y cuántas actividades por día. La consume `GenerateWeeklyScheduleUseCase`.
final class SchedulingConfig {
  SchedulingConfig({
    required this.daysPerWeek,
    required this.activitiesPerDay,
  }) {
    if (daysPerWeek < 1 || daysPerWeek > 7) {
      throw DomainValidationException(
        'daysPerWeek fuera de rango: $daysPerWeek (1..7).',
      );
    }
    if (activitiesPerDay < 1) {
      throw DomainValidationException(
        'activitiesPerDay debe ser >= 1 (recibido $activitiesPerDay).',
      );
    }
  }

  /// Valor por defecto razonable (3 días/semana, 1 actividad/día).
  factory SchedulingConfig.defaults() =>
      SchedulingConfig(daysPerWeek: 3, activitiesPerDay: 1);

  final int daysPerWeek;
  final int activitiesPerDay;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchedulingConfig &&
          other.daysPerWeek == daysPerWeek &&
          other.activitiesPerDay == activitiesPerDay);

  @override
  int get hashCode => Object.hash(daysPerWeek, activitiesPerDay);

  @override
  String toString() =>
      'SchedulingConfig(days=$daysPerWeek, perDay=$activitiesPerDay)';
}

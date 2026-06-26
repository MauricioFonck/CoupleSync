import '../../domain/ports/clock_port.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/week_id.dart';
import '../commands/commands.dart';
import 'scheduling_service.dart';

/// *Lazy generation* (D2): al abrir la app, garantiza que existe la agenda de
/// la semana actual y, los domingos, también la de la semana siguiente. La
/// atomicidad la da el guard transaccional; los conflictos (ya existe) y la
/// falta de actividades se ignoran silenciosamente.
class LazyScheduleService {
  const LazyScheduleService({
    required SchedulingService scheduling,
    required ClockPort clock,
  })  : _scheduling = scheduling,
        _clock = clock;

  final SchedulingService _scheduling;
  final ClockPort _clock;

  Future<void> ensureUpcoming({
    required UserId partnerA,
    required UserId partnerB,
  }) async {
    final now = _clock.now();
    final weeks = <WeekId>{WeekId.fromDate(now)};
    if (now.weekday == DateTime.sunday) {
      weeks.add(WeekId.fromDate(now.add(const Duration(days: 7))));
    }
    for (final week in weeks) {
      // El Result se ignora: conflicto = ya existe; invariante = sin actividades.
      await _scheduling.generate(
        GenerateScheduleCommand(
          targetWeek: week,
          partnerA: partnerA,
          partnerB: partnerB,
        ),
      );
    }
  }
}

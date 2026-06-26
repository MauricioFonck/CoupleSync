import '../domain/ports/clock_port.dart';

/// Reloj real del sistema.
class SystemClock implements ClockPort {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

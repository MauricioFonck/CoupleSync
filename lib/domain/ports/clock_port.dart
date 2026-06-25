/// Puerto de reloj. Inyectable para hacer testeable la lógica temporal
/// (lazy generation, rachas, etc.).
abstract interface class ClockPort {
  /// Instante actual.
  DateTime now();
}

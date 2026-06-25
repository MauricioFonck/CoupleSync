/// Puerto de aleatoriedad. Inyectable para que la selección de actividades del
/// generador semanal sea determinista en tests.
abstract interface class RandomPort {
  /// Entero en `[0, max)`.
  int nextInt(int max);

  /// Copia barajada de [items] (no muta la lista original).
  List<T> shuffled<T>(List<T> items);
}

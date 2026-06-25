/// Severidad de una penitencia. Orden natural: low < medium < high.
enum Severity {
  low(1),
  medium(2),
  high(3);

  const Severity(this.weight);

  /// Peso numérico para comparaciones/ordenación.
  final int weight;

  bool operator >(Severity other) => weight > other.weight;
  bool operator <(Severity other) => weight < other.weight;
}

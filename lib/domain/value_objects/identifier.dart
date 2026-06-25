import '../exceptions/domain_exception.dart';

/// Base inmutable para identificadores tipados (envuelven un `String`).
///
/// Da igualdad por valor y, gracias al chequeo de `runtimeType`, dos IDs de
/// tipos distintos nunca son iguales aunque compartan el mismo `value`.
abstract base class Identifier {
  Identifier(this.value) {
    if (value.trim().isEmpty) {
      throw DomainValidationException('$runtimeType no puede estar vacío.');
    }
  }

  /// Valor crudo del identificador (p. ej. el UID de Firebase o un UUID).
  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Identifier &&
          runtimeType == other.runtimeType &&
          value == other.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => '$runtimeType($value)';
}

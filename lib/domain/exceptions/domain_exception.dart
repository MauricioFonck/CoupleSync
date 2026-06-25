/// Base de todas las excepciones del dominio.
///
/// El dominio es Dart puro: estas excepciones no dependen de Flutter ni de
/// ninguna infraestructura. La jerarquía se amplía en el Plan 2.3.
sealed class DomainException implements Exception {
  const DomainException(this.message);

  /// Mensaje legible que describe la violación.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Se lanza cuando un valor viola una validación de entrada (formato, rango,
/// vacío, etc.) al construir un value object o entidad.
class DomainValidationException extends DomainException {
  const DomainValidationException(super.message);
}

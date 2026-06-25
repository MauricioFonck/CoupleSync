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

/// Se lanza cuando una operación violaría una invariante/regla de negocio
/// (p. ej. completar un evento que no fue aprobado por ambos usuarios).
class DomainInvariantException extends DomainException {
  const DomainInvariantException(super.message);
}

/// Se lanza cuando una entidad referenciada no existe en el repositorio.
class EntityNotFoundException extends DomainException {
  const EntityNotFoundException(super.message, {this.entity, this.id});

  /// Nombre del tipo de entidad buscado (p. ej. `Activity`).
  final String? entity;

  /// Identificador buscado.
  final String? id;

  @override
  String toString() =>
      'EntityNotFoundException: $message (entity=$entity, id=$id)';
}

/// Se lanza cuando ya existe la agenda de una semana y se intenta regenerarla:
/// el *guard* `weeklySchedules/{weekId}` ya estaba creado (ver D2). Evita la
/// doble generación cuando A y B abren la app a la vez.
class ScheduleGenerationConflictException extends DomainException {
  const ScheduleGenerationConflictException(super.message, {required this.weekId});

  /// Semana (formato `YYYY-Www`) cuyo guard ya existía.
  final String weekId;

  @override
  String toString() =>
      'ScheduleGenerationConflictException: $message (week=$weekId)';
}

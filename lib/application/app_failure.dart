import '../domain/exceptions/domain_exception.dart';

/// Categoría de fallo a nivel de aplicación. La presentación decide cómo
/// mostrar cada una sin conocer las excepciones de dominio.
enum FailureKind { validation, invariant, notFound, conflict, unexpected }

/// Fallo de aplicación. Traduce excepciones de dominio (y cualquier otra) a un
/// objeto neutral que la UI puede consumir.
final class AppFailure {
  const AppFailure({
    required this.kind,
    required this.message,
    this.cause,
    this.stackTrace,
  });

  /// Mapea cualquier excepción a un [AppFailure]. Las excepciones de dominio se
  /// clasifican; el resto cae en [FailureKind.unexpected].
  factory AppFailure.fromException(Object error, [StackTrace? stackTrace]) {
    return switch (error) {
      DomainValidationException(:final message) => AppFailure(
          kind: FailureKind.validation,
          message: message,
          cause: error,
          stackTrace: stackTrace,
        ),
      DomainInvariantException(:final message) => AppFailure(
          kind: FailureKind.invariant,
          message: message,
          cause: error,
          stackTrace: stackTrace,
        ),
      EntityNotFoundException(:final message) => AppFailure(
          kind: FailureKind.notFound,
          message: message,
          cause: error,
          stackTrace: stackTrace,
        ),
      ScheduleGenerationConflictException(:final message) => AppFailure(
          kind: FailureKind.conflict,
          message: message,
          cause: error,
          stackTrace: stackTrace,
        ),
      _ => AppFailure(
          kind: FailureKind.unexpected,
          message: error.toString(),
          cause: error,
          stackTrace: stackTrace,
        ),
    };
  }

  final FailureKind kind;
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppFailure($kind, $message)';
}

import 'app_failure.dart';

/// Resultado de una operación de aplicación: éxito ([Ok]) o fallo ([Err]).
/// Evita que las excepciones de dominio crucen a la capa de presentación.
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  AppFailure? get failureOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final failure) => failure,
  };

  /// Colapsa el resultado en un único valor según el caso.
  R fold<R>(R Function(T value) onOk, R Function(AppFailure failure) onErr) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final AppFailure failure;
}

/// Ejecuta [body] y traduce cualquier excepción a `Err(AppFailure)`.
/// Es el punto único donde la capa de aplicación captura errores de dominio.
Future<Result<T>> runCatching<T>(Future<T> Function() body) async {
  try {
    return Ok<T>(await body());
  } on Object catch (error, stackTrace) {
    return Err<T>(AppFailure.fromException(error, stackTrace));
  }
}

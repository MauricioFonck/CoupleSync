/// Nivel de intensidad de una idea de la ruleta.
enum IntensityLevel {
  soft,
  medium,
  hard;

  /// Lectura segura desde un nombre persistido; cae en [medium] si no coincide.
  static IntensityLevel fromName(String? name) {
    return IntensityLevel.values.firstWhere(
      (l) => l.name == name,
      orElse: () => IntensityLevel.medium,
    );
  }
}

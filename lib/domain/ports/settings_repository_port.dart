import '../value_objects/scheduling_config.dart';

/// Puerto de persistencia de ajustes (config del planificador, etc.).
abstract interface class SettingsRepositoryPort {
  /// Config del planificador; devuelve valores por defecto si no hay ajustes.
  Future<SchedulingConfig> getSchedulingConfig();
  Future<void> saveSchedulingConfig(SchedulingConfig config);
}

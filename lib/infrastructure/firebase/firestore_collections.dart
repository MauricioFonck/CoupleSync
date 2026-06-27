/// Nombres de colecciones/documentos de Firestore en un único lugar (DRY).
abstract final class FirestoreCollections {
  static const users = 'users';
  static const activities = 'activities';
  static const penalties = 'penalties';
  static const weeklySchedules = 'weeklySchedules';
  static const scheduledEvents = 'scheduledEvents';
  static const confirmations =
      'confirmations'; // subcolección de scheduledEvents
  static const availability = 'availability';
  static const statistics = 'statistics';
  static const settings = 'settings';
  static const media = 'media';
  static const rouletteItems = 'rouletteItems';
  static const rouletteHistory = 'rouletteHistory';
  static const notifications = 'notifications';
  static const auditLogs = 'auditLogs';

  /// Documento singleton de estadísticas.
  static const statisticsDoc = 'current';

  /// Documento singleton de configuración del planificador.
  static const schedulingSettingsDoc = 'scheduling';
}

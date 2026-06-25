import '../entities/streak_stats.dart';

/// Puerto de persistencia de estadísticas/rachas (snapshots calculados).
abstract interface class StatisticsRepositoryPort {
  Future<StreakStats?> get();
  Future<void> save(StreakStats stats);
}

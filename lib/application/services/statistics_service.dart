import '../../domain/entities/streak_stats.dart';
import '../../domain/ports/statistics_repository_port.dart';
import '../../domain/use_cases/calculate_streaks_use_case.dart';
import '../result.dart';

/// Orquesta el cálculo de rachas/estadísticas y persiste un snapshot.
class StatisticsService {
  const StatisticsService({
    required CalculateStreaksUseCase calculateStreaks,
    required StatisticsRepositoryPort statisticsRepository,
  }) : _calculate = calculateStreaks,
       _repository = statisticsRepository;

  final CalculateStreaksUseCase _calculate;
  final StatisticsRepositoryPort _repository;

  /// Recalcula las rachas a partir del historial y guarda el snapshot.
  Future<Result<StreakStats>> refresh() => runCatching(() async {
    final stats = await _calculate.execute();
    await _repository.save(stats);
    return stats;
  });

  /// Devuelve el último snapshot guardado (o ceros si no hay).
  Future<Result<StreakStats>> latest() => runCatching(() async {
    final stored = await _repository.get();
    return stored ?? StreakStats.zero();
  });
}

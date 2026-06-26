import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../providers/dashboard_controller.dart';
import '../providers/home_bootstrap.dart';

/// Dashboard con KPIs y gráfica de cumplimiento (semanal/mensual/anual).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dispara la lazy generation al entrar (no bloquea la UI).
    ref.watch(homeBootstrapProvider);

    final user = ref.watch(authStateProvider).asData?.value;
    final data = ref.watch(dashboardProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardProvider),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hola, ${user?.displayName ?? ''}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          data.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (d) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _KpiCard(
                      keyName: 'kpi_scheduled',
                      label: 'Programadas',
                      value: '${d.scheduled}',
                    ),
                    _KpiCard(
                      keyName: 'kpi_completed',
                      label: 'Completadas',
                      value: '${d.completed}',
                    ),
                    _KpiCard(
                      keyName: 'kpi_pending',
                      label: 'Pendientes',
                      value: '${d.pending}',
                    ),
                    _KpiCard(
                      keyName: 'kpi_compliance',
                      label: '% Cumplimiento',
                      value: '${(d.compliance * 100).round()}%',
                    ),
                    _KpiCard(
                      keyName: 'kpi_current_streak',
                      label: 'Racha actual',
                      value: '${d.stats.currentStreak}',
                    ),
                    _KpiCard(
                      keyName: 'kpi_best_streak',
                      label: 'Mejor racha',
                      value: '${d.stats.bestStreak}',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Cumplimiento',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: _RatesChart(
                    weekly: d.stats.weeklyCompletionRate,
                    monthly: d.stats.monthlyCompletionRate,
                    yearly: d.stats.yearlyCompletionRate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.keyName,
    required this.label,
    required this.value,
  });

  final String keyName;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(keyName),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _RatesChart extends StatelessWidget {
  const _RatesChart({
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  final double weekly;
  final double monthly;
  final double yearly;

  @override
  Widget build(BuildContext context) {
    const labels = ['Semana', 'Mes', 'Año'];
    final values = [weekly, monthly, yearly];
    final color = Theme.of(context).colorScheme.primary;

    return BarChart(
      BarChartData(
        maxY: 100,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: values[i] * 100, color: color, width: 28),
              ],
            ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(labels[value.toInt()]),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

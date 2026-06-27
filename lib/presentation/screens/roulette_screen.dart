import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/roulette_item.dart';
import '../../domain/entities/roulette_spin.dart';
import '../../domain/value_objects/intensity_level.dart';
import '../providers/app_providers.dart';
import '../providers/roulette_controller.dart';

String levelLabel(IntensityLevel level) => switch (level) {
  IntensityLevel.soft => 'Suave',
  IntensityLevel.medium => 'Medio',
  IntensityLevel.hard => 'Fuerte',
};

/// Ruleta privada: filtra por intensidad, saca 20, revuelve, gira (y hasta algo
/// bueno), con botones rápidos en la carta e historial con marca "hecho".
class RouletteScreen extends ConsumerStatefulWidget {
  const RouletteScreen({super.key});

  @override
  ConsumerState<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends ConsumerState<RouletteScreen> {
  final _random = math.Random();
  final Set<IntensityLevel> _levels = {...IntensityLevel.values};
  List<RouletteItem> _subset = const [];
  RouletteSpin? _result;
  String? _frameText;
  bool _spinning = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _draw() async {
    final result = await ref
        .read(rouletteServiceProvider)
        .draw(levels: _levels);
    if (!mounted) return;
    result.fold((items) {
      setState(() {
        _subset = items;
        _result = null;
      });
      if (items.isEmpty) _snack('No hay ideas con esos niveles.');
    }, (failure) => _snack(failure.message));
  }

  Future<void> _animateTo(RouletteSpin spin) async {
    setState(() => _spinning = true);
    const frames = 16;
    for (var i = 0; i < frames; i++) {
      if (!mounted) return;
      final frame = _subset.isEmpty
          ? spin.text
          : _subset[_random.nextInt(_subset.length)].text;
      setState(() => _frameText = frame);
      await Future<void>.delayed(Duration(milliseconds: 40 + i * i * 2));
    }
    if (!mounted) return;
    setState(() {
      _result = spin;
      _frameText = null;
      _spinning = false;
    });
    // El historial y el contador se actualizan solos vía stream (tiempo real).
  }

  Future<void> _spin() async {
    if (_subset.isEmpty || _spinning) return;
    final result = await ref.read(rouletteServiceProvider).spin(_subset);
    if (!mounted) return;
    await result.fold(_animateTo, (failure) async => _snack(failure.message));
  }

  Future<void> _spinFavorite() async {
    if (_spinning) return;
    final result = await ref
        .read(rouletteServiceProvider)
        .spinFavorite(levels: _levels);
    if (!mounted) return;
    await result.fold(_animateTo, (failure) async => _snack(failure.message));
  }

  Future<void> _markDone() async {
    final spin = _result;
    if (spin == null || spin.done) return;
    final result = await ref.read(rouletteServiceProvider).markDone(spin.id);
    if (!mounted) return;
    result.fold(
      (updated) => setState(() => _result = updated),
      (failure) => _snack(failure.message),
    );
  }

  Future<void> _toggleFavorite() async {
    final spin = _result;
    if (spin == null) return;
    final failure = await ref
        .read(rouletteActionsProvider)
        .toggleFavorite(spin.itemId);
    _snack(failure?.message ?? 'Favorito actualizado ⭐');
  }

  @override
  Widget build(BuildContext context) {
    final pool = ref.watch(rouletteItemsProvider);
    final done = ref.watch(rouletteDoneCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruleta'),
        actions: [
          IconButton(
            key: const Key('roulette_history'),
            tooltip: 'Historial',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const RouletteHistoryScreen(),
              ),
            ),
          ),
          IconButton(
            key: const Key('roulette_manage'),
            tooltip: 'Gestionar ideas',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const RouletteManageScreen(),
              ),
            ),
          ),
        ],
      ),
      body: pool.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('La ruleta está vacía.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RouletteManageScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.playlist_add),
                    label: const Text('Importar ideas'),
                  ),
                ],
              ),
            );
          }
          return _buildGame(context, items.length, done);
        },
      ),
    );
  }

  Widget _buildGame(BuildContext context, int poolSize, int doneCount) {
    final theme = Theme.of(context);
    final result = _result;
    final cardText =
        _frameText ?? result?.text ?? 'Pulsa "Sacar 20" y luego "Girar"';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Completadas: $doneCount',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final level in IntensityLevel.values)
                FilterChip(
                  key: Key('level_${level.name}'),
                  label: Text(levelLabel(level)),
                  selected: _levels.contains(level),
                  onSelected: (sel) => setState(() {
                    if (sel) {
                      _levels.add(level);
                    } else if (_levels.length > 1) {
                      _levels.remove(level);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              key: const Key('roulette_card'),
              elevation: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (result != null && _frameText == null) ...[
                        Chip(label: Text(levelLabel(result.level))),
                        if (result.done)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Chip(
                              avatar: Icon(Icons.check, color: Colors.green),
                              label: Text('Hecho'),
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        cardText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      if (result != null && !_spinning) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            TextButton.icon(
                              key: const Key('card_favorite'),
                              onPressed: _toggleFavorite,
                              icon: const Icon(Icons.star_border),
                              label: const Text('Favorito'),
                            ),
                            TextButton.icon(
                              key: const Key('card_respin'),
                              onPressed: _spin,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Otra'),
                            ),
                            TextButton.icon(
                              key: const Key('card_done'),
                              onPressed: result.done ? null : _markDone,
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Hecho'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _subset.isEmpty
                ? 'Pool: $poolSize ideas'
                : 'En juego: ${_subset.length} de $poolSize',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                key: const Key('roulette_draw'),
                onPressed: _spinning ? null : _draw,
                icon: const Icon(Icons.casino),
                label: Text(_subset.isEmpty ? 'Sacar 20' : 'Revolver'),
              ),
              FilledButton.icon(
                key: const Key('roulette_spin'),
                onPressed: (_spinning || _subset.isEmpty) ? null : _spin,
                icon: const Icon(Icons.refresh),
                label: const Text('Girar'),
              ),
              FilledButton.tonalIcon(
                key: const Key('roulette_spin_favorite'),
                onPressed: _spinning ? null : _spinFavorite,
                icon: const Icon(Icons.star),
                label: const Text('Hasta algo bueno'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gestión de ideas: importar (con nivel), marcar favorito, cambiar nivel, borrar.
class RouletteManageScreen extends ConsumerWidget {
  const RouletteManageScreen({super.key});

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    var level = IntensityLevel.medium;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Importar ideas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('roulette_import_text'),
                controller: controller,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Una idea por línea…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<IntensityLevel>(
                key: const Key('roulette_import_level'),
                initialValue: level,
                decoration: const InputDecoration(labelText: 'Nivel'),
                items: [
                  for (final l in IntensityLevel.values)
                    DropdownMenuItem(value: l, child: Text(levelLabel(l))),
                ],
                onChanged: (v) => setLocal(() => level = v ?? level),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              key: const Key('roulette_import_confirm'),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Importar'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final failure = await ref
        .read(rouletteActionsProvider)
        .import(controller.text, level: level);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failure?.message ?? 'Ideas importadas')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pool = ref.watch(rouletteItemsProvider);
    final actions = ref.read(rouletteActionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideas de la ruleta'),
        actions: [
          IconButton(
            key: const Key('roulette_import'),
            tooltip: 'Importar',
            icon: const Icon(Icons.playlist_add),
            onPressed: () => _import(context, ref),
          ),
        ],
      ),
      body: pool.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Sin ideas. Pulsa importar.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: IconButton(
                  icon: Icon(
                    item.favorite ? Icons.star : Icons.star_border,
                    color: item.favorite ? Colors.amber : null,
                  ),
                  onPressed: () => actions.toggleFavorite(item.id),
                ),
                title: Text(item.text),
                subtitle: Text('Nivel: ${levelLabel(item.level)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<IntensityLevel>(
                      icon: const Icon(Icons.signal_cellular_alt),
                      onSelected: (l) => actions.setLevel(item.id, l),
                      itemBuilder: (_) => [
                        for (final l in IntensityLevel.values)
                          PopupMenuItem(value: l, child: Text(levelLabel(l))),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => actions.delete(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Historial de tiradas, con opción de marcar "hecho".
class RouletteHistoryScreen extends ConsumerWidget {
  const RouletteHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(rouletteHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de la ruleta')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (spins) {
          if (spins.isEmpty) {
            return const Center(child: Text('Aún no habéis girado nada.'));
          }
          return ListView.builder(
            itemCount: spins.length,
            itemBuilder: (context, index) {
              final spin = spins[index];
              final d = spin.createdAt;
              return ListTile(
                title: Text(spin.text),
                subtitle: Text(
                  '${d.day}/${d.month}/${d.year} · ${levelLabel(spin.level)}',
                ),
                trailing: spin.done
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        tooltip: 'Marcar hecho',
                        onPressed: () =>
                            ref.read(rouletteServiceProvider).markDone(spin.id),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

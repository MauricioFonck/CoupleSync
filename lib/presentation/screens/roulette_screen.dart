import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/roulette_item.dart';
import '../providers/app_providers.dart';
import '../providers/roulette_controller.dart';

/// Ruleta privada: saca 20 ideas del pool, permite "revolver" (otras 20),
/// "girar" (elige una) y "girar hasta algo bueno" (un favorito).
class RouletteScreen extends ConsumerStatefulWidget {
  const RouletteScreen({super.key});

  @override
  ConsumerState<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends ConsumerState<RouletteScreen> {
  final _random = math.Random();
  List<RouletteItem> _subset = const [];
  RouletteItem? _result;
  String? _frameText;
  bool _spinning = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _draw() async {
    final result = await ref.read(rouletteServiceProvider).draw();
    if (!mounted) return;
    result.fold((items) {
      setState(() {
        _subset = items;
        _result = null;
      });
    }, (failure) => _snack(failure.message));
  }

  Future<void> _animateTo(RouletteItem target) async {
    setState(() => _spinning = true);
    const frames = 16;
    for (var i = 0; i < frames; i++) {
      if (!mounted) return;
      final frame = _subset.isEmpty
          ? target
          : _subset[_random.nextInt(_subset.length)];
      setState(() => _frameText = frame.text);
      await Future<void>.delayed(Duration(milliseconds: 40 + i * i * 2));
    }
    if (!mounted) return;
    setState(() {
      _result = target;
      _frameText = null;
      _spinning = false;
    });
  }

  Future<void> _spin() async {
    if (_subset.isEmpty || _spinning) return;
    final result = await ref.read(rouletteServiceProvider).spin(_subset);
    if (!mounted) return;
    await result.fold(_animateTo, (failure) async => _snack(failure.message));
  }

  Future<void> _spinFavorite() async {
    if (_spinning) return;
    final result = await ref.read(rouletteServiceProvider).spinFavorite();
    if (!mounted) return;
    await result.fold(_animateTo, (failure) async => _snack(failure.message));
  }

  @override
  Widget build(BuildContext context) {
    final pool = ref.watch(rouletteControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruleta'),
        actions: [
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
          return _buildGame(context, items.length);
        },
      ),
    );
  }

  Widget _buildGame(BuildContext context, int poolSize) {
    final theme = Theme.of(context);
    final cardText =
        _frameText ?? _result?.text ?? 'Pulsa "Sacar 20" y luego "Girar"';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
                      if (_result?.favorite ?? false)
                        const Icon(Icons.star, color: Colors.amber, size: 32),
                      Text(
                        cardText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
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

/// Gestión de ideas: importar en bloque, añadir, marcar favorito y borrar.
class RouletteManageScreen extends ConsumerWidget {
  const RouletteManageScreen({super.key});

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar ideas'),
        content: TextField(
          key: const Key('roulette_import_text'),
          controller: controller,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: 'Una idea por línea…',
            border: OutlineInputBorder(),
          ),
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
    );
    if (confirmed != true) return;
    final failure = await ref
        .read(rouletteControllerProvider.notifier)
        .import(controller.text);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failure?.message ?? 'Ideas importadas')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pool = ref.watch(rouletteControllerProvider);
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
                  onPressed: () => ref
                      .read(rouletteControllerProvider.notifier)
                      .toggleFavorite(item.id),
                ),
                title: Text(item.text),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref
                      .read(rouletteControllerProvider.notifier)
                      .delete(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

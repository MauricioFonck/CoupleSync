import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/availability.dart';
import '../providers/availability_controller.dart';

const _weekdayNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

/// Pantalla de gestión de disponibilidad: días de la semana y fechas bloqueadas.
/// Conserva franjas y periodos existentes al guardar.
class AvailabilityScreen extends ConsumerWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(availabilityProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (availability) => _AvailabilityEditor(initial: availability),
    );
  }
}

class _AvailabilityEditor extends ConsumerStatefulWidget {
  const _AvailabilityEditor({required this.initial});

  final Availability initial;

  @override
  ConsumerState<_AvailabilityEditor> createState() =>
      _AvailabilityEditorState();
}

class _AvailabilityEditorState extends ConsumerState<_AvailabilityEditor> {
  late Set<int> _weekdays;
  late List<DateTime> _blocked;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _weekdays = {...widget.initial.availableWeekdays};
    _blocked = [...widget.initial.blockedDates];
  }

  Future<void> _addBlockedDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );
    if (picked == null) return;
    final dateOnly = DateTime.utc(picked.year, picked.month, picked.day);
    setState(() {
      if (!_blocked.any((d) => d == dateOnly)) _blocked.add(dateOnly);
    });
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final updated = Availability(
      userId: widget.initial.userId,
      availableWeekdays: _weekdays,
      slotsByWeekday: widget.initial.slotsByWeekday,
      blockedDates: _blocked.toSet(),
      unavailablePeriods: widget.initial.unavailablePeriods,
    );
    final failure = await ref.read(availabilityActionsProvider).save(updated);
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          failure == null ? 'Disponibilidad guardada' : failure.message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Días disponibles',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (var weekday = 1; weekday <= 7; weekday++)
              FilterChip(
                key: Key('weekday_$weekday'),
                label: Text(_weekdayNames[weekday - 1]),
                selected: _weekdays.contains(weekday),
                onSelected: (sel) => setState(() {
                  if (sel) {
                    _weekdays.add(weekday);
                  } else {
                    _weekdays.remove(weekday);
                  }
                }),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Fechas bloqueadas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              key: const Key('add_blocked_date'),
              onPressed: _addBlockedDate,
              icon: const Icon(Icons.add),
              label: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_blocked.isEmpty)
          const Text('Ninguna')
        else
          Wrap(
            spacing: 8,
            children: [
              for (final d in _blocked)
                InputChip(
                  label: Text('${d.day}/${d.month}/${d.year}'),
                  onDeleted: () => setState(() => _blocked.remove(d)),
                ),
            ],
          ),
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('availability_save'),
          onPressed: _busy ? null : _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

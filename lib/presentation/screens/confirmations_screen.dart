import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/commands/commands.dart';
import '../../domain/entities/scheduled_event.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/statuses.dart';
import '../providers/activities_controller.dart' show activitiesProvider;
import '../providers/app_providers.dart';

String confirmationLabel(ConfirmationStatus? s) => switch (s) {
  ConfirmationStatus.approved => 'Aprobada',
  ConfirmationStatus.rejected => 'Rechazada',
  _ => 'Pendiente',
};

/// Pantalla de confirmaciones de un evento: el usuario actual aprueba/rechaza
/// cada actividad. El evento se completa **solo si ambos aprueban** (regla del
/// dominio). El compañero se infiere de las confirmaciones existentes.
class ConfirmationsScreen extends ConsumerStatefulWidget {
  const ConfirmationsScreen({required this.event, super.key});

  final ScheduledEvent event;

  @override
  ConsumerState<ConfirmationsScreen> createState() =>
      _ConfirmationsScreenState();
}

class _ConfirmationsScreenState extends ConsumerState<ConfirmationsScreen> {
  late ScheduledEvent _event;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  UserId _partnerOf(UserId current) {
    final others = _event.confirmations
        .map((c) => c.userId)
        .where((u) => u != current)
        .toList();
    return others.isNotEmpty ? others.first : UserId('__pending_partner__');
  }

  ConfirmationStatus? _statusFor(UserId user, ActivityId activityId) {
    for (final c in _event.confirmations) {
      if (c.userId == user && c.activityId == activityId) return c.status;
    }
    return null;
  }

  Future<void> _confirm(
    ActivityId activityId,
    ConfirmationStatus status,
  ) async {
    final current = ref.read(currentUserIdProvider);
    if (current == null) return;
    setState(() => _busy = true);

    final result = await ref
        .read(confirmationServiceProvider)
        .confirm(
          ConfirmActivityCommand(
            eventId: _event.id,
            userId: current,
            activityId: activityId,
            status: status,
          ),
          partnerA: current,
          partnerB: _partnerOf(current),
        );

    if (!mounted) return;
    final updated = result.valueOrNull;
    setState(() {
      _busy = false;
      if (updated != null) _event = updated;
    });
    final failure = result.failureOrNull;
    if (failure != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(currentUserIdProvider);
    final activities = ref.watch(activitiesProvider).asData?.value ?? const [];
    final titleById = {for (final a in activities) a.id.value: a.title};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmaciones'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Evento: ${statusOf(_event.status)}',
              key: const Key('event_status'),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          for (final activityId in _event.activityIds)
            ListTile(
              title: Text(titleById[activityId.value] ?? activityId.value),
              subtitle: Text(
                'Tu confirmación: '
                '${confirmationLabel(current == null ? null : _statusFor(current, activityId))}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: Key('approve_${activityId.value}'),
                    icon: const Icon(Icons.check_circle_outline),
                    color: Colors.green,
                    onPressed: _busy
                        ? null
                        : () =>
                              _confirm(activityId, ConfirmationStatus.approved),
                  ),
                  IconButton(
                    key: Key('reject_${activityId.value}'),
                    icon: const Icon(Icons.cancel_outlined),
                    color: Colors.red,
                    onPressed: _busy
                        ? null
                        : () =>
                              _confirm(activityId, ConfirmationStatus.rejected),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

String statusOf(CompletionStatus s) => switch (s) {
  CompletionStatus.pending => 'Pendiente',
  CompletionStatus.completed => 'Completado',
  CompletionStatus.missed => 'Fallido',
  CompletionStatus.rescheduled => 'Reprogramado',
};

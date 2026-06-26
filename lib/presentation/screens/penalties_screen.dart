import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/commands/commands.dart';
import '../../domain/entities/penalty.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/severity.dart';
import '../providers/app_providers.dart';
import '../providers/penalties_controller.dart';

String severityLabel(Severity s) => switch (s) {
  Severity.low => 'Leve',
  Severity.medium => 'Media',
  Severity.high => 'Alta',
};

/// Pantalla CRUD de penitencias.
class PenaltiesScreen extends ConsumerWidget {
  const PenaltiesScreen({super.key});

  Future<void> _openForm(BuildContext context, {Penalty? penalty}) {
    return showDialog<void>(
      context: context,
      builder: (_) => PenaltyFormDialog(penalty: penalty),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(penaltiesControllerProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('penalties_add'),
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (penalties) {
          if (penalties.isEmpty) {
            return const Center(
              child: Text('Sin penitencias. Crea la primera.'),
            );
          }
          return ListView.builder(
            itemCount: penalties.length,
            itemBuilder: (context, index) {
              final p = penalties[index];
              return ListTile(
                leading: Icon(p.imageId != null ? Icons.image : Icons.gavel),
                title: Text(p.title),
                subtitle: Text('Severidad: ${severityLabel(p.severity)}'),
                onTap: () => _openForm(context, penalty: p),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: p.active,
                      onChanged: (value) => ref
                          .read(penaltiesControllerProvider.notifier)
                          .setActive(p.id, active: value),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref
                          .read(penaltiesControllerProvider.notifier)
                          .delete(p.id),
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

class PenaltyFormDialog extends ConsumerStatefulWidget {
  const PenaltyFormDialog({this.penalty, super.key});

  final Penalty? penalty;

  @override
  ConsumerState<PenaltyFormDialog> createState() => _PenaltyFormDialogState();
}

class _PenaltyFormDialogState extends ConsumerState<PenaltyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late Severity _severity;
  MediaId? _imageId;
  bool _busy = false;

  bool get _isEdit => widget.penalty != null;

  @override
  void initState() {
    super.initState();
    final p = widget.penalty;
    _title = TextEditingController(text: p?.title ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _severity = p?.severity ?? Severity.low;
    _imageId = p?.imageId;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final createdBy = ref.read(currentUserIdProvider);
    if (createdBy == null) return;
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final blob = ref
          .read(mediaProcessorProvider)
          .process(bytes: bytes, createdBy: createdBy);
      await ref.read(mediaRepositoryProvider).save(blob);
      setState(() => _imageId = blob.id);
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Imagen inválida: $e')));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final controller = ref.read(penaltiesControllerProvider.notifier);

    final failure = _isEdit
        ? await controller.editPenalty(
            UpdatePenaltyCommand(
              id: widget.penalty!.id,
              title: _title.text.trim(),
              description: _description.text.trim(),
              severity: _severity,
              imageId: _imageId,
              clearImage: _imageId == null,
            ),
          )
        : await controller.create(
            CreatePenaltyCommand(
              title: _title.text.trim(),
              description: _description.text.trim(),
              severity: _severity,
              imageId: _imageId,
            ),
          );

    if (!mounted) return;
    setState(() => _busy = false);
    if (failure == null) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Editar penitencia' : 'Nueva penitencia'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('penalty_title'),
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                key: const Key('penalty_description'),
                controller: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Severity>(
                key: const Key('penalty_severity'),
                initialValue: _severity,
                decoration: const InputDecoration(labelText: 'Severidad'),
                items: [
                  for (final s in Severity.values)
                    DropdownMenuItem(value: s, child: Text(severityLabel(s))),
                ],
                onChanged: (v) => setState(() => _severity = v ?? _severity),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(_imageId == null ? 'Añadir imagen' : 'Cambiar'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('penalty_save'),
          onPressed: _busy ? null : _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

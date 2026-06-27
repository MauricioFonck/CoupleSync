import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/commands/commands.dart';
import '../../domain/entities/activity.dart';
import '../../domain/value_objects/activity_category.dart';
import '../../domain/value_objects/ids.dart';
import '../providers/activities_controller.dart';
import '../providers/app_providers.dart';

/// Pantalla CRUD de actividades. La lista no carga las imágenes (solo indica si
/// hay una) para no descargar blobs al listar (D1).
class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  Future<void> _openForm(BuildContext context, {Activity? activity}) {
    return showDialog<void>(
      context: context,
      builder: (_) => ActivityFormDialog(activity: activity),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activitiesProvider);
    final actions = ref.read(activitiesActionsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('activities_add'),
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (activities) {
          if (activities.isEmpty) {
            return const Center(
              child: Text('Sin actividades. Crea la primera.'),
            );
          }
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final a = activities[index];
              return ListTile(
                leading: Icon(a.imageId != null ? Icons.image : Icons.event),
                title: Text(a.title),
                subtitle: Text(a.category.value),
                onTap: () => _openForm(context, activity: a),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: a.active,
                      onChanged: (value) =>
                          actions.setActive(a.id, active: value),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => actions.delete(a.id),
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

/// Formulario de alta/edición de actividad.
class ActivityFormDialog extends ConsumerStatefulWidget {
  const ActivityFormDialog({this.activity, super.key});

  final Activity? activity;

  @override
  ConsumerState<ActivityFormDialog> createState() => _ActivityFormDialogState();
}

class _ActivityFormDialogState extends ConsumerState<ActivityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _category;
  MediaId? _imageId;
  bool _busy = false;
  String? _imageError;

  bool get _isEdit => widget.activity != null;

  @override
  void initState() {
    super.initState();
    final a = widget.activity;
    _title = TextEditingController(text: a?.title ?? '');
    _description = TextEditingController(text: a?.description ?? '');
    _category = TextEditingController(text: a?.category.value ?? '');
    _imageId = a?.imageId;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _category.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final createdBy = ref.read(currentUserIdProvider);
    if (createdBy == null) return;
    setState(() => _imageError = null);
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
      setState(() => _imageError = 'No se pudo procesar la imagen: $e');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final createdBy = ref.read(currentUserIdProvider);
    if (createdBy == null) return;

    setState(() => _busy = true);
    final actions = ref.read(activitiesActionsProvider);
    final category = ActivityCategory(_category.text.trim());

    final failure = _isEdit
        ? await actions.editActivity(
            UpdateActivityCommand(
              id: widget.activity!.id,
              title: _title.text.trim(),
              description: _description.text.trim(),
              category: category,
              imageId: _imageId,
              clearImage: _imageId == null,
            ),
          )
        : await actions.create(
            CreateActivityCommand(
              title: _title.text.trim(),
              description: _description.text.trim(),
              category: category,
              createdBy: createdBy,
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
      title: Text(_isEdit ? 'Editar actividad' : 'Nueva actividad'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('activity_title'),
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                key: const Key('activity_description'),
                controller: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                key: const Key('activity_category'),
                controller: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: Text(_imageId == null ? 'Añadir imagen' : 'Cambiar'),
                  ),
                  if (_imageId != null)
                    IconButton(
                      tooltip: 'Quitar imagen',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _imageId = null),
                    ),
                ],
              ),
              if (_imageError != null)
                Text(
                  _imageError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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
          key: const Key('activity_save'),
          onPressed: _busy ? null : _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

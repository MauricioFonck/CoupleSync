import '../../domain/value_objects/activity_category.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/severity.dart';
import '../../domain/value_objects/statuses.dart';
import '../../domain/value_objects/week_id.dart';

/// Comando para crear una actividad.
final class CreateActivityCommand {
  const CreateActivityCommand({
    required this.title,
    required this.description,
    required this.category,
    required this.createdBy,
    this.imageId,
  });

  final String title;
  final String description;
  final ActivityCategory category;
  final UserId createdBy;
  final MediaId? imageId;
}

/// Comando para actualizar una actividad (campos opcionales = sin cambio).
final class UpdateActivityCommand {
  const UpdateActivityCommand({
    required this.id,
    this.title,
    this.description,
    this.category,
    this.imageId,
    this.clearImage = false,
  });

  final ActivityId id;
  final String? title;
  final String? description;
  final ActivityCategory? category;
  final MediaId? imageId;
  final bool clearImage;
}

/// Comando para crear una penitencia.
final class CreatePenaltyCommand {
  const CreatePenaltyCommand({
    required this.title,
    required this.description,
    required this.severity,
    this.imageId,
  });

  final String title;
  final String description;
  final Severity severity;
  final MediaId? imageId;
}

/// Comando para actualizar una penitencia.
final class UpdatePenaltyCommand {
  const UpdatePenaltyCommand({
    required this.id,
    this.title,
    this.description,
    this.severity,
    this.imageId,
    this.clearImage = false,
  });

  final PenaltyId id;
  final String? title;
  final String? description;
  final Severity? severity;
  final MediaId? imageId;
  final bool clearImage;
}

/// Comando para confirmar (aprobar/rechazar) una actividad de un evento.
final class ConfirmActivityCommand {
  const ConfirmActivityCommand({
    required this.eventId,
    required this.userId,
    required this.activityId,
    required this.status,
  });

  final ScheduledEventId eventId;
  final UserId userId;
  final ActivityId activityId;
  final ConfirmationStatus status;
}

/// Comando para generar la agenda de una semana.
final class GenerateScheduleCommand {
  const GenerateScheduleCommand({
    required this.targetWeek,
    required this.partnerA,
    required this.partnerB,
  });

  final WeekId targetWeek;
  final UserId partnerA;
  final UserId partnerB;
}

/// Comando para reprogramar un evento.
final class RescheduleEventCommand {
  const RescheduleEventCommand({required this.eventId, required this.newDate});

  final ScheduledEventId eventId;
  final DateTime newDate;
}

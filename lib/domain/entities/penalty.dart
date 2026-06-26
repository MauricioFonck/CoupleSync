import '../value_objects/ids.dart';
import '../value_objects/severity.dart';

/// Penitencia / penalización. CRUD completo + activar/desactivar.
final class Penalty {
  const Penalty({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.active,
    this.imageId,
  });

  final PenaltyId id;
  final String title;
  final String description;
  final Severity severity;
  final bool active;
  final MediaId? imageId;

  Penalty copyWith({
    String? title,
    String? description,
    Severity? severity,
    bool? active,
    MediaId? imageId,
    bool clearImage = false,
  }) => Penalty(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    severity: severity ?? this.severity,
    active: active ?? this.active,
    imageId: clearImage ? null : (imageId ?? this.imageId),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Penalty &&
          other.id == id &&
          other.title == title &&
          other.description == description &&
          other.severity == severity &&
          other.active == active &&
          other.imageId == imageId);

  @override
  int get hashCode =>
      Object.hash(id, title, description, severity, active, imageId);

  @override
  String toString() => 'Penalty($id, "$title", $severity, active=$active)';
}

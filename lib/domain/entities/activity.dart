import '../value_objects/activity_category.dart';
import '../value_objects/ids.dart';

/// Actividad de pareja. CRUD + activar/desactivar. La imagen (opcional) se
/// referencia por `imageId`; el blob vive en la colección `media` (ver D1).
final class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdBy,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.imageId,
  });

  final ActivityId id;
  final String title;
  final String description;
  final ActivityCategory category;
  final UserId createdBy;
  final bool active;
  final MediaId? imageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity copyWith({
    String? title,
    String? description,
    ActivityCategory? category,
    bool? active,
    MediaId? imageId,
    bool clearImage = false,
    DateTime? updatedAt,
  }) =>
      Activity(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        createdBy: createdBy,
        active: active ?? this.active,
        imageId: clearImage ? null : (imageId ?? this.imageId),
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == id &&
          other.title == title &&
          other.description == description &&
          other.category == category &&
          other.createdBy == createdBy &&
          other.active == active &&
          other.imageId == imageId &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt);

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        category,
        createdBy,
        active,
        imageId,
        createdAt,
        updatedAt,
      );

  @override
  String toString() => 'Activity($id, "$title", active=$active)';
}

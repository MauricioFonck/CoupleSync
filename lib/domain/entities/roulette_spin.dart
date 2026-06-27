import '../value_objects/ids.dart';
import '../value_objects/intensity_level.dart';

/// Registro de una tirada de la ruleta (historial). Guarda una instantánea del
/// texto/nivel y si la pareja la marcó como "hecha".
final class RouletteSpin {
  const RouletteSpin({
    required this.id,
    required this.itemId,
    required this.text,
    required this.level,
    required this.createdAt,
    required this.done,
  });

  final RouletteSpinId id;
  final RouletteItemId itemId;
  final String text;
  final IntensityLevel level;
  final DateTime createdAt;
  final bool done;

  RouletteSpin copyWith({bool? done}) => RouletteSpin(
    id: id,
    itemId: itemId,
    text: text,
    level: level,
    createdAt: createdAt,
    done: done ?? this.done,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouletteSpin &&
          other.id == id &&
          other.itemId == itemId &&
          other.text == text &&
          other.level == level &&
          other.createdAt == createdAt &&
          other.done == done);

  @override
  int get hashCode => Object.hash(id, itemId, text, level, createdAt, done);

  @override
  String toString() => 'RouletteSpin($id, done=$done)';
}

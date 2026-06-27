import '../value_objects/ids.dart';
import '../value_objects/intensity_level.dart';

/// Ítem de la ruleta privada de la pareja. `favorite` marca los "buenos" que usa
/// el modo "girar hasta algo bueno"; `level` permite filtrar por intensidad.
final class RouletteItem {
  const RouletteItem({
    required this.id,
    required this.text,
    required this.favorite,
    this.level = IntensityLevel.medium,
  });

  final RouletteItemId id;
  final String text;
  final bool favorite;
  final IntensityLevel level;

  RouletteItem copyWith({
    String? text,
    bool? favorite,
    IntensityLevel? level,
  }) => RouletteItem(
    id: id,
    text: text ?? this.text,
    favorite: favorite ?? this.favorite,
    level: level ?? this.level,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouletteItem &&
          other.id == id &&
          other.text == text &&
          other.favorite == favorite &&
          other.level == level);

  @override
  int get hashCode => Object.hash(id, text, favorite, level);

  @override
  String toString() => 'RouletteItem($id, $level, favorite=$favorite)';
}

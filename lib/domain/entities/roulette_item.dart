import '../value_objects/ids.dart';

/// Ítem de la ruleta privada de la pareja. `favorite` marca los "buenos" que usa
/// el modo "girar hasta algo bueno".
final class RouletteItem {
  const RouletteItem({
    required this.id,
    required this.text,
    required this.favorite,
  });

  final RouletteItemId id;
  final String text;
  final bool favorite;

  RouletteItem copyWith({String? text, bool? favorite}) => RouletteItem(
    id: id,
    text: text ?? this.text,
    favorite: favorite ?? this.favorite,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouletteItem &&
          other.id == id &&
          other.text == text &&
          other.favorite == favorite);

  @override
  int get hashCode => Object.hash(id, text, favorite);

  @override
  String toString() => 'RouletteItem($id, favorite=$favorite)';
}

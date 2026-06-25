import '../value_objects/ids.dart';

/// Uno de los dos usuarios de la pareja (A o B). Predefinido en Firebase Auth.
final class User {
  const User({required this.id, required this.displayName});

  final UserId id;
  final String displayName;

  User copyWith({UserId? id, String? displayName}) => User(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User && other.id == id && other.displayName == displayName);

  @override
  int get hashCode => Object.hash(id, displayName);

  @override
  String toString() => 'User($id, $displayName)';
}

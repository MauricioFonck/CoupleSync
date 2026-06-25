import '../exceptions/domain_exception.dart';

/// Categoría de una actividad. Conjunto abierto (definible por la pareja),
/// normalizada: sin espacios sobrantes y de longitud acotada.
final class ActivityCategory {
  factory ActivityCategory(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      throw const DomainValidationException(
        'La categoría no puede estar vacía.',
      );
    }
    if (normalized.length > _maxLength) {
      throw DomainValidationException(
        'Categoría demasiado larga (${normalized.length} > $_maxLength).',
      );
    }
    return ActivityCategory._(normalized);
  }

  const ActivityCategory._(this.value);

  static const int _maxLength = 40;

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityCategory && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ActivityCategory($value)';
}

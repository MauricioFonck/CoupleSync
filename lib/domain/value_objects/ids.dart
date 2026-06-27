import 'identifier.dart';

/// Identidad de un usuario (UID de Firebase Auth). Solo existen A y B.
final class UserId extends Identifier {
  UserId(super.value);
}

/// Identidad de una actividad.
final class ActivityId extends Identifier {
  ActivityId(super.value);
}

/// Identidad de una penitencia.
final class PenaltyId extends Identifier {
  PenaltyId(super.value);
}

/// Identidad de un blob de media (colección `media/{mediaId}`, ver D1).
final class MediaId extends Identifier {
  MediaId(super.value);
}

/// Identidad de un evento programado.
final class ScheduledEventId extends Identifier {
  ScheduledEventId(super.value);
}

/// Identidad de un ítem de la ruleta.
final class RouletteItemId extends Identifier {
  RouletteItemId(super.value);
}

/// Identidad de una tirada de la ruleta (historial).
final class RouletteSpinId extends Identifier {
  RouletteSpinId(super.value);
}

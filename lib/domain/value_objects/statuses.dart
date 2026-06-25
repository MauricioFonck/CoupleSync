/// Estado de un evento programado.
enum CompletionStatus {
  pending,
  completed,
  missed,
  rescheduled;

  bool get isPending => this == CompletionStatus.pending;
  bool get isClosed =>
      this == CompletionStatus.completed || this == CompletionStatus.missed;
}

/// Estado de la confirmación de un usuario sobre una actividad.
enum ConfirmationStatus {
  pending,
  approved,
  rejected;

  bool get isApproved => this == ConfirmationStatus.approved;
  bool get isResolved => this != ConfirmationStatus.pending;
}

import '../../domain/entities/scheduled_event.dart';
import '../../domain/use_cases/confirm_activity_use_case.dart';
import '../../domain/value_objects/ids.dart';
import '../commands/commands.dart';
import '../result.dart';

/// Orquesta el flujo de confirmaciones. El cierre del evento (cuando ambos
/// aprueban) lo decide el caso de uso de dominio.
class ConfirmationService {
  const ConfirmationService({required ConfirmActivityUseCase confirmActivity})
    : _confirm = confirmActivity;

  final ConfirmActivityUseCase _confirm;

  /// Confirma una actividad. [partnerA]/[partnerB] son los dos usuarios de la
  /// pareja, necesarios para evaluar la regla "se completa solo si ambos
  /// aprueban".
  Future<Result<ScheduledEvent>> confirm(
    ConfirmActivityCommand command, {
    required UserId partnerA,
    required UserId partnerB,
  }) => runCatching(
    () => _confirm.execute(
      eventId: command.eventId,
      userId: command.userId,
      activityId: command.activityId,
      status: command.status,
      partnerA: partnerA,
      partnerB: partnerB,
    ),
  );
}

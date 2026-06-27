import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/services/availability_service.dart';
import '../../domain/entities/availability.dart';
import 'app_providers.dart';

/// Disponibilidad del usuario autenticado **en tiempo real**.
final availabilityProvider = StreamProvider<Availability>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    throw StateError('No hay usuario autenticado.');
  }
  return ref.watch(availabilityServiceProvider).watch(userId);
});

/// Acción para guardar la disponibilidad. El stream refleja el cambio solo.
final availabilityActionsProvider = Provider<AvailabilityActions>(
  (ref) => AvailabilityActions(ref.read(availabilityServiceProvider)),
);

class AvailabilityActions {
  const AvailabilityActions(this._service);

  final AvailabilityService _service;

  Future<AppFailure?> save(Availability availability) async =>
      (await _service.set(availability)).failureOrNull;
}

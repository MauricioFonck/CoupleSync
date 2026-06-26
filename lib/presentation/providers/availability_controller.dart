import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/queries/queries.dart';
import '../../domain/entities/availability.dart';
import 'app_providers.dart';

/// Carga/guarda la disponibilidad del usuario autenticado.
final availabilityControllerProvider =
    AsyncNotifierProvider<AvailabilityController, Availability>(
      AvailabilityController.new,
    );

class AvailabilityController extends AsyncNotifier<Availability> {
  @override
  Future<Availability> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) {
      throw StateError('No hay usuario autenticado.');
    }
    final result = await ref
        .read(availabilityServiceProvider)
        .get(AvailabilityQuery(userId));
    return result.fold((value) => value, (failure) => throw failure);
  }

  Future<AppFailure?> save(Availability availability) async {
    final result = await ref
        .read(availabilityServiceProvider)
        .set(availability);
    final failure = result.failureOrNull;
    if (failure == null) {
      state = AsyncData(availability);
    }
    return failure;
  }
}

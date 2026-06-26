import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/activity_service.dart';
import '../../application/services/availability_service.dart';
import '../../application/services/confirmation_service.dart';
import '../../application/services/penalty_service.dart';
import '../../application/services/scheduling_service.dart';
import '../../application/services/statistics_service.dart';
import '../../domain/entities/user.dart';
import '../../infrastructure/composition_root.dart';

/// Raíz de composición. Se **sobrescribe** en `main()` (con Firebase real) y en
/// los tests (con dobles), de modo que la presentación nunca construye Firebase.
final compositionRootProvider = Provider<CompositionRoot>((ref) {
  throw UnimplementedError(
    'compositionRootProvider debe overridearse en main() o en los tests.',
  );
});

/// Estado de autenticación (usuario actual o null).
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(compositionRootProvider).authPort.authStateChanges(),
);

final activityServiceProvider = Provider<ActivityService>(
  (ref) => ref.watch(compositionRootProvider).activityService,
);

final penaltyServiceProvider = Provider<PenaltyService>(
  (ref) => ref.watch(compositionRootProvider).penaltyService,
);

final availabilityServiceProvider = Provider<AvailabilityService>(
  (ref) => ref.watch(compositionRootProvider).availabilityService,
);

final schedulingServiceProvider = Provider<SchedulingService>(
  (ref) => ref.watch(compositionRootProvider).schedulingService,
);

final confirmationServiceProvider = Provider<ConfirmationService>(
  (ref) => ref.watch(compositionRootProvider).confirmationService,
);

final statisticsServiceProvider = Provider<StatisticsService>(
  (ref) => ref.watch(compositionRootProvider).statisticsService,
);

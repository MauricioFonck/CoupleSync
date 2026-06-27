import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../application/services/activity_service.dart';
import '../application/services/availability_service.dart';
import '../application/services/confirmation_service.dart';
import '../application/services/couple_service.dart';
import '../application/services/lazy_schedule_service.dart';
import '../application/services/penalty_service.dart';
import '../application/services/roulette_service.dart';
import '../application/services/scheduling_service.dart';
import '../application/services/statistics_service.dart';
import '../domain/ports/auth_port.dart';
import '../domain/ports/clock_port.dart';
import '../domain/ports/id_generator_port.dart';
import '../domain/ports/media_processor_port.dart';
import '../domain/ports/media_repository_port.dart';
import '../domain/ports/notification_token_port.dart';
import '../domain/ports/random_port.dart';
import '../domain/use_cases/activity_use_cases.dart';
import '../domain/use_cases/availability_use_cases.dart';
import '../domain/use_cases/calculate_streaks_use_case.dart';
import '../domain/use_cases/confirm_activity_use_case.dart';
import '../domain/use_cases/generate_penalty_use_case.dart';
import '../domain/use_cases/generate_weekly_schedule_use_case.dart';
import '../domain/use_cases/penalty_use_cases.dart';
import '../domain/use_cases/reschedule_event_use_case.dart';
import '../domain/use_cases/roulette_use_cases.dart';
import 'authentication/firebase_auth_adapter.dart';
import 'dart_random.dart';
import 'media/image_media_processor.dart';
import 'notifications/fcm_notification_token_adapter.dart';
import 'repositories/firestore_activity_repository.dart';
import 'repositories/firestore_availability_repository.dart';
import 'repositories/firestore_confirmation_repository.dart';
import 'repositories/firestore_media_repository.dart';
import 'repositories/firestore_penalty_repository.dart';
import 'repositories/firestore_roulette_history_repository.dart';
import 'repositories/firestore_roulette_repository.dart';
import 'repositories/firestore_scheduled_event_repository.dart';
import 'repositories/firestore_settings_repository.dart';
import 'repositories/firestore_statistics_repository.dart';
import 'repositories/firestore_user_repository.dart';
import 'repositories/firestore_weekly_schedule_repository.dart';
import 'system_clock.dart';
import 'uuid_id_generator.dart';

/// Composition Root / DI de CoupleSync. Construye el grafo de objetos (ports →
/// adaptadores concretos) en un único lugar. La presentación consume estos
/// servicios sin conocer Firebase.
class CompositionRoot {
  CompositionRoot({
    required FirebaseFirestore firestore,
    required fb.FirebaseAuth auth,
    FirebaseMessaging? messaging,
    ClockPort? clock,
    RandomPort? random,
    IdGeneratorPort? idGenerator,
    String? fcmVapidKey,
  }) {
    final ClockPort clockPort = clock ?? const SystemClock();
    final RandomPort randomPort = random ?? DartRandom();
    final IdGeneratorPort idGen = idGenerator ?? UuidIdGenerator();

    // Repositorios (adaptadores Firestore).
    final activities = FirestoreActivityRepository(firestore);
    final penalties = FirestorePenaltyRepository(firestore);
    final availability = FirestoreAvailabilityRepository(firestore);
    final scheduledEvents = FirestoreScheduledEventRepository(firestore);
    final confirmations = FirestoreConfirmationRepository(firestore);
    final weeklySchedules = FirestoreWeeklyScheduleRepository(firestore);
    final settings = FirestoreSettingsRepository(firestore);
    final statistics = FirestoreStatisticsRepository(firestore);
    final users = FirestoreUserRepository(firestore);
    mediaRepository = FirestoreMediaRepository(firestore);

    // Adaptadores de servicio.
    authPort = FirebaseAuthAdapter(auth);
    mediaProcessor = ImageMediaProcessor(idGenerator: idGen, clock: clockPort);
    notificationTokenPort = messaging == null
        ? null
        : FcmNotificationTokenAdapter(
            messaging: messaging,
            firestore: firestore,
            vapidKey: fcmVapidKey,
          );

    // Servicios de aplicación (orquestan los casos de uso).
    activityService = ActivityService(
      createActivity: CreateActivityUseCase(
        activityRepository: activities,
        idGenerator: idGen,
        clock: clockPort,
      ),
      updateActivity: UpdateActivityUseCase(
        activityRepository: activities,
        clock: clockPort,
      ),
      setActivityActive: SetActivityActiveUseCase(
        activityRepository: activities,
        clock: clockPort,
      ),
      deleteActivity: DeleteActivityUseCase(activityRepository: activities),
      activityRepository: activities,
    );

    penaltyService = PenaltyService(
      createPenalty: CreatePenaltyUseCase(
        penaltyRepository: penalties,
        idGenerator: idGen,
      ),
      updatePenalty: UpdatePenaltyUseCase(penaltyRepository: penalties),
      setPenaltyActive: SetPenaltyActiveUseCase(penaltyRepository: penalties),
      deletePenalty: DeletePenaltyUseCase(penaltyRepository: penalties),
      generatePenalty: GeneratePenaltyUseCase(
        penaltyRepository: penalties,
        random: randomPort,
      ),
      penaltyRepository: penalties,
    );

    availabilityService = AvailabilityService(
      getAvailability: GetAvailabilityUseCase(
        availabilityRepository: availability,
      ),
      setAvailability: SetAvailabilityUseCase(
        availabilityRepository: availability,
      ),
    );

    schedulingService = SchedulingService(
      generateWeeklySchedule: GenerateWeeklyScheduleUseCase(
        activityRepository: activities,
        availabilityRepository: availability,
        settingsRepository: settings,
        weeklyScheduleRepository: weeklySchedules,
        clock: clockPort,
        random: randomPort,
      ),
      rescheduleEvent: RescheduleEventUseCase(
        scheduledEventRepository: scheduledEvents,
      ),
      scheduledEventRepository: scheduledEvents,
    );

    confirmationService = ConfirmationService(
      confirmActivity: ConfirmActivityUseCase(
        scheduledEventRepository: scheduledEvents,
        confirmationRepository: confirmations,
      ),
    );

    statisticsService = StatisticsService(
      calculateStreaks: CalculateStreaksUseCase(
        scheduledEventRepository: scheduledEvents,
        clock: clockPort,
      ),
      statisticsRepository: statistics,
    );

    coupleService = CoupleService(userRepository: users);
    lazyScheduleService = LazyScheduleService(
      scheduling: schedulingService,
      clock: clockPort,
    );

    final roulette = FirestoreRouletteRepository(firestore);
    final rouletteHistory = FirestoreRouletteHistoryRepository(firestore);
    rouletteService = RouletteService(
      rouletteRepository: roulette,
      historyRepository: rouletteHistory,
      idGenerator: idGen,
      clock: clockPort,
      importItems: ImportRouletteItemsUseCase(
        rouletteRepository: roulette,
        idGenerator: idGen,
      ),
      drawRoulette: DrawRouletteUseCase(random: randomPort),
      spinRoulette: SpinRouletteUseCase(random: randomPort),
      spinFavorite: SpinFavoriteUseCase(random: randomPort),
    );
  }

  late final AuthPort authPort;
  late final MediaProcessorPort mediaProcessor;
  late final MediaRepositoryPort mediaRepository;
  late final NotificationTokenPort? notificationTokenPort;

  late final ActivityService activityService;
  late final PenaltyService penaltyService;
  late final AvailabilityService availabilityService;
  late final SchedulingService schedulingService;
  late final ConfirmationService confirmationService;
  late final StatisticsService statisticsService;
  late final CoupleService coupleService;
  late final LazyScheduleService lazyScheduleService;
  late final RouletteService rouletteService;
}

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_providers.dart';
import '../screens/activities_screen.dart';
import '../screens/availability_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/history_screen.dart';
import '../screens/login_screen.dart';
import '../screens/penalties_screen.dart';
import '../screens/schedule_screen.dart';
import '../widgets/app_shell.dart';

/// Router de la app con **guard de autenticación**: sin sesión redirige a
/// `/login`; con sesión, `/login` redirige a `/dashboard`.
final routerProvider = Provider<GoRouter>((ref) {
  // Notifica a GoRouter cuando cambia el estado de auth para reevaluar el guard.
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      // Mientras carga el primer estado de auth, no redirige.
      if (auth.isLoading) return null;
      final loggedIn = auth.asData?.value != null;
      final loggingIn = state.matchedLocation == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';
      if (loggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/activities',
            builder: (context, state) => const ActivitiesScreen(),
          ),
          GoRoute(
            path: '/penalties',
            builder: (context, state) => const PenaltiesScreen(),
          ),
          GoRoute(
            path: '/availability',
            builder: (context, state) => const AvailabilityScreen(),
          ),
          GoRoute(
            path: '/schedule',
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
        ],
      ),
    ],
  );
});

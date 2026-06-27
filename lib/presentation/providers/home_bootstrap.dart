import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

/// Arranque al entrar autenticado: registra el perfil del usuario y dispara la
/// *lazy generation* de la agenda si se conocen los dos miembros de la pareja
/// (D2). Refresca la agenda al terminar.
final homeBootstrapProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) return;

  final couple = ref.read(coupleServiceProvider);
  await couple.registerProfile(user);

  // Registro de token FCM (best-effort; null en tests).
  final tokens = ref.read(notificationTokenPortProvider);
  if (tokens != null) {
    try {
      final token = await tokens.currentToken();
      if (token != null) await tokens.register(user.id, token);
    } on Object {
      // El push es opcional; no bloquea el arranque.
    }
  }

  final idsResult = await couple.coupleUserIds();
  final ids = idsResult.valueOrNull ?? const [];
  if (ids.length < 2) return; // hace falta conocer a ambos miembros

  final partnerA = user.id;
  final partnerB = ids.firstWhere(
    (id) => id != partnerA,
    orElse: () => partnerA,
  );
  if (partnerB == partnerA) return;

  // La agenda es un stream en tiempo real: los eventos generados aparecen solos.
  await ref
      .read(lazyScheduleServiceProvider)
      .ensureUpcoming(partnerA: partnerA, partnerB: partnerB);
});

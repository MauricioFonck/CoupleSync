import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `true` si hay conexión. Asume **online** mientras carga o si el plugin no
/// está disponible (p. ej. en tests), para no mostrar el banner por error.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  yield true;
  try {
    yield* Connectivity().onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  } on Object {
    yield true;
  }
});

/// Valor síncrono cómodo: online salvo que sepamos con certeza que no.
final isOnlineProvider = Provider<bool>(
  (ref) => ref.watch(connectivityProvider).asData?.value ?? true,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/exceptions/domain_exception.dart';
import 'app_providers.dart';

/// Controlador del flujo de inicio de sesión. Expone `AsyncValue<void>` para
/// que la UI muestre loading/error.
final signInControllerProvider =
    NotifierProvider<SignInController, AsyncValue<void>>(SignInController.new);

class SignInController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Devuelve `true` si el login fue correcto.
  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    final auth = ref.read(compositionRootProvider).authPort;
    try {
      await auth.signIn(email: email, password: password);
      state = const AsyncData(null);
      return true;
    } on DomainException catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<void> signOut() =>
      ref.read(compositionRootProvider).authPort.signOut();
}

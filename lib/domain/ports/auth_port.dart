import '../entities/user.dart';

/// Puerto de autenticación. Solo existen los usuarios A y B (sin registro).
abstract interface class AuthPort {
  /// Emite el usuario autenticado o `null` al cerrar sesión.
  Stream<User?> authStateChanges();

  /// Usuario autenticado actual, o `null`.
  Future<User?> currentUser();

  Future<User> signIn({required String email, required String password});
  Future<void> signOut();
}

import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/user.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/ports/auth_port.dart';
import '../../domain/value_objects/ids.dart';

/// Adaptador de [AuthPort] sobre Firebase Authentication. Solo existen A y B
/// (sin registro público).
class FirebaseAuthAdapter implements AuthPort {
  FirebaseAuthAdapter(this._auth);

  final fb.FirebaseAuth _auth;

  User? _map(fb.User? user) => user == null
      ? null
      : User(
          id: UserId(user.uid),
          displayName: user.displayName ?? user.email ?? user.uid,
        );

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges().map(_map);

  @override
  Future<User?> currentUser() async => _map(_auth.currentUser);

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _map(credential.user);
      if (user == null) {
        throw const DomainInvariantException(
          'Inicio de sesión sin usuario asociado.',
        );
      }
      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw DomainValidationException('Credenciales inválidas (${e.code}).');
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

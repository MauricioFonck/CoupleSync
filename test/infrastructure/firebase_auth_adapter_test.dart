import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/infrastructure/authentication/firebase_auth_adapter.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseAuthAdapter', () {
    test('signIn mapea el usuario de Firebase al dominio', () async {
      final auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'A', email: 'a@x.com', displayName: 'Ana'),
      );
      final adapter = FirebaseAuthAdapter(auth);

      final user = await adapter.signIn(email: 'a@x.com', password: 'pw');
      expect(user.id, UserId('A'));
      expect(user.displayName, 'Ana');

      expect((await adapter.currentUser())!.id, UserId('A'));
    });

    test('signOut deja la sesión sin usuario', () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'B', displayName: 'Bea'),
      );
      final adapter = FirebaseAuthAdapter(auth);
      expect(await adapter.currentUser(), isNotNull);

      await adapter.signOut();
      expect(await adapter.currentUser(), isNull);
    });

    test('authStateChanges emite el usuario mapeado', () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      );
      final adapter = FirebaseAuthAdapter(auth);
      final user = await adapter.authStateChanges().first;
      expect(user!.id, UserId('A'));
    });
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthIdentity {
  final String uid;
  final String? email;
  final String? displayName;

  const AuthIdentity({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  factory AuthIdentity.fromFirebase(User user) => AuthIdentity(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
}

abstract interface class AuthRepository {
  AuthIdentity? get currentUser;
  Stream<AuthIdentity?> get authStateChanges;

  Future<AuthIdentity> signIn({
    required String email,
    required String password,
  });

  Future<AuthIdentity> createAccount({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<bool> updateCredentials({
    required String currentPassword,
    required String email,
    String? newPassword,
  });

  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository() : _auth = FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static AuthRepository createDefault() => Firebase.apps.isEmpty
      ? const UnavailableAuthRepository()
      : FirebaseAuthRepository();

  @override
  AuthIdentity? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : AuthIdentity.fromFirebase(user);
  }

  @override
  Stream<AuthIdentity?> get authStateChanges => _auth.authStateChanges().map(
        (user) => user == null ? null : AuthIdentity.fromFirebase(user),
      );

  @override
  Future<AuthIdentity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final user = result.user;
      if (user == null) throw StateError('Authentication returned no user.');
      return AuthIdentity.fromFirebase(user);
    } on FirebaseAuthException catch (error) {
      throw StateError(authErrorMessage(error));
    }
  }

  @override
  Future<AuthIdentity> createAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final user = result.user;
      if (user == null) throw StateError('Authentication returned no user.');
      await user.updateDisplayName(displayName.trim());
      await user.reload();
      return AuthIdentity.fromFirebase(_auth.currentUser ?? user);
    } on FirebaseAuthException catch (error) {
      throw StateError(authErrorMessage(error));
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
    } on FirebaseAuthException catch (error) {
      throw StateError(authErrorMessage(error));
    }
  }

  @override
  Future<bool> updateCredentials({
    required String currentPassword,
    required String email,
    String? newPassword,
  }) async {
    final user = _auth.currentUser;
    final currentEmail = user?.email;
    if (user == null || currentEmail == null) {
      throw StateError('A signed-in email account is required.');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      final normalizedEmail = email.trim().toLowerCase();
      var emailChangePending = false;
      if (normalizedEmail != currentEmail) {
        await user.verifyBeforeUpdateEmail(normalizedEmail);
        emailChangePending = true;
      }
      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }
      return emailChangePending;
    } on FirebaseAuthException catch (error) {
      throw StateError(authErrorMessage(error));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

class UnavailableAuthRepository implements AuthRepository {
  const UnavailableAuthRepository();

  StateError _unavailable() => StateError(
        'Firebase is not configured. Run flutterfire configure from the '
        'workspace root, then enable Email/Password in Firebase Authentication.',
      );

  @override
  AuthIdentity? get currentUser => null;

  @override
  Stream<AuthIdentity?> get authStateChanges => const Stream.empty();

  @override
  Future<AuthIdentity> signIn({
    required String email,
    required String password,
  }) =>
      Future.error(_unavailable());

  @override
  Future<AuthIdentity> createAccount({
    required String email,
    required String password,
    required String displayName,
  }) =>
      Future.error(_unavailable());

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      Future.error(_unavailable());

  @override
  Future<bool> updateCredentials({
    required String currentPassword,
    required String email,
    String? newPassword,
  }) =>
      Future.error(_unavailable());

  @override
  Future<void> signOut() async {}
}

String authErrorMessage(FirebaseAuthException error) => switch (error.code) {
      'email-already-in-use' => 'This email address is already in use.',
      'invalid-email' => 'Enter a valid email address.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' =>
        'The email or password is incorrect.',
      'weak-password' => 'Use a stronger password (at least 6 characters).',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' =>
        'A network error occurred. Check your connection and try again.',
      'requires-recent-login' =>
        'Sign in again before changing your account credentials.',
      'operation-not-allowed' =>
        'Email/password sign-in is not enabled in Firebase Authentication.',
      _ => error.message ?? 'Authentication failed. Please try again.',
    };

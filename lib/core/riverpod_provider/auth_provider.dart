import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_task_manager/firebase/authentication/auth_service.dart'; // Adjust import path if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication loading state notifier
class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  /// Sign in with Google with loading state
  Future<User?> signInWithGoogle() async {
    state = true; // Loading start
    final authService = ref.read(authServiceProvider);
    User? user = await authService.signInWithGoogle();
    state = false; // Loading end
    return user;
  }

  /// Sign in with Email with loading state
  Future<User?> signInWithEmail(String email, String password) async {
    state = true;
    final authService = ref.read(authServiceProvider);
    User? user = await authService.signInWithEmail(email, password);
    state = false;
    return user;
  }

  /// Sign up with Email with loading state
  Future<User?> signUpWithEmail(String email, String password) async {
    state = true;
    final authService = ref.read(authServiceProvider);
    User? user = await authService.signUpWithEmail(email, password);
    state = false;
    return user;
  }
}

/// AuthNotifier global provider
final authNotifierProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});

/// Stream provider to track firebase authentication state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

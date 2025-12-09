import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

/// Provider for the AuthService singleton.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider for the current user state.
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider for user sign-up logic.
final signUpProvider = FutureProvider.family<UserCredential, ({String email, String password})>(
  (ref, credentials) async {
    final authService = ref.watch(authServiceProvider);
    return await authService.signUp(
      email: credentials.email,
      password: credentials.password,
    );
  },
);

/// Provider for user sign-in logic.
final signInProvider = FutureProvider.family<UserCredential, ({String email, String password})>(
  (ref, credentials) async {
    final authService = ref.watch(authServiceProvider);
    return await authService.signIn(
      email: credentials.email,
      password: credentials.password,
    );
  },
);

/// Provider for user sign-out logic.
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signOut();
});

/// Provider for password reset logic.
final resetPasswordProvider = FutureProvider.family<void, String>((ref, email) async {
  final authService = ref.watch(authServiceProvider);
  await authService.resetPassword(email: email);
});

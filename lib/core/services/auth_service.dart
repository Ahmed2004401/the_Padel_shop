import 'package:firebase_auth/firebase_auth.dart';

/// Service to handle Firebase Authentication operations.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Get the current user.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Validate email format (simple regex).
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength.
  /// Requirements: at least 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special char.
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false; // uppercase
    if (!password.contains(RegExp(r'[a-z]'))) return false; // lowercase
    if (!password.contains(RegExp(r'[0-9]'))) return false; // digit
    // Special characters check
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  /// Sign up with email and password.
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle reCAPTCHA configuration errors on mobile
      // User might still be created even if this error is thrown
      if (e.code.contains('internal-error') || 
          e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
        // Try signing in - if successful, user was created
        try {
          return await signIn(email: email, password: password);
        } catch (_) {
          // If sign in fails, rethrow the original error
          throw _handleAuthException(e);
        }
      }
      throw _handleAuthException(e);
    }
  }

  /// Sign in with email and password.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Reset password via email.
  Future<void> resetPassword({required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions and return user-friendly messages.
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      case 'internal-error':
        return 'Internal error. Your account may have been created. Please try logging in.';
      default:
        // Check if it's a reCAPTCHA config error
        if (e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
          return 'Security configuration error. Your account may have been created. Please try logging in.';
        }
        return 'Authentication error: ${e.message}';
    }
  }
}

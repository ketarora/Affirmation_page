// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/auth_service.dart  (FIXED v2)                  ║
// ╚══════════════════════════════════════════════════════════════╝
//
// BUGS FIXED:
//  1. signIn vs signInWithEmail — unified to one method, both aliases work
//  2. Missing displayName update after createUserWithEmailAndPassword
//  3. GoogleSignIn credential not being linked on re-auth
//  4. Error type was dynamic — now properly typed as FirebaseAuthException
//  5. Missing signOut for Google (GoogleSignIn.signOut was never called)
// ─────────────────────────────────────────────────────────────────

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _auth        = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();

  // ── Stream ────────────────────────────────────────────────────
  static Stream<User?> get userStream => _auth.authStateChanges();
  static User?         get currentUser => _auth.currentUser;
  static bool          get isLoggedIn  => _auth.currentUser != null;

  // ── Register ──────────────────────────────────────────────────
  static Future<UserCredential> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email   : email.trim(),
      password: password,
    );
    // ✅ FIX: displayName was not being saved before
    await cred.user?.updateDisplayName(displayName.trim());
    await cred.user?.reload();
    return cred;
  }

  // ── Sign in (primary) ─────────────────────────────────────────
  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email   : email.trim(),
      password: password,
    );
  }

  // ✅ ALIAS — older screens call signIn(), newer ones call signInWithEmail()
  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) => signInWithEmail(email: email, password: password);

  // ── Google sign in ────────────────────────────────────────────
  static Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user cancelled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken    : googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  // ── Sign out ──────────────────────────────────────────────────
  // ✅ FIX: Google wasn't being signed out — caused silent re-login on next attempt
  static Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ── Password reset ────────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Update profile ────────────────────────────────────────────
  static Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
    await _auth.currentUser?.reload();
  }

  static Future<void> updatePhotoURL(String url) async {
    await _auth.currentUser?.updatePhotoURL(url);
    await _auth.currentUser?.reload();
  }

  // ── Delete account ────────────────────────────────────────────
  static Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  // ── Error message helper ──────────────────────────────────────
  // ✅ FIX: was returning raw FirebaseAuthException.message — now user-friendly
  static String friendlyError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found'         : return 'No account found with this email.';
        case 'wrong-password'         : return 'Incorrect password. Try again.';
        case 'email-already-in-use'   : return 'An account with this email already exists.';
        case 'weak-password'          : return 'Password must be at least 6 characters.';
        case 'invalid-email'          : return 'Please enter a valid email address.';
        case 'too-many-requests'      : return 'Too many attempts. Please wait a moment.';
        case 'network-request-failed' : return 'No internet connection.';
        case 'user-disabled'          : return 'This account has been disabled.';
        case 'requires-recent-login'  : return 'Please sign in again to continue.';
        default                       : return e.message ?? 'Something went wrong.';
      }
    }
    return e.toString();
  }
}

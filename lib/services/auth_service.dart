// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/auth_service.dart                              ║
// ║  Full Firebase Auth — login, signup, reset, Google, logout   ║
// ╚══════════════════════════════════════════════════════════════╝
 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
 
class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db   = FirebaseFirestore.instance;
  static final _gsi  = GoogleSignIn();
 
  // ── Stream — listen for auth state changes everywhere ──────────
  static Stream<User?> get userStream => _auth.authStateChanges();
 
  static User? get currentUser => _auth.currentUser;
  static bool   get isLoggedIn  => _auth.currentUser != null;
 
  // ── Email / Password Login ─────────────────────────────────────
  static Future<UserCredential> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
      await _updateLastSeen(cred.user!.uid);
      return cred;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapCode(e.code));
    }
  }
 
  // ── Email / Password Signup ────────────────────────────────────
  static Future<UserCredential> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
 
      // Set display name
      await cred.user!.updateDisplayName(displayName.trim());
 
      // Create Firestore user document
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid'        : cred.user!.uid,
        'displayName': displayName.trim(),
        'email'      : email.trim(),
        'photoUrl'   : null,
        'streak'     : 0,
        'joinedAt'   : FieldValue.serverTimestamp(),
        'lastSeen'   : FieldValue.serverTimestamp(),
        'theme'      : 'rose',
        'language'   : 'en',
      });
      return cred;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapCode(e.code));
    }
  }
 
  // ── Google Sign-In ─────────────────────────────────────────────
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web — popup flow
        final provider = GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');
        return await _auth.signInWithPopup(provider);
      } else {
        // Mobile — native Google SDK
        final googleUser = await _gsi.signIn();
        if (googleUser == null) return null; // user cancelled
 
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken    : googleAuth.idToken,
        );
        final cred = await _auth.signInWithCredential(credential);
 
        // Create Firestore doc if first sign-in
        final doc = await _db.collection('users').doc(cred.user!.uid).get();
        if (!doc.exists) {
          await _db.collection('users').doc(cred.user!.uid).set({
            'uid'        : cred.user!.uid,
            'displayName': cred.user!.displayName ?? 'Soul',
            'email'      : cred.user!.email ?? '',
            'photoUrl'   : cred.user!.photoURL,
            'streak'     : 0,
            'joinedAt'   : FieldValue.serverTimestamp(),
            'lastSeen'   : FieldValue.serverTimestamp(),
            'theme'      : 'rose',
            'language'   : 'en',
          });
        } else {
          await _updateLastSeen(cred.user!.uid);
        }
        return cred;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapCode(e.code));
    } catch (e) {
      throw AuthException('Google sign-in failed. Please try again.');
    }
  }
 
  // ── Password Reset ─────────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapCode(e.code));
    }
  }
 
  // ── Logout ─────────────────────────────────────────────────────
  static Future<void> logout() async {
    await Future.wait([
      _auth.signOut(),
      if (!kIsWeb) _gsi.signOut().catchError((_) {}),
    ]);
    final prefs = await SharedPreferences.getInstance();
    // Keep theme + language — clear only auth related
    final theme    = prefs.getString('theme');
    final language = prefs.getString('language');
    await prefs.clear();
    if (theme    != null) await prefs.setString('theme', theme);
    if (language != null) await prefs.setString('language', language);
  }
 
  // ── Update display name ────────────────────────────────────────
  static Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
    await _db.collection('users').doc(_auth.currentUser?.uid).update({
      'displayName': name.trim(),
    });
  }
 
  // ── Delete account ─────────────────────────────────────────────
  static Future<void> deleteAccount() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    // Delete Firestore data first
    await _db.collection('users').doc(uid).delete();
    // Delete auth user
    await _auth.currentUser?.delete();
    // Clear prefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
 
  // ── Private helpers ────────────────────────────────────────────
  static Future<void> _updateLastSeen(String uid) async {
    await _db.collection('users').doc(uid).update({
      'lastSeen': FieldValue.serverTimestamp(),
    }).catchError((_) {}); // Don't crash login if Firestore update fails
  }
 
  static String _mapCode(String code) => switch (code) {
    'user-not-found'        => 'No account found with this email.',
    'wrong-password'        => 'Incorrect password. Please try again.',
    'email-already-in-use'  => 'An account already exists with this email.',
    'weak-password'         => 'Password must be at least 6 characters.',
    'invalid-email'         => 'Please enter a valid email address.',
    'too-many-requests'     => 'Too many attempts. Please wait and try again.',
    'network-request-failed'=> 'No internet connection.',
    'user-disabled'         => 'This account has been disabled.',
    _                       => 'Something went wrong. Please try again.',
  };
}
 
// Custom exception for UI-friendly messages
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override String toString() => message;
}

// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/screens/login_screen.dart                               ║
// ║  Full auth UI — Login | Signup | Forgot Password | Google    ║
// ╚══════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

enum _AuthMode { login, signup, forgot }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _AuthMode _mode = _AuthMode.login;

  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  final _nameCtrl   = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  bool _loading   = false;
  bool _obscure   = true;
  String? _error;
  String? _success;

  // ── Brand colors ───────────────────────────────────────────────
  static const _pink   = Color(0xFFFF82A9);
  static const _purple = Color(0xFFAC7BED);
  static const _dark   = Color(0xFF1C0040);
  static const _bg     = Color(0xFF0D0022);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // ── Submit handler ─────────────────────────────────────────────
  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; _success = null; });

    try {
      switch (_mode) {
        case _AuthMode.login:
          await AuthService.login(_emailCtrl.text, _passCtrl.text);
          if (mounted) Navigator.pushReplacementNamed(context, '/home');

        case _AuthMode.signup:
          await AuthService.signup(
            email      : _emailCtrl.text,
            password   : _passCtrl.text,
            displayName: _nameCtrl.text,
          );
          if (mounted) Navigator.pushReplacementNamed(context, '/home');

        case _AuthMode.forgot:
          await AuthService.sendPasswordReset(_emailCtrl.text);
          setState(() {
            _success = 'Reset link sent to ${_emailCtrl.text}. Check your inbox ✉️';
            _mode    = _AuthMode.login;
          });
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      final cred = await AuthService.signInWithGoogle();
      if (cred != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Google sign-in failed.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(children: [

        // Background gradient
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin : Alignment.topCenter,
              end   : Alignment.bottomCenter,
              colors: [Color(0xFF0D0022), Color(0xFF1C0040), Color(0xFF0A001A)],
              stops : [0.0, 0.5, 1.0],
            ),
          ),
          child: SizedBox.expand(),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child  : Form(
              key  : _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children          : [
                  const SizedBox(height: 24),

                  // Logo
                  Image.asset(
                    'assets/images/image.png',
                    height     : 60,
                    fit        : BoxFit.contain,
                    errorBuilder: (_, __, ___) => _logoFallback(),
                  ).animate().fadeIn(duration: 700.ms),

                  const SizedBox(height: 36),

                  // Title
                  Text(
                    _modeTitle,
                    style    : GoogleFonts.playfairDisplay(
                      fontSize  : 26,
                      fontWeight: FontWeight.bold,
                      color     : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.4),

                  const SizedBox(height: 6),

                  Text(
                    _modeSubtitle,
                    style    : GoogleFonts.poppins(
                      fontSize: 13, color: Colors.white60),
                    textAlign: TextAlign.center,
                  ).animate(delay: 150.ms).fadeIn(),

                  const SizedBox(height: 32),

                  // ── Error / success banners ──────────────────────
                  if (_error != null)
                    _Banner(text: _error!, isError: true)
                        .animate().fadeIn().slideY(begin: -0.3),

                  if (_success != null)
                    _Banner(text: _success!, isError: false)
                        .animate().fadeIn().slideY(begin: -0.3),

                  if (_error != null || _success != null)
                    const SizedBox(height: 16),

                  // ── Name field (signup only) ─────────────────────
                  if (_mode == _AuthMode.signup) ...[
                    _Field(
                      controller : _nameCtrl,
                      label      : 'Your name',
                      hint       : 'e.g. Nisha',
                      icon       : Icons.person_outline_rounded,
                      validator  : (v) =>
                          (v?.trim().isEmpty ?? true) ? 'Please enter your name' : null,
                    ).animate(delay: 50.ms).fadeIn().slideY(begin: 0.3),
                    const SizedBox(height: 14),
                  ],

                  // ── Email ────────────────────────────────────────
                  _Field(
                    controller: _emailCtrl,
                    label     : 'Email',
                    hint      : 'your@email.com',
                    icon      : Icons.mail_outline_rounded,
                    type      : TextInputType.emailAddress,
                    validator : (v) {
                      if (v?.trim().isEmpty ?? true) return 'Enter your email';
                      if (!v!.contains('@'))         return 'Enter a valid email';
                      return null;
                    },
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3),

                  // ── Password (not for forgot) ─────────────────────
                  if (_mode != _AuthMode.forgot) ...[
                    const SizedBox(height: 14),
                    _Field(
                      controller: _passCtrl,
                      label     : 'Password',
                      hint      : '••••••••',
                      icon      : Icons.lock_outline_rounded,
                      obscure   : _obscure,
                      suffixIcon: IconButton(
                        icon : Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                            color: Colors.white38, size: 20),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator : (v) {
                        if (v?.isEmpty ?? true)   return 'Enter your password';
                        if (_mode == _AuthMode.signup && v!.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.3),
                  ],

                  const SizedBox(height: 24),

                  // ── Primary CTA button ────────────────────────────
                  _loading
                      ? const Center(child: CircularProgressIndicator(
                          color: _pink, strokeWidth: 2))
                      : _GradientButton(
                          label    : _modeButtonLabel,
                          onPressed: _submit,
                        ).animate(delay: 200.ms).fadeIn().scale(
                              begin: const Offset(0.95, 0.95)),

                  const SizedBox(height: 20),

                  // ── Forgot password link ──────────────────────────
                  if (_mode == _AuthMode.login)
                    TextButton(
                      onPressed: () => setState(() {
                        _mode = _AuthMode.forgot; _error = null;
                      }),
                      child: Text('Forgot password?',
                          style: GoogleFonts.poppins(
                              color: _pink.withOpacity(0.8), fontSize: 13)),
                    ),

                  // ── Or divider ────────────────────────────────────
                  if (_mode != _AuthMode.forgot) ...[
                    Row(children: [
                      const Expanded(child: Divider(color: Colors.white12)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child  : Text('or',
                            style: GoogleFonts.poppins(
                                color: Colors.white38, fontSize: 12)),
                      ),
                      const Expanded(child: Divider(color: Colors.white12)),
                    ]),

                    const SizedBox(height: 16),

                    // ── Google Sign-In ────────────────────────────────
                    OutlinedButton.icon(
                      onPressed: _googleSignIn,
                      icon     : Image.network(
                        'https://www.google.com/favicon.ico',
                        width : 18,
                        height: 18,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.g_mobiledata, size: 22, color: Colors.white),
                      ),
                      label: Text('Continue with Google',
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        padding      : const EdgeInsets.symmetric(vertical: 14),
                        side         : const BorderSide(color: Colors.white24),
                        shape        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ).animate(delay: 250.ms).fadeIn(),
                  ],

                  const SizedBox(height: 28),

                  // ── Switch mode link ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children         : [
                      Text(
                        _mode == _AuthMode.login
                            ? "Don't have an account? "
                            : _mode == _AuthMode.forgot
                                ? 'Remember it? '
                                : 'Already have an account? ',
                        style: GoogleFonts.poppins(
                            color: Colors.white38, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _mode    = _mode == _AuthMode.login
                              ? _AuthMode.signup
                              : _AuthMode.login;
                          _error   = null;
                          _success = null;
                        }),
                        child: Text(
                          _mode == _AuthMode.login ? 'Sign up' : 'Log in',
                          style: GoogleFonts.poppins(
                              color     : _pink,
                              fontSize  : 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  String get _modeTitle => switch (_mode) {
    _AuthMode.login  => 'Welcome back 🌸',
    _AuthMode.signup => 'Begin your journey ✨',
    _AuthMode.forgot => 'Reset password 🔑',
  };

  String get _modeSubtitle => switch (_mode) {
    _AuthMode.login  => 'Log in to continue your practice',
    _AuthMode.signup => 'Create your sacred space',
    _AuthMode.forgot => 'We\'ll send a reset link to your email',
  };

  String get _modeButtonLabel => switch (_mode) {
    _AuthMode.login  => 'Log In',
    _AuthMode.signup => 'Create Account',
    _AuthMode.forgot => 'Send Reset Link',
  };

  Widget _logoFallback() => ShaderMask(
    shaderCallback: (r) => const LinearGradient(
      colors: [_pink, _purple],
    ).createShader(r),
    child: Text('NishAffs',
      textAlign: TextAlign.center,
      style    : GoogleFonts.pacifico(color: Colors.white, fontSize: 30)),
  );
}

// ── Reusable text field ───────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final TextInputType type;
  final bool obscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.type      = TextInputType.text,
    this.obscure   = false,
    this.suffixIcon,
    this.validator,
  });

  static const _pink   = Color(0xFFFF82A9);
  static const _purple = Color(0xFFAC7BED);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller        : controller,
      keyboardType      : type,
      obscureText       : obscure,
      style             : const TextStyle(color: Colors.white),
      validator         : validator,
      decoration        : InputDecoration(
        labelText       : label,
        hintText        : hint,
        labelStyle      : const TextStyle(color: Colors.white54, fontSize: 13),
        hintStyle       : const TextStyle(color: Colors.white24, fontSize: 13),
        prefixIcon      : Icon(icon, color: _pink.withOpacity(0.6), size: 20),
        suffixIcon      : suffixIcon,
        enabledBorder   : OutlineInputBorder(
          borderRadius : BorderRadius.circular(14),
          borderSide   : const BorderSide(color: Colors.white16),
        ),
        focusedBorder   : OutlineInputBorder(
          borderRadius : BorderRadius.circular(14),
          borderSide   : const BorderSide(color: _pink, width: 1.5),
        ),
        errorBorder     : OutlineInputBorder(
          borderRadius : BorderRadius.circular(14),
          borderSide   : const BorderSide(color: Color(0xFFFF6B6B)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius : BorderRadius.circular(14),
          borderSide   : const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
        errorStyle      : const TextStyle(color: Color(0xFFFF6B6B), fontSize: 11),
        filled          : true,
        fillColor       : Colors.white.withOpacity(0.05),
        contentPadding  : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ── Gradient CTA button ───────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap  : onPressed,
      child  : Container(
        height    : 52,
        alignment : Alignment.center,
        decoration: BoxDecoration(
          gradient    : const LinearGradient(
            colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)],
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow   : [
            BoxShadow(
              color      : const Color(0xFFFF82A9).withOpacity(0.35),
              blurRadius : 18,
              spreadRadius: 0,
              offset     : const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color     : Colors.white,
            fontSize  : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Error / success banner ────────────────────────────────────────
class _Banner extends StatelessWidget {
  final String text;
  final bool   isError;
  const _Banner({required this.text, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding     : const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration  : BoxDecoration(
        color       : isError
            ? const Color(0xFFFF6B6B).withOpacity(0.12)
            : const Color(0xFF7EC8A0).withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border      : Border.all(
          color: isError
              ? const Color(0xFFFF6B6B).withOpacity(0.4)
              : const Color(0xFF7EC8A0).withOpacity(0.4),
        ),
      ),
      child: Row(children: [
        Icon(
          isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
          color: isError ? const Color(0xFFFF6B6B) : const Color(0xFF7EC8A0),
          size : 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color   : isError ? const Color(0xFFFF6B6B) : const Color(0xFF7EC8A0),
              fontSize: 12.5,
              height  : 1.4,
            ),
          ),
        ),
      ]),
    );
  }
}

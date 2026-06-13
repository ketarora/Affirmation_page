// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/screens/splash_screen.dart                              ║
// ║  Celestial Bloom — premium splash with starfield + affirmation║
// ╚══════════════════════════════════════════════════════════════╝

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ─── Adjust this import to match your affirmation data source ───
// import '../data/affirmations_data.dart';
import '../main.dart'; // import to resolve NishAffsLogo

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _starController;

  // Today's affirmation — replace with your actual data source
  static const _todayAffirmation =
      'I am divinely guided and protected every single day.';

  @override
  void initState() {
    super.initState();

    // Continuously animate stars
    _starController = AnimationController(
      vsync   : this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Navigate after 3.5 seconds
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    // Check auth state and route accordingly
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0022),
      body: Stack(fit: StackFit.expand, children: [

        // ── Layer 1: Deep space gradient ──────────────────────────
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin : Alignment.topCenter,
              end   : Alignment.bottomCenter,
              colors: [
                Color(0xFF0D0022),
                Color(0xFF1C0040),
                Color(0xFF0A001A),
              ],
              stops: [0.0, 0.42, 1.0],
            ),
          ),
        ),

        // ── Layer 2: Twinkling starfield ──────────────────────────
        AnimatedBuilder(
          animation: _starController,
          builder : (_, __) => CustomPaint(
            size   : Size.infinite,
            painter: _StarfieldPainter(_starController.value),
          ),
        ),

        // ── Layer 3: Central bloom glow ───────────────────────────
        Center(
          child: Container(
            width : 260,
            height: 260,
            decoration: BoxDecoration(
              shape : BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFFFF82A9).withOpacity(0.10),
                const Color(0xFFAC7BED).withOpacity(0.05),
                Colors.transparent,
              ]),
            ),
          ),
        ).animate(delay: 500.ms).fadeIn(duration: 1400.ms),

        // ── Layer 4: Content ──────────────────────────────────────
        SafeArea(
          child: Column(children: [
            const Spacer(flex: 3),

            // Brand logo — using the main app's premium logo component
            const NishAffsLogo(size: 120, showText: true)
                .animate()
                .fadeIn(duration: 900.ms, delay: 200.ms)
                .scale(
                  begin   : const Offset(0.70, 0.70),
                  end     : const Offset(1.00, 1.00),
                  curve   : Curves.easeOutBack,
                  duration: 950.ms,
                  delay   : 200.ms,
                ),

            const SizedBox(height: 12),

            // Tagline
            Text(
              'manifest  ·  heal  ·  glow',
              style: GoogleFonts.poppins(
                fontSize  : 11,
                fontWeight: FontWeight.w500,
                color     : const Color(0xFFFF82A9).withOpacity(0.70),
                letterSpacing: 3.6,
              ),
            )
                .animate(delay: 900.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.7, curve: Curves.easeOutCubic),

            const Spacer(flex: 2),

            // ── Divider + Affirmation block ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(children: [

                // Ornamental divider
                Row(children: [
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color : const Color(0xFFFF82A9).withOpacity(0.22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child  : Text(
                      '✦',
                      style: TextStyle(
                        color   : const Color(0xFFE6B861).withOpacity(0.55),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color : const Color(0xFFFF82A9).withOpacity(0.22),
                    ),
                  ),
                ]).animate(delay: 1300.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: 20),

                Text(
                  '"$_todayAffirmation"',
                  textAlign: TextAlign.center,
                  style    : GoogleFonts.lora(
                    fontSize     : 13.5,
                    color        : Colors.white.withOpacity(0.70),
                    fontStyle    : FontStyle.italic,
                    height       : 1.80,
                  ),
                ).animate(delay: 1500.ms).fadeIn(duration: 700.ms),

                const SizedBox(height: 10),

                Text(
                  "TODAY'S AFFIRMATION",
                  style: GoogleFonts.poppins(
                    fontSize     : 8.5,
                    fontWeight   : FontWeight.w600,
                    color        : const Color(0xFFE6B861).withOpacity(0.55),
                    letterSpacing: 2.6,
                  ),
                ).animate(delay: 1500.ms).fadeIn(duration: 500.ms),
              ]),
            ),

            const SizedBox(height: 52),

            // Breathing loading dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) =>
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width : 4.5,
                  height: 4.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF82A9).withOpacity(0.40),
                  ),
                )
                    .animate(
                      delay : Duration(milliseconds: 1900 + i * 180),
                      onPlay: (c) => c.repeat(reverse: true),
                    )
                    .scale(
                      begin   : const Offset(0.4, 0.4),
                      end     : const Offset(1.7, 1.7),
                      duration: 850.ms,
                      curve   : Curves.easeInOut,
                    )
                    .fadeIn(duration: 350.ms),
              ),
            ),

            const SizedBox(height: 48),
          ]),
        ),
      ]),
    );
  }
}

// ── Starfield painter ─────────────────────────────────────────────
class _StarfieldPainter extends CustomPainter {
  final double t;
  const _StarfieldPainter(this.t);

  // Stable seeded positions — computed only once
  static final _x  = List.generate(90, (i) => Random(i * 1337 + 7).nextDouble());
  static final _y  = List.generate(90, (i) => Random(i * 9871 + 3).nextDouble());
  static final _sz = List.generate(90, (i) => 0.5 + Random(i * 2741).nextDouble() * 1.9);
  static final _ph = List.generate(90, (i) => i * (pi * 2 / 90));

  static const _colors = [
    Colors.white, Colors.white, Colors.white, Colors.white,
    Color(0xFFFF82A9),
    Color(0xFFAC7BED),
    Color(0xFFE6B861),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 90; i++) {
      final opacity = (sin((t * pi * 2) + _ph[i]) * 0.35 + 0.55).clamp(0.06, 0.92);
      final x = _x[i] * size.width;
      final y = _y[i] * size.height;
      final r = _sz[i];
      final c = _colors[i % _colors.length];

      // Soft outer glow
      canvas.drawCircle(Offset(x, y), r * 3.0,
        Paint()
          ..color = c.withOpacity(opacity * 0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      // Sharp star core
      canvas.drawCircle(Offset(x, y), r,
        Paint()..color = c.withOpacity(opacity.toDouble()),
      );
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.t != t;
}

// ── Fallback logo if assets/images/image.png missing ─────────────
class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize      : MainAxisSize.min,
      mainAxisAlignment : MainAxisAlignment.center,
      children          : [
        Container(
          width : 48,
          height: 48,
          decoration: const BoxDecoration(
            shape   : BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)],
            ),
          ),
          child: Center(
            child: Text('N',
              style: GoogleFonts.pacifico(color: Colors.white, fontSize: 22)),
          ),
        ),
        const SizedBox(width: 12),
        ShaderMask(
          shaderCallback: (r) => const LinearGradient(
            colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)],
          ).createShader(r),
          child: Text('NishAffs',
            style: GoogleFonts.pacifico(color: Colors.white, fontSize: 30)),
        ),
      ],
    );
  }
}

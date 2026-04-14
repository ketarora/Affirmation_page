import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const NishAffsGodTierApp());
}

// ════════════════════════════════════════════════════════════════════
//  DESIGN TOKENS - PREMIUM VIBES
// ════════════════════════════════════════════════════════════════════
class C {
  static const bg        = Color(0xFFFCF4F8);
  static const pink1     = Color(0xFFFFF0F5);
  static const pink2     = Color(0xFFFFD1DF);
  static const pink3     = Color(0xFFFFB3CA);
  static const pinkTheme = Color(0xFFFF82A9);
  static const pinkDark  = Color(0xFFD64D7B);
  
  static const purpleLgt = Color(0xFFE9D5FF);
  static const purple    = Color(0xFFAC7BED);
  
  static const goldLgt   = Color(0xFFFFF4D1);
  static const gold      = Color(0xFFE6B861);
  
  static const textDark  = Color(0xFF382B33);
  static const textSub   = Color(0xFF8C7180);
  
  static const white     = Colors.white;

  static const gradPremium = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFFFB3CA), Color(0xFFAC7BED)],
  );
  static const gradSoft = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF0F5), Color(0xFFFCF4F8)],
  );
}

// ════════════════════════════════════════════════════════════════════
//  AESTHETIC ASSETS (Dynamic Image Pool)
// ════════════════════════════════════════════════════════════════════
class Assets {
  // A pool of aesthetic backgrounds from user uploads for crazy beautiful ui
  static const List<String> aestheticPhotos = [
    'photo_6264600317282422296_y.jpg', 'photo_6264600317282422297_y.jpg',
    'photo_6264600317282422298_y.jpg', 'photo_6264600317282422299_y.jpg',
    'photo_6264600317282422300_y.jpg', 'photo_6264600317282422301_y.jpg',
    'photo_6264600317282422302_y.jpg', 'photo_6264600317282422303_y.jpg',
    'photo_6264600317282422309_y.jpg', 'photo_6264600317282422310_y.jpg',
    'photo_6264600317282422311_y.jpg', 'photo_6264600317282422312_y.jpg',
    'photo_6264600317282422313_y.jpg', 'photo_6264600317282422314_y.jpg',
    'photo_6264600317282422315_y.jpg', 'photo_6264600317282422316_y.jpg',
    'photo_6264600317282422317_y.jpg', 'photo_6264600317282422318_y.jpg',
    'photo_6264600317282422319_y.jpg', 'photo_6264600317282422320_y.jpg',
    'photo_6264600317282422321_y.jpg', 'photo_6264600317282422322_y.jpg',
    'photo_6264600317282422323_y.jpg',
  ];

  static String randomAesthetic(int seedKey) {
    return 'assets/images/${aestheticPhotos[seedKey % aestheticPhotos.length]}';
  }

  static String get(String filename) => 'assets/images/$filename';
}

// ════════════════════════════════════════════════════════════════════
//  GLASSMORPHISM HELPER
// ════════════════════════════════════════════════════════════════════
class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets? padding;
  final double opacity;
  final Color tint;

  const GlassCard({
    super.key, required this.child, this.radius = 24, this.padding,
    this.opacity = 0.25, this.tint = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint.withOpacity(opacity),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  APP ROOT - Responsive Layout Clamper
// ════════════════════════════════════════════════════════════════════
class NishAffsGodTierApp extends StatelessWidget {
  const NishAffsGodTierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NishAffs Ultimate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: C.bg,
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: C.pinkTheme),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.black, // Dark behind the app on large screens
          body: Center(
            child: ClipRect(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480), // Mobile container size for laptop viewing
                decoration: const BoxDecoration(
                  color: C.bg,
                ),
                child: child!,
              ),
            ),
          ),
        );
      },
      home: const SplashGate(),
    );
  }
}

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});
  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _ready ? const ShellRoute() : const PremiumSplashView(),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  1. PREMIUM SPLASH SCREEN
// ════════════════════════════════════════════════════════════════════
class PremiumSplashView extends StatelessWidget {
  const PremiumSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(Assets.randomAesthetic(6), fit: BoxFit.cover)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 15.seconds),
          // Blur Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [C.pink3.withOpacity(0.4), C.purple.withOpacity(0.6), Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: Text('NishAffs',
                          style: GoogleFonts.pacifico(fontSize: 48, color: Colors.white, height: 1.1)),
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text('"You are entirely up to you." ✨',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500))
                    .animate(delay: 500.ms).fadeIn(),
                  const Spacer(),
                  const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      .animate(delay: 1.seconds).fadeIn(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  2. FULL SHELL NAVIGATION (Bottom Blur Bar)
// ════════════════════════════════════════════════════════════════════
class ShellRoute extends StatefulWidget {
  const ShellRoute({super.key});
  @override
  State<ShellRoute> createState() => _ShellRouteState();
}

class _ShellRouteState extends State<ShellRoute> {
  int _tab = 0;
  
  final _pages = const [
    HomeView(),
    DiscoverView(),
    StudioView(), // Videos + AI Generator
    CommunityView(), // Instagram Feed
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _tab, children: _pages),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: GlassCard(
            radius: 36, opacity: 0.7,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavBtn(0, _tab, Icons.home_filled, 'Home', () => setState(() => _tab = 0)),
                _NavBtn(1, _tab, Icons.auto_awesome, 'Discover', () => setState(() => _tab = 1)),
                _NavBtn(2, _tab, Icons.local_movies_rounded, 'Studio', () => setState(() => _tab = 2)),
                _NavBtn(3, _tab, Icons.favorite, 'Vibes', () => setState(() => _tab = 3)),
                _NavBtn(4, _tab, Icons.person_rounded, 'Me', () => setState(() => _tab = 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final int index, current;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavBtn(this.index, this.current, this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: active ? 16 : 8, vertical: 10),
        decoration: BoxDecoration(
          color: active ? C.pinkTheme.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? C.pinkDark : C.textSub, size: 24),
            if (active) ...[
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.pinkDark))
                .animate().fadeIn().slideX(begin: 0.1),
            ]
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  3. HOME DIRECTORY: DAILY RADIANCE
// ════════════════════════════════════════════════════════════════════
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Faint aesthetic background
        Positioned.fill(
          child: Image.asset(Assets.randomAesthetic(0), fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.85), colorBlendMode: BlendMode.lighten),
        ),
        SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Daily Radiance ✨', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)),
                              Text('Good Morning,', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: C.textDark, height: 1.1)),
                              Text('Beautiful Soul', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w500, color: C.textSub, height: 1.1)),
                            ],
                          ),
                          Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(Assets.randomAesthetic(4)), fit: BoxFit.cover),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
                      const SizedBox(height: 36),
                      
                      // Giant Glass Manifestation Card
                      SizedBox(
                        height: 480,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.asset(Assets.randomAesthetic(12), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)]),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 24, left: 24, right: 24,
                              child: GlassCard(
                                radius: 20, opacity: 0.15,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.wb_sunny_rounded, color: C.gold, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Daily Affirmation • April 15', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 30, left: 30, right: 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('"Everything I am seeking is already seeking me."',
                                      style: GoogleFonts.playfairDisplay(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      GlassCard(
                                        radius: 100, tint: C.pinkTheme, opacity: 0.8,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                        child: Text('Feel It ✨', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                      ),
                                      const Spacer(),
                                      GlassCard(
                                        radius: 100, opacity: 0.2,
                                        padding: const EdgeInsets.all(14),
                                        child: const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      GlassCard(
                                        radius: 100, opacity: 0.2,
                                        padding: const EdgeInsets.all(14),
                                        child: const Icon(Icons.share_outlined, color: Colors.white, size: 24),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),

                      const SizedBox(height: 48),

                      // Curated Playlists
                      Row(
                        children: [
                          Text('Curated for you', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: C.textDark)),
                          const Spacer(),
                          Text('See All', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)),
                        ],
                      ).animate(delay: 300.ms).fadeIn(),
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (ctx, i) => Container(
                            width: 150, margin: const EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.asset(Assets.randomAesthetic(i+2), fit: BoxFit.cover, width: double.infinity),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(['Inner Peace', 'Level Up', 'Healing Era', 'Lucky Girl', 'Sleep Vibes'][i],
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
                                Text(['5 Tracks', '10 Affirmations', 'Guided', 'Music', '8 Hours'][i],
                                    style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                              ],
                            ),
                          ).animate(delay: (400 + i*100).ms).fadeIn().slideY(begin: 0.1),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  4. DISCOVER / BOOKS DIRECTORY
// ════════════════════════════════════════════════════════════════════
class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: C.bg,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: C.bg,
              title: Text('Wisdom Library 📚', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: C.textDark)),
              centerTitle: false,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 16, mainAxisSpacing: 24,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20), topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                            image: DecorationImage(image: AssetImage(Assets.randomAesthetic(10+i)), fit: BoxFit.cover),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(5, 5))],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0, top: 0, bottom: 0,
                                child: Container(width: 8, color: Colors.black.withOpacity(0.2)),
                              ),
                              Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),
                              Center(child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text('Guide to\nMagic ${i+1}', textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('By Author ${i+1}', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                    ],
                  ).animate(delay: (100 * i).ms).fadeIn().slideY(begin: 0.1),
                  childCount: 10,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  5. STUDIO (AI Videos / Audio Generator)
// ════════════════════════════════════════════════════════════════════
class StudioView extends StatelessWidget {
  const StudioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.bg,
        image: DecorationImage(image: AssetImage('assets/images/flowers_top.png'), alignment: Alignment.topRight, opacity: 0.2),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Creator Studio 🎬', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: C.textDark)),
            Text('Turn your words into aesthetic manifestation videos.', style: GoogleFonts.poppins(fontSize: 14, color: C.textSub)),
            const SizedBox(height: 32),
            
            // Text Input Glass Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.1), blurRadius: 20)],
                border: Border.all(color: C.pink2, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Write Affirmation', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textDark)),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 4,
                    style: GoogleFonts.poppins(fontSize: 18, color: C.textDark, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "I am radiating high vibrations...",
                      hintStyle: GoogleFonts.poppins(color: C.textSub.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.1),
            
            const SizedBox(height: 24),
            Text('2. Choose Vibe', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textDark)),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (ctx, i) => Container(
                  width: 80, margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: AssetImage(Assets.randomAesthetic(i*3)), fit: BoxFit.cover),
                    border: Border.all(color: i == 0 ? C.pinkTheme : Colors.transparent, width: 3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: C.gradPremium,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: C.purple.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 6))],
                ),
                alignment: Alignment.center,
                child: Text('Generate Aesthetic Video ✨', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ).animate(delay: 300.ms).scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  6. COMMUNITY (Instagram Feed for Affirmations)
// ════════════════════════════════════════════════════════════════════
class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Vibe Check 🦋', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: C.textDark)),
            ),
            // Stories Row
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 10,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 65, height: 65,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: C.gradPremium),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(image: AssetImage(Assets.randomAesthetic(i+5)), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(i == 0 ? 'Your Vibe' : 'User $i', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.textDark)),
                    ],
                  ),
                ),
              ),
            ).animate().slideX(begin: 0.1),
            const Divider(color: C.pink1, height: 32, thickness: 2),
            // Feed
            ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (ctx, i) => _FeedPost(i),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedPost extends StatelessWidget {
  final int index;
  const _FeedPost(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage(Assets.randomAesthetic(index+2)), radius: 20),
                const SizedBox(width: 12),
                Text('aesthetic_soul _$index', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
                const Spacer(),
                const Icon(Icons.more_horiz, color: C.textSub),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Post Image Background with text overlay
          Container(
            height: 400, width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(Assets.randomAesthetic(index+8)), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Container(color: Colors.black.withOpacity(0.35)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      ['I am entirely capable of manifesting my dreams.', 'The universe is rigged in my favor.', 'Everything I desire is flowing towards me.', 'I trust the timing of my life.'][index % 4],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Icon(Icons.favorite_border, color: C.textDark, size: 28),
                const SizedBox(width: 16),
                const Icon(Icons.mode_comment_outlined, color: C.textDark, size: 28),
                const SizedBox(width: 16),
                const Icon(Icons.send_outlined, color: C.textDark, size: 28),
                const Spacer(),
                const Icon(Icons.bookmark_border, color: C.textDark, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('${100 + index*34} likes', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
          )
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  7. PROFILE (+ SONGS/SOUNDSCAPES & JOURNAL)
// ════════════════════════════════════════════════════════════════════
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.pink1,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage(Assets.randomAesthetic(15)), fit: BoxFit.cover),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Manifesting Queen 👑', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: C.textDark)),
                  Text('Joined April 2026', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 32),
            
            // Streaks Glass Panel
            GlassCard(
              radius: 30, opacity: 0.6,
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('21', 'Day Streak', Icons.local_fire_department, C.pinkDark),
                  Container(width: 1, height: 40, color: C.pink2),
                  _statItem('104', 'Affirmations', Icons.favorite, C.purple),
                  Container(width: 1, height: 40, color: C.pink2),
                  _statItem('12', 'Videos', Icons.play_arrow_rounded, C.textDark),
                ],
              ),
            ).animate(delay: 200.ms).fadeIn(),
            
            const SizedBox(height: 48),
            Text('Soundscapes 🎵', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: C.textDark)),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (ctx, i) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(Assets.randomAesthetic(i*5+1), width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(['432Hz Healing', 'Morning Abundance', 'Deep Sleep Delta', 'Study Focus Beta'][i],
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: C.textDark)),
                          Text('Altered States', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                        ],
                      ),
                    ),
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: C.gradPremium),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                    )
                  ],
                ),
              ).animate(delay: (300 + 100*i).ms).fadeIn().slideX(begin: -0.05),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String val, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(val, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: C.textDark)),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
      ],
    );
  }
}

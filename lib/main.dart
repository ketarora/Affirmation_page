import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════
// NishAffs 🌸 — Stella Glow Style Replica
// Kawaii • Flowers • Illustrated • Dreamy Pink
// ═══════════════════════════════════════════════════════

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const NishAffsApp());
}

// ═══ COLORS ═══
class C {
  static const bg = Color(0xFFFDE8F0);
  static const pink1 = Color(0xFFFFF0F5);
  static const pink2 = Color(0xFFFFE4EC);
  static const pink3 = Color(0xFFFFD0E0);
  static const pink4 = Color(0xFFFFB6D3);
  static const pink5 = Color(0xFFFF8EB8);
  static const pink6 = Color(0xFFE8729E);
  static const lavender = Color(0xFFF0E6FF);
  static const lilac = Color(0xFFE8D5F5);
  static const cream = Color(0xFFFFF8F0);
  static const peach = Color(0xFFFFF0E6);
  static const mint = Color(0xFFE8FFF0);
  static const sky = Color(0xFFE4F3FF);
  static const text = Color(0xFF4A3040);
  static const textSub = Color(0xFF8B7080);
  static const textMuted = Color(0xFFBBA8B3);
  static const cardBg = Color(0xFFFFF5F8);
  static const gold = Color(0xFFD4A574);
}

class NishAffsApp extends StatelessWidget {
  const NishAffsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NishAffs ✨',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: C.bg,
        fontFamily: GoogleFonts.quicksand().fontFamily,
      ),
      home: const SplashWrapper(),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SPLASH → then navigate to MainApp
// ═══════════════════════════════════════════════════════
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});
  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: _showSplash ? const SplashPage(key: ValueKey('splash')) : const MainApp(key: ValueKey('app')),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 1 — SPLASH / HOME (Stella Glow style)
// Flower borders, girl on cloud, affirmation
// ═══════════════════════════════════════════════════════
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _ctrl;

  final _affs = [
    '"I am a magnet for joy and abundance."',
    '"The universe conspires in my favor."',
    '"I radiate love and attract miracles."',
    '"Everything I desire is already mine."',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aff = _affs[Random().nextInt(_affs.length)];
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFE8D0F0), C.bg, C.pink2],
          ),
        ),
        child: Stack(
          children: [
            // ★ Falling petals
            ...List.generate(15, (i) => _FallingPetal(index: i)),

            // ★ Top flowers border
            Positioned(
              top: 0, left: 0, right: 0,
              child: Image.asset('assets/images/flowers_top.png',
                width: sw, fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => _FlowerBorderFallback()),
            ),

            // ★ Bottom flowers border
            Positioned(
              bottom: 60, left: 0, right: 0,
              child: Image.asset('assets/images/flowers_bottom.png',
                width: sw, height: 160, fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => const SizedBox()),
            ),

            // ★ Scattered decorations
            const Positioned(top: 120, left: 20, child: Text('⭐', style: TextStyle(fontSize: 14))),
            Positioned(top: 100, right: 40, child: Opacity(opacity: 0.5, child: Text('🌙', style: TextStyle(fontSize: 20)))),
            const Positioned(top: 200, left: 50, child: Text('✦', style: TextStyle(fontSize: 10, color: C.gold))),
            const Positioned(top: 180, right: 60, child: Text('✧', style: TextStyle(fontSize: 12, color: C.gold))),
            Positioned(top: 160, left: sw * 0.4, child: const Text('·  ·  ·', style: TextStyle(fontSize: 10, color: C.textMuted))),

            // ★ Center content
            Center(
              child: FadeTransition(
                opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    // Cloud-shaped app name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(color: Colors.white.withOpacity(0.8), blurRadius: 30, spreadRadius: 10),
                          BoxShadow(color: C.pink3.withOpacity(0.3), blurRadius: 20),
                        ],
                      ),
                      child: Text('NishAffs',
                        style: GoogleFonts.poppins(
                          fontSize: 38, fontWeight: FontWeight.w900,
                          color: C.text, letterSpacing: 1,
                          shadows: [Shadow(color: C.pink4, blurRadius: 8)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Girl on cloud illustration
                    Image.asset('assets/images/girl_cloud.png',
                      width: 200, height: 200, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [C.pink2, C.lavender]),
                        ),
                        child: const Center(child: Text('🌸', style: TextStyle(fontSize: 60))),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Affirmation quote
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(aff,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 18, fontWeight: FontWeight.w700,
                          color: C.text, height: 1.5, fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ★ Bottom label
            Positioned(
              bottom: 20, left: 0, right: 0,
              child: Center(
                child: Text('manifest with love 🦋',
                  style: GoogleFonts.quicksand(fontSize: 11, color: C.textMuted, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══ FALLING PETAL WIDGET ═══
class _FallingPetal extends StatefulWidget {
  final int index;
  const _FallingPetal({required this.index});
  @override
  State<_FallingPetal> createState() => _FallingPetalState();
}

class _FallingPetalState extends State<_FallingPetal> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late double _startX, _startY, _endY, _drift;

  @override
  void initState() {
    super.initState();
    final r = Random(widget.index);
    _startX = r.nextDouble();
    _startY = -r.nextDouble() * 0.3;
    _endY = 1.0 + r.nextDouble() * 0.2;
    _drift = (r.nextDouble() - 0.5) * 80;
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000 + r.nextInt(4000)),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        final y = _startY + (_endY - _startY) * t;
        final x = _startX * sz.width + sin(t * 3.14 * 2) * _drift;
        return Positioned(
          left: x, top: y * sz.height,
          child: Opacity(
            opacity: (1 - t).clamp(0.0, 0.6),
            child: Transform.rotate(
              angle: t * 3.14,
              child: const Text('🌸', style: TextStyle(fontSize: 14)),
            ),
          ),
        );
      },
    );
  }
}

// Fallback flower border
class _FlowerBorderFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Positioned(top: 10, left: 10, child: Text('🌸', style: TextStyle(fontSize: 40))),
          Positioned(top: 0, left: 60, child: Text('🌺', style: TextStyle(fontSize: 30))),
          Positioned(top: 20, right: 10, child: Text('🌷', style: TextStyle(fontSize: 36))),
          Positioned(top: 5, right: 60, child: Text('🌸', style: TextStyle(fontSize: 28))),
          Positioned(top: 40, left: 30, child: Text('⭐', style: TextStyle(fontSize: 12))),
          Positioned(top: 50, right: 40, child: Text('🌙', style: TextStyle(fontSize: 16))),
          Positioned(top: 30, left: 120, child: Text('✨', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// MAIN APP with Bottom Nav
// ═══════════════════════════════════════════════════════
class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _idx = 0;
  final _pages = const [
    HomePage(),         // Screen 2 — Daily Radiance / Create
    GuidedWisdomPage(), // Screen 3 — Books
    JournalPage(),      // Journal
    CommunityPage(),    // Community/Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: C.pink3.withOpacity(0.5), width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _nav(0, '🏠', 'Home'),
                _nav(1, '📚', 'Library'),
                _nav(2, '📓', 'Journal'),
                _nav(3, '💖', 'Community'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nav(int i, String icon, String label) {
    final active = _idx == i;
    return GestureDetector(
      onTap: () => setState(() => _idx = i),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: active ? 24 : 20)),
            const SizedBox(height: 3),
            Text(label, style: GoogleFonts.quicksand(
              fontSize: 10, fontWeight: FontWeight.w700,
              color: active ? C.pink6 : C.textMuted)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 2 — HOME PAGE (Daily Radiance / Create)
// Top icons, create affirmation with ornate frame,
// preloaded radiance cards with illustrated characters
// ═══════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageCtrl = PageController();

  final _dailyAffs = [
    "The universe is always conspiring in your favor. Trust the timing. ✨",
    "You are worthy of every beautiful thing life offers. 💖",
    "What you seek is also seeking you. Keep believing. 🌸",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.bg,
      child: Stack(
        children: [
          // Falling petals
          ...List.generate(8, (i) => _FallingPetal(index: i + 20)),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                // ★ Top bar with icon and title
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: C.pink4, width: 1.5),
                      ),
                      child: const Center(child: Text('👤', style: TextStyle(fontSize: 18))),
                    ),
                    const Spacer(),
                    Text('Daily Radiance',
                      style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.w800, color: C.text)),
                    const Spacer(),
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: C.pink4, width: 1.5),
                      ),
                      child: const Center(child: Text('🛒', style: TextStyle(fontSize: 16))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ★ Top category icons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _topIcon('🏠', 'Home', true),
                    _topIcon('🌅', 'Daily\nGlow', false),
                    _topIcon('🧘', 'Guided\nSessions', false),
                    _topIcon('🛍️', 'Shop', false),
                  ],
                ),
                const SizedBox(height: 24),

                // ★ CREATE YOUR AFFIRMATION — ornate frame
                GestureDetector(
                  onTap: () => _showCreate(context),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ornate frame background
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/images/frame.png',
                          width: double.infinity, height: 200, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: C.pink4, width: 2),
                              color: C.cream,
                            ),
                          ),
                        ),
                      ),
                      // Text overlay
                      Column(
                        children: [
                          Text('Create Your',
                            style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w600,
                              color: C.text, fontStyle: FontStyle.italic)),
                          Text('Affirmation',
                            style: GoogleFonts.poppins(
                              fontSize: 28, fontWeight: FontWeight.w800,
                              color: C.text, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      // Quill decoration
                      Positioned(
                        right: 30, bottom: 20,
                        child: Image.asset('assets/images/quill.png',
                          width: 60, height: 60, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Text('✒️', style: TextStyle(fontSize: 28))),
                      ),
                    ],
                  ),
                ),

                // Dot indicator
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(true), const SizedBox(width: 6),
                    _dot(false), const SizedBox(width: 6),
                    _dot(false),
                  ],
                ),
                const SizedBox(height: 28),

                // ★ PRELOADED RADIANCE
                Center(
                  child: Column(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Preloaded Radiance',
                        style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700, color: C.text)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ★ Illustrated category cards
                SizedBox(
                  height: 210,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _vibeCard('Self-Love', 'assets/images/girl_mirror.png', C.pink2, C.lavender),
                      const SizedBox(width: 14),
                      _vibeCard('Abundance', 'assets/images/abundance.png', C.mint, C.peach),
                      const SizedBox(width: 14),
                      _vibeCard('Confidence', 'assets/images/girl_confidence.png', C.lavender, C.sky),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ★ Vine/sparkle decoration at bottom
                Center(
                  child: Column(
                    children: [
                      Text('·  ✧  ·  ✦  ·  ✧  ·', style: TextStyle(color: C.textMuted, fontSize: 12)),
                      const SizedBox(height: 8),
                      Image.asset('assets/images/flowers_bottom.png',
                        height: 80, fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text('🌸 🌷 🌺', style: TextStyle(fontSize: 20))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topIcon(String emoji, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? C.pink3 : Colors.white,
            border: Border.all(color: C.pink3, width: 1.5),
            boxShadow: active ? [BoxShadow(color: C.pink4.withOpacity(0.3), blurRadius: 8)] : null,
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(fontSize: 10, fontWeight: FontWeight.w600,
            color: active ? C.pink6 : C.textSub)),
      ],
    );
  }

  Widget _dot(bool active) => Container(
    width: active ? 20 : 8, height: 8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: active ? C.pink5 : C.pink3,
    ),
  );

  Widget _vibeCard(String title, String imgPath, Color c1, Color c2) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c1, c2]),
        border: Border.all(color: C.pink3, width: 1.5),
        boxShadow: [BoxShadow(color: C.pink3.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
              child: Image.asset(imgPath, fit: BoxFit.cover, width: double.infinity,
                errorBuilder: (_, __, ___) => Center(
                  child: Text('🌸', style: TextStyle(fontSize: 40)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(title, style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w700, color: C.text)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: C.pink4),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text('Choose a Vibe', style: GoogleFonts.quicksand(
                        fontSize: 11, fontWeight: FontWeight.w600, color: C.text)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreate(BuildContext context) {
    final textCtrl = TextEditingController();
    String cat = 'love';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(
                color: C.pink3, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('Create Affirmation 🌸', style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w800, color: C.text)),
              const SizedBox(height: 6),
              Text('Write something beautiful ✨', style: GoogleFonts.quicksand(
                fontSize: 13, color: C.textSub)),
              const SizedBox(height: 20),
              TextField(
                controller: textCtrl, maxLines: 3,
                style: GoogleFonts.quicksand(fontSize: 15, color: C.text),
                decoration: InputDecoration(
                  hintText: 'I am worthy of all the love...',
                  hintStyle: GoogleFonts.quicksand(color: C.textMuted),
                  filled: true, fillColor: C.pink1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: C.pink3)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: C.pink3)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: C.pink5, width: 2)),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: C.pink1, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.pink3)),
                child: DropdownButton<String>(
                  value: cat, isExpanded: true, underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'love', child: Text('💖 Self Love')),
                    DropdownMenuItem(value: 'career', child: Text('💼 Career')),
                    DropdownMenuItem(value: 'health', child: Text('🌿 Health')),
                    DropdownMenuItem(value: 'wealth', child: Text('🌟 Wealth')),
                    DropdownMenuItem(value: 'gratitude', child: Text('🙏 Gratitude')),
                  ],
                  onChanged: (v) => setS(() => cat = v!),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (textCtrl.text.trim().isEmpty) return;
                    final prefs = await SharedPreferences.getInstance();
                    final list = jsonDecode(prefs.getString('custom_affs') ?? '[]') as List;
                    list.insert(0, {'text': textCtrl.text.trim(), 'cat': cat, 'id': DateTime.now().millisecondsSinceEpoch});
                    await prefs.setString('custom_affs', jsonEncode(list));
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.pink5, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    elevation: 4, shadowColor: C.pink4),
                  child: Text('Save 💖', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 3 — GUIDED WISDOM (Books)
// Tilted card carousel, reading progress, illustrations
// ═══════════════════════════════════════════════════════
class GuidedWisdomPage extends StatelessWidget {
  const GuidedWisdomPage({super.key});

  static final _books = [
    {'title': 'Manifesting\nMagic', 'emoji': '🌸', 'c1': C.lavender, 'c2': C.pink2, 'img': 'book1.png'},
    {'title': 'Inner\nPeace Guide', 'emoji': '🪷', 'c1': C.pink1, 'c2': C.cream, 'img': 'book2.png'},
    {'title': 'Law of\nAttraction\nfor Soul', 'emoji': '🦋', 'c1': C.peach, 'c2': C.lavender, 'img': 'selflove.png'},
    {'title': 'Abundance\nMindset', 'emoji': '🌟', 'c1': C.mint, 'c2': C.sky, 'img': 'abundance.png'},
    {'title': 'Self-Love\nJourney', 'emoji': '💖', 'c1': C.pink2, 'c2': C.lilac, 'img': 'girl_mirror.png'},
  ];

  static final _bookPages = [
    [
      {'title': 'What is Manifestation?', 'body': 'Manifestation is aligning your energy, thoughts, and beliefs with what you truly desire.\n\nThe Law of Attraction states that like attracts like. Focus on positive thoughts, attract positive experiences.\n\nThis isn\'t wishful thinking — it\'s becoming an energetic match for your desires. 🌸'},
      {'title': 'The Power of Belief', 'body': 'Your beliefs shape your reality. Replace "I\'m not good enough" with "I am more than enough."\n\nThis simple shift changes everything. ✨'},
      {'title': 'Visualization', 'body': 'See your dream life in vivid detail. Your brain doesn\'t know the difference between imagination and reality.\n\nPractice 5-10 minutes daily. See it. Feel it. Become it. 🌈'},
      {'title': 'Gratitude', 'body': 'Gratitude is the highest vibration. Start a journal. Write 3 things you\'re grateful for every morning. 🙏'},
    ],
    [
      {'title': 'Finding Inner Peace', 'body': 'Inner peace begins with accepting where you are right now.\n\nStop fighting the present moment. Embrace it fully.\n\nPeace isn\'t the absence of chaos — it\'s the presence of calm within it. 🪷'},
      {'title': 'Meditation Basics', 'body': 'Sit comfortably. Close your eyes. Focus on your breath.\n\nWhen thoughts come, observe them like clouds passing. Don\'t judge. Just breathe.\n\n5 minutes daily transforms your mind. 🧘‍♀️'},
      {'title': 'Letting Go', 'body': 'What no longer serves you deserves to be released.\n\nForgive. Release. Create space for new blessings. 🦋'},
    ],
    [
      {'title': 'The Law Explained', 'body': 'Like attracts like. Your dominant thoughts become your reality.\n\nThink abundance → attract abundance.\nThink love → attract love.\n\nYou are always manifesting. Choose wisely. ✨'},
      {'title': 'Raising Your Vibration', 'body': 'High vibe activities:\n🎵 Listen to uplifting music\n🌿 Spend time in nature\n🙏 Practice gratitude\n💃 Move your body\n📖 Read inspiring books\n\nYour vibration is your invitation to the universe.'},
    ],
    [
      {'title': 'Scarcity vs Abundance', 'body': 'Most were raised with scarcity: "There\'s not enough."\n\nAbundance mindset: "There\'s more than enough for everyone." 🌟'},
      {'title': 'Money Affirmations', 'body': 'Money is energy. Repeat daily:\n• "Money flows to me easily."\n• "I am worthy of abundance."\n\nFeel the truth. Money loves gratitude. 💫'},
    ],
    [
      {'title': 'Why Self-Love?', 'body': 'Self-love is the foundation of every manifestation.\n\nWhen you love yourself, you set the standard for how the universe treats you. 💖'},
      {'title': 'Mirror Work', 'body': 'Stand in front of a mirror. Say: "I love you. I really love you."\n\nKeep doing it. Day after day. It\'s transformative. 🪞'},
      {'title': 'Daily Ritual', 'body': 'Every morning:\n1. 3 deep breaths 🌸\n2. Hand on heart\n3. Say: "I am enough."\n4. Smile\n\nThis 60-second ritual rewires your brain.'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.bg,
      child: Stack(
        children: [
          // Petals
          ...List.generate(6, (i) => _FallingPetal(index: i + 40)),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: const Text('‹', style: TextStyle(fontSize: 32, color: C.textSub)),
                      ),
                      const Spacer(),
                      Icon(Icons.menu, color: C.textSub, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Center(
                  child: Text('Guided Wisdom',
                    style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w800,
                      color: C.text, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 24),

                // ★ Tilted book carousel
                SizedBox(
                  height: 260,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.55),
                    itemCount: _books.length,
                    itemBuilder: (ctx, i) {
                      final b = _books[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ReaderScreen(
                            title: (b['title'] as String).replaceAll('\n', ' '),
                            pages: _bookPages[i],
                          ),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                          child: Transform.rotate(
                            angle: i.isEven ? -0.03 : 0.03,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                                  colors: [b['c1'] as Color, b['c2'] as Color]),
                                border: Border.all(color: C.pink4, width: 1.5),
                                boxShadow: [BoxShadow(color: C.pink4.withOpacity(0.3), blurRadius: 16, offset: const Offset(4, 8))],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset('assets/images/${b['img']}',
                                      width: 80, height: 80, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Text(b['emoji'] as String, style: const TextStyle(fontSize: 40))),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(b['title'] as String,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w700,
                                      color: C.text, height: 1.3)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Arrows
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chevron_left, color: C.pink5, size: 28),
                    const SizedBox(width: 20),
                    Icon(Icons.chevron_right, color: C.pink5, size: 28),
                  ],
                ),
                const SizedBox(height: 24),

                // Reading progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: C.pink3),
                    ),
                    child: Column(
                      children: [
                        Text('Reading progress', style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600, color: C.text)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(i < 3 ? '⭐' : '☆',
                                style: TextStyle(fontSize: 20, color: i < 3 ? C.gold : C.textMuted)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor: C.pink2,
                            valueColor: AlwaysStoppedAnimation(C.pink5),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('3 of 5 books explored', style: GoogleFonts.quicksand(
                          fontSize: 12, color: C.textMuted, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Illustration at bottom
                Center(
                  child: Image.asset('assets/images/girl_confidence.png',
                    width: 100, height: 100, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text('🧘‍♀️', style: TextStyle(fontSize: 48))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// READER (Kindle swipe)
// ═══════════════════════════════════════════════════════
class ReaderScreen extends StatefulWidget {
  final String title;
  final List<Map<String, String>> pages;
  const ReaderScreen({super.key, required this.title, required this.pages});
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  int _cur = 0;
  late PageController _ctrl;

  @override
  void initState() { super.initState(); _ctrl = PageController(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.cream,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0, centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18, color: C.pink6), onPressed: () => Navigator.pop(context)),
        title: Text(widget.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.text)),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${_cur + 1}/${widget.pages.length}', style: GoogleFonts.quicksand(fontSize: 12, fontWeight: FontWeight.w600, color: C.textMuted)))),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _ctrl, itemCount: widget.pages.length,
              onPageChanged: (i) => setState(() => _cur = i),
              itemBuilder: (_, i) {
                final p = widget.pages[i];
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['title']!, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: C.pink6)),
                      const SizedBox(height: 20),
                      Text(p['body']!, style: GoogleFonts.quicksand(fontSize: 16, color: C.text, height: 1.9)),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: C.pink1,
            child: Center(child: Text('← swipe to turn pages →', style: GoogleFonts.quicksand(fontSize: 11, fontWeight: FontWeight.w600, color: C.textMuted))),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// JOURNAL PAGE (placeholder)
// ═══════════════════════════════════════════════════════
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});
  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<dynamic> _entries = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { _entries = jsonDecode(prefs.getString('custom_affs') ?? '[]') as List; });
  }

  Future<void> _delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    _entries.removeWhere((e) => e['id'] == id);
    await prefs.setString('custom_affs', jsonEncode(_entries));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text('My Journal 📓', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: C.text)),
            const SizedBox(height: 4),
            Text('Your personal affirmation collection ✨', style: GoogleFonts.quicksand(fontSize: 13, color: C.textSub)),
            const SizedBox(height: 24),
            if (_entries.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      const Text('🌸', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 16),
                      Text('No entries yet!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: C.textSub)),
                      const SizedBox(height: 8),
                      Text('Create affirmations from Home ✨', style: GoogleFonts.quicksand(fontSize: 13, color: C.textMuted)),
                    ],
                  ),
                ),
              )
            else
              ..._entries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.pink2, width: 1.5),
                  boxShadow: [BoxShadow(color: C.pink3.withOpacity(0.15), blurRadius: 12)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(e['text'] ?? '', style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w600, color: C.text, height: 1.6)),
                    ),
                    GestureDetector(
                      onTap: () => _delete(e['id']),
                      child: Container(
                        width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: C.pink2),
                        child: const Center(child: Text('✕', style: TextStyle(fontSize: 12, color: C.pink6))),
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// COMMUNITY / PROFILE PAGE
// ═══════════════════════════════════════════════════════
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text('Community 💖', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: C.text)),
            const SizedBox(height: 4),
            Text('Your manifestation journey', style: GoogleFonts.quicksand(fontSize: 13, color: C.textSub)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(colors: [C.pink2, C.lavender]),
                boxShadow: [BoxShadow(color: C.pink3.withOpacity(0.3), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                    child: const Center(child: Text('🌸', style: TextStyle(fontSize: 36))),
                  ),
                  const SizedBox(height: 14),
                  Text('NishAffs User', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: C.text)),
                  const SizedBox(height: 4),
                  Text('Manifesting since 2026 ✨', style: GoogleFonts.quicksand(fontSize: 12, color: C.textSub)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _stat('0', 'Affirmations'),
                const SizedBox(width: 12),
                _stat('5', 'Books'),
                const SizedBox(width: 12),
                _stat('∞', 'Potential'),
              ],
            ),
            const SizedBox(height: 28),
            Text('Settings 🔧', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.text)),
            const SizedBox(height: 12),
            _setting('🔔', 'Daily Reminders'),
            _setting('🎨', 'Theme', val: 'Pink 🌸'),
            _setting('📤', 'Share App'),
            _setting('💌', 'Feedback'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String n, String l) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.pink2, width: 1.5),
      ),
      child: Column(
        children: [
          Text(n, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: C.pink6)),
          const SizedBox(height: 4),
          Text(l, textAlign: TextAlign.center, style: GoogleFonts.quicksand(fontSize: 10, color: C.textMuted)),
        ],
      ),
    ),
  );

  Widget _setting(String emoji, String label, {String? val}) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.w600, color: C.text))),
        if (val != null) Text(val, style: GoogleFonts.quicksand(fontSize: 13, color: C.textMuted)),
      ],
    ),
  );
}

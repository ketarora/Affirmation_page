// ════════════════════════════════════════════════════════════════════
//  NishAffs ✨ — GOD TIER v4.0 — FULLY WORKING
//  Login • Kindle Books • Stories • Live Likes • Left Drawer
//  Soundscapes • Studio Posts • Daily Affirmations • Local Backend
// ════════════════════════════════════════════════════════════════════
// FIREBASE SWAP: Replace StorageService methods with Firestore.
//   Auth:  FirebaseAuth.instance.signInAnonymously()
//   Posts: FirebaseFirestore.instance.collection('posts')
// ════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════ ENTRY POINT ════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await AppState.instance.init();
  runApp(const NishAffsApp());
}

// ════════════════════════════════════════════════════════════════════
//  DESIGN TOKENS
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
  static const gold      = Color(0xFFE6B861);
  static const goldLgt   = Color(0xFFFFF4D1); 
  static const mint      = Color(0xFFD1FFE0); 
  static const textDark  = Color(0xFF382B33);
  static const textSub   = Color(0xFF8C7180);
  static const white     = Colors.white;
  static const book      = Color(0xFFFAF6F0); // warm cream for book pages

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
//  ASSETS HELPER
// ════════════════════════════════════════════════════════════════════
class A {
  static const imgs = [
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
    'abundance.png', 'book1.png', 'book2.png', 'flowers_bottom.png',
    'flowers_top.png', 'frame.png', 'girl_cloud.png', 'girl_confidence.png',
    'girl_mirror.png', 'quill.png', 'selflove.png', 'splash.png'
  ];
  static String get(int i) => 'assets/images/${imgs[i % imgs.length]}';
  static const fallbacks = ['✨','🌸','🧸','💗','💌','🦋','🌷','🎀','☕','☁️','🍒','🍊','🧋','🌼','💬','⭐','🦄','🌈','🍳'];
  static String fb(int i) => fallbacks[i % fallbacks.length];
}

Widget _img(int i, {double? w, double? h, BoxFit fit = BoxFit.contain}) =>
    Image.asset(A.get(i), width: w, height: h, fit: fit,
        errorBuilder: (_, __, ___) => SizedBox(width: w, height: h,
            child: Center(child: Text(A.fb(i), style: TextStyle(fontSize: (w ?? 32) * 0.55)))));

// ════════════════════════════════════════════════════════════════════
//  DATA — BOOKS
// ════════════════════════════════════════════════════════════════════
class BookPage { final String chapter, body; final String? title;
  const BookPage(this.chapter, this.body, {this.title}); }

class Book { final String title, author, emoji, tag; final List<Color> grad; final List<BookPage> pages;
  const Book({required this.title, required this.author, required this.emoji, required this.tag, required this.grad, required this.pages}); }

const _booksData = [
  Book(title: 'Manifesting Magic', author: 'Luna Starr', emoji: '✨', tag: 'LOA',
    grad: [Color(0xFFE9D5FF), Color(0xFFFFD1DF)],
    pages: [
      BookPage('Chapter 1', 'You are not a drop in the ocean. You are the entire ocean in a drop.\n\nManifestation begins with a single, radical act: believing you already have what you desire.\n\nThe Law of Attraction is not wishful thinking. It is the universe responding to the energetic frequency you broadcast 24 hours a day, 7 days a week — whether you are aware of it or not.\n\nWhen you worry, you attract more to worry about. When you love, you attract more love. This is physics, not poetry.', title: 'You Are The Universe'),
      BookPage('Chapter 1', 'Your subconscious mind does not know the difference between imagination and reality.\n\nWhen you vividly picture your dream life — your apartment, your relationship, your bank account — your brain begins wiring new neural pathways as if it were already true.\n\nThis is the science behind visualization. Do it every morning for 5 minutes. Be specific. Feel the emotions. Use all five senses.', title: 'The Visualization Secret'),
      BookPage('Chapter 2', 'Replace every "I want" with "I have."\n\nLanguage is a spell. Every word you speak is a command to the universe.\n\n"I want love" keeps you in a state of wanting.\n"I am loved" shifts you into a state of having.\n\nSpend 21 days replacing your wanting language with having language. Watch your reality begin to morph.', title: 'Words Are Spells'),
      BookPage('Chapter 2', 'Gratitude is the highest vibrational frequency a human can emit.\n\nEvery morning, before you look at your phone, write 5 things you are genuinely grateful for. Feel the warmth in your chest as you write each one.\n\nThis practice rewires your brain for abundance within 30 days. Neuroscience confirms it. The universe responds to it. Your life will prove it.', title: 'The Gratitude Portal'),
    ],
  ),
  Book(title: 'Inner Peace Guide', author: 'Serenity Bell', emoji: '🪷', tag: 'Mindfulness',
    grad: [Color(0xFFFFD1DF), Color(0xFFFFF0F5)],
    pages: [
      BookPage('Chapter 1', 'Peace is not the absence of chaos. Peace is finding calm in the centre of the storm.\n\nMost people wait for their external world to calm down before they allow themselves to feel at peace. This is backwards.\n\nYou must cultivate inner stillness first. Then — and only then — will your outer world begin to reflect that stillness back to you.', title: 'The Stillness Within'),
      BookPage('Chapter 1', 'The simplest meditation practice:\n\nSit in a comfortable position. Close your eyes. Take three deep breaths — in for 4 counts, hold for 4, out for 8.\n\nNow observe your thoughts like clouds passing across a clear blue sky. You are not the clouds. You are the sky.\n\nJust 5 minutes of this practice daily will transform your nervous system within 8 weeks.', title: 'Your 5-Minute Practice'),
      BookPage('Chapter 2', 'The practice of letting go is the highest form of spiritual maturity.\n\nEvery resentment you carry is a weight around your own neck. Every grudge you hold imprisons you more than the person you resent.\n\nForgiveness is not saying what happened was okay. It is saying: I refuse to carry this pain any further. I release it with love.', title: 'The Art of Letting Go'),
    ],
  ),
  Book(title: 'Law of Attraction for the Soul', author: 'Cosmos Ray', emoji: '🌌', tag: 'Spiritual',
    grad: [Color(0xFFAC7BED), Color(0xFFE9D5FF)],
    pages: [
      BookPage('Chapter 1', 'Like attracts like.\n\nThis is the most powerful and most misunderstood law in existence.\n\nYour dominant thoughts, feelings, and beliefs create a magnetic field around you. This field constantly communicates with the quantum field of all possibility.\n\nYou are always manifesting — the question is whether you are doing it consciously or unconsciously. This book teaches you to become a conscious creator.', title: 'The Magnetic Law'),
      BookPage('Chapter 2', 'Raise your vibration by:\n\n🎵 Listening to music that makes you feel expansive\n🌿 Spending time in nature\n🙏 Practicing daily gratitude\n💃 Moving your body with joy\n📖 Reading books that uplift\n🧘 Meditating for clarity\n\nYour vibration is your invitation to the universe. High vibration attracts high vibration experiences, people, and opportunities.', title: 'Raising Your Frequency'),
      BookPage('Chapter 3', 'The 55×5 Method:\n\nWrite your core desire as an affirmation, exactly 55 times, for 5 consecutive days.\n\nThis intensive practice overwhelms your subconscious mind and plants the seed of your desire so deeply that it must manifest.\n\nExample: "I am a magnet for financial abundance and beautiful opportunities."\n\nWrite it 55 times. Feel it. Believe it. Do not skip a day.', title: 'The 55×5 Method'),
    ],
  ),
  Book(title: 'Sacred Self-Love', author: 'Rose Quartz', emoji: '💗', tag: 'Self-Love',
    grad: [Color(0xFFFFB3CA), Color(0xFFFFD1DF)],
    pages: [
      BookPage('Chapter 1', 'You cannot pour from an empty cup.\n\nEvery relationship you have with another person is a direct reflection of the relationship you have with yourself.\n\nThe love you desperately seek from others is love you have not yet given to yourself. This is not a judgment — it is an invitation. An invitation to turn inward and begin the most important love affair of your life.', title: 'The Most Important Relationship'),
      BookPage('Chapter 1', 'Mirror Work:\n\nStand before a mirror. Look into your own eyes — not at your hair, not at your skin, not at any perceived flaw. Into your EYES.\n\nSay aloud: "I love you. I really, truly love you. You are enough."\n\nThe first time, you may laugh. You may cry. You may feel nothing. Do it anyway.\n\nDo it every morning for 30 days. Something profound will shift.', title: 'The Mirror Practice'),
      BookPage('Chapter 2', 'Boundaries are not walls. They are the fence around your garden.\n\nSaying no to what drains you is saying yes to what fills you.\n\nEvery time you honor your boundaries, you send a message to your subconscious: "I am worth protecting." Your self-worth grows. Your magnetism increases. And the people who are truly meant for you — they respect your fences.', title: 'The Sacred Boundary'),
    ],
  ),
];

// ════════════════════════════════════════════════════════════════════
//  DATA — DAILY AFFIRMATIONS (one per day, rotates)
// ════════════════════════════════════════════════════════════════════
const _dailyAffirmations = [
  'Everything I am seeking is already seeking me.',
  'I am a magnet for love, abundance, and miracles.',
  'The universe is always conspiring in my favour.',
  'I radiate beauty, confidence, and grace.',
  'My life is a beautiful unfolding of magic.',
  'I attract only the highest and best in all areas of my life.',
  'I am worthy of everything wonderful in this world.',
  'Today I choose joy, peace, and abundance.',
  'I trust the timing of my beautiful life.',
  'I am enough. I have enough. I do enough.',
  'Love flows to me easily and effortlessly.',
  'I am becoming the best version of myself.',
  'My vibe is my superpower.',
  'I am in the perfect place at the perfect time.',
  'Abundance is my natural state of being.',
  'I am deeply loved and deeply loving.',
  'Every day I grow more magnetic and more radiant.',
  'I create my reality with my thoughts and feelings.',
  'The best is always yet to come for me.',
  'I am a living, breathing miracle.',
  'My heart is open to receiving infinite blessings.',
  'I am the author of my own story.',
  'I release what no longer serves me with love.',
  'I am aligned with the energy of success.',
  'My dreams are valid and within my reach.',
  'I choose to see the beauty in everything.',
  'I am healing, growing, and glowing.',
  'The universe knows my heart and delivers accordingly.',
  'I am grateful for all that I am and all that I have.',
  'Today is a gift and I receive it with open arms.',
  'My potential is limitless and my future is bright.',
];

String get _todayAffirmation {
  final d = DateTime.now();
  final idx = (d.year * 365 + d.month * 31 + d.day) % _dailyAffirmations.length;
  return _dailyAffirmations[idx];
}

// ════════════════════════════════════════════════════════════════════
//  BACKEND — APPSTATE (Replace with Firebase for production)
// ════════════════════════════════════════════════════════════════════
class AppState {
  static final AppState instance = AppState._();
  AppState._();

  final ValueNotifier<Map<String, dynamic>?> user = ValueNotifier(null);
  final ValueNotifier<Set<String>> liked   = ValueNotifier({});
  final ValueNotifier<Set<String>> saved   = ValueNotifier({});
  final ValueNotifier<List<Map<String, dynamic>>> posts = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> customAffs = ValueNotifier([]);

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    final u = p.getString('na_user');
    if (u != null) user.value = jsonDecode(u) as Map<String, dynamic>;

    liked.value  = Set.from(p.getStringList('na_liked') ?? []);
    saved.value  = Set.from(p.getStringList('na_saved') ?? []);

    final affs = p.getString('na_custom_affs');
    if (affs != null) customAffs.value = List<Map<String, dynamic>>.from(jsonDecode(affs));

    final ps = p.getString('na_community_posts');
    if (ps != null) {
      posts.value = List<Map<String, dynamic>>.from(jsonDecode(ps));
    } else {
      // Seed default community posts
      posts.value = _defaultPosts();
      _savePosts();
    }
  }

  Future<void> login(String name, String email) async {
    final u = {'name': name, 'email': email, 'avatar': (name.isNotEmpty ? name[0] : 'N').toUpperCase(), 'joined': DateTime.now().toIso8601String()};
    user.value = u;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_user', jsonEncode(u));
  }

  Future<void> logout() async {
    user.value = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('na_user');
  }

  Future<void> toggleLike(String id) async {
    final s = Set<String>.from(liked.value);
    s.contains(id) ? s.remove(id) : s.add(id);
    liked.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_liked', s.toList());
    // bump like count in posts
    final ps = List<Map<String,dynamic>>.from(posts.value);
    final idx = ps.indexWhere((e) => e['id'] == id);
    if (idx != -1) {
      ps[idx] = {...ps[idx], 'likes': (ps[idx]['likes'] as int) + (s.contains(id) ? 1 : -1)};
      posts.value = ps;
      _savePosts();
    }
  }

  Future<void> toggleSave(String id) async {
    final s = Set<String>.from(saved.value);
    s.contains(id) ? s.remove(id) : s.add(id);
    saved.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_saved', s.toList());
  }

  Future<void> addPost(Map<String, dynamic> post) async {
    final ps = [post, ...posts.value];
    posts.value = ps;
    _savePosts();
  }

  Future<void> addComment(String postId, String comment) async {
    final ps = List<Map<String,dynamic>>.from(posts.value);
    final idx = ps.indexWhere((e) => e['id'] == postId);
    if (idx != -1) {
      final comments = List<String>.from(ps[idx]['comments'] as List? ?? []);
      comments.add(comment);
      ps[idx] = {...ps[idx], 'comments': comments};
      posts.value = ps;
      _savePosts();
    }
  }

  Future<void> addCustomAff(Map<String, dynamic> aff) async {
    final list = [aff, ...customAffs.value];
    customAffs.value = list;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_custom_affs', jsonEncode(list));
  }

  Future<void> _savePosts() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('na_community_posts', jsonEncode(posts.value));
  }

  List<Map<String, dynamic>> _defaultPosts() => [
    {'id': 'p1', 'user': 'Ananya', 'avatar': 'A', 'time': '2h ago', 'imgIdx': 3, 'text': 'I am the creator of my reality. Everything is working out perfectly for me. 🌸', 'likes': 342, 'comments': ['So beautiful! 💖', 'This hit different today ✨'], 'vibe': 'Self Love'},
    {'id': 'p2', 'user': 'Priya Glow', 'avatar': 'P', 'time': '4h ago', 'imgIdx': 6, 'text': 'My body is a vessel of divine love and healing. 30 days of LOA and I\'m genuinely transformed! 🌿', 'likes': 128, 'comments': ['What a journey!'], 'vibe': 'Health'},
    {'id': 'p3', 'user': 'Meera✨', 'avatar': 'M', 'time': '6h ago', 'imgIdx': 14, 'text': 'I attract opportunities effortlessly. Said this 55 times today and the universe DELIVERED 🎉 Got my dream job callback!', 'likes': 891, 'comments': ['YAAS QUEEN 👑', 'So happy for you!!', 'This is inspiring 💗', 'How?! Tell me everything!'], 'vibe': 'Abundance'},
    {'id': 'p4', 'user': 'Siya', 'avatar': 'S', 'time': '1d ago', 'imgIdx': 7, 'text': 'I release what no longer serves me with love and gratitude. Journaling has literally changed my life 📓', 'likes': 204, 'comments': [], 'vibe': 'Healing'},
    {'id': 'p5', 'user': 'Radha 🌙', 'avatar': 'R', 'time': '1d ago', 'imgIdx': 17, 'text': 'Good things are ALWAYS happening to me. Said this for 30 days. The energy shift is REAL. Trust the process 💖', 'likes': 567, 'comments': ['Starting today!', 'You are glowing 🌸'], 'vibe': 'Manifestation'},
  ];
}

// ════════════════════════════════════════════════════════════════════
//  GLASSMORPHISM HELPER
// ════════════════════════════════════════════════════════════════════
class GlassCard extends StatelessWidget {
  final Widget child; final double radius; final EdgeInsets? padding;
  final double opacity; final Color tint;
  const GlassCard({super.key, required this.child, this.radius = 24, this.padding, this.opacity = 0.25, this.tint = Colors.white});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: tint.withOpacity(opacity),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: child,
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════
//  SPARKLE OVERLAY WIDGET
// ════════════════════════════════════════════════════════════════════
class SparkleOverlay extends StatelessWidget {
  final Widget child;
  const SparkleOverlay({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(children: [
    child,
    IgnorePointer(child: _SparkleParticles()),
  ]);
}

class _SparkleParticles extends StatefulWidget {
  @override
  State<_SparkleParticles> createState() => _SparkleParticlesState();
}

class _SparkleParticlesState extends State<_SparkleParticles> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: sz,
        painter: _SparklePainter(_ctrl.value, sz, _rng),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final double t;
  final Size sz;
  final Random rng;
  _SparklePainter(this.t, this.sz, this.rng);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [C.pinkTheme, C.purple, C.gold, Colors.white];
    for (var i = 0; i < 8; i++) {
      final phase = (t + i * 0.125) % 1.0;
      final opacity = sin(phase * pi).clamp(0.0, 0.7);
      if (opacity < 0.05) continue;
      final x = ((i * 137.5 + t * 50) % sz.width);
      final y = sz.height * phase;
      final r = 2.5 + sin(phase * pi * 2) * 1.5;
      canvas.drawCircle(Offset(x, y), r,
        Paint()..color = colors[i % colors.length].withOpacity(opacity * 0.6)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) => true;
}

// ════════════════════════════════════════════════════════════════════
//  APP ROOT
// ════════════════════════════════════════════════════════════════════
class NishAffsApp extends StatelessWidget {
  const NishAffsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NishAffs ✨',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: C.bg,
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.fromSeed(seedColor: C.pinkTheme),
      useMaterial3: true,
    ),
    builder: (ctx, child) => Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: ClipRect(child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: C.bg,
        child: child,
      ))),
    ),
    home: const _AppGate(),
  );
}

class _AppGate extends StatefulWidget {
  const _AppGate();
  @override
  State<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<_AppGate> {
  bool _splashDone = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _splashDone = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) return const _SplashView();
    return ValueListenableBuilder(
      valueListenable: AppState.instance.user,
      builder: (_, user, __) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeOutCubic,
        child: user != null ? const ShellRoute(key: ValueKey('shell')) : const LoginScreen(key: ValueKey('login')),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  SPLASH
// ════════════════════════════════════════════════════════════════════
class _SplashView extends StatelessWidget {
  const _SplashView();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(fit: StackFit.expand, children: [
      _img(2, w: double.infinity, h: double.infinity, fit: BoxFit.cover),
      Container(decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [C.pink3.withOpacity(0.5), C.purple.withOpacity(0.7), Colors.black.withOpacity(0.7)],
      ))),
      SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        GlassCard(radius: 40, opacity: 0.15, padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 24),
          child: Text('NishAffs', style: GoogleFonts.pacifico(fontSize: 52, color: Colors.white)))
          .animate().fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack),
        const SizedBox(height: 20),
        Text('"$_todayAffirmation"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 16, color: Colors.white.withOpacity(0.9), fontStyle: FontStyle.italic))
          .animate(delay: 400.ms).fadeIn(),
        const Spacer(),
        const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          .animate(delay: 900.ms).fadeIn(),
        const SizedBox(height: 48),
      ]))),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════
//  LOGIN / SIGNUP
// ════════════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false;

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network
    final name = _nameCtrl.text.trim().isEmpty ? _emailCtrl.text.split('@')[0] : _nameCtrl.text.trim();
    await AppState.instance.login(name, _emailCtrl.text.trim());
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(fit: StackFit.expand, children: [
      _img(6, w: double.infinity, h: double.infinity, fit: BoxFit.cover),
      Container(color: Colors.black.withOpacity(0.45)),
      // Kawaii decor
      Positioned(top: 60, right: 20, child: _img(16, w: 80, h: 80)),
      Positioned(top: 80, left: 10, child: _img(13, w: 60, h: 60)),
      Positioned(bottom: 100, right: 10, child: _img(7, w: 70, h: 70)),
      SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 60),
          Text('NishAffs', style: GoogleFonts.pacifico(fontSize: 40, color: Colors.white))
            .animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
          const SizedBox(height: 8),
          Text(_isLogin ? 'Welcome back, beautiful soul 🌸' : 'Start your magic journey ✨',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w500))
            .animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 48),

          // Form card
          GlassCard(radius: 32, opacity: 0.2, padding: const EdgeInsets.all(28), child: Column(children: [
            if (!_isLogin) ...[
              _formField(_nameCtrl, 'Your Name', Icons.person_outline_rounded),
              const SizedBox(height: 16),
            ],
            _formField(_emailCtrl, 'Email', Icons.email_outlined, type: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _formField(_passCtrl, 'Password', Icons.lock_outline_rounded, obscure: true),
            const SizedBox(height: 28),

            // Submit button
            GestureDetector(
              onTap: _loading ? null : _submit,
              child: Container(
                width: double.infinity, height: 56,
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]),
                child: Center(child: _loading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_isLogin ? 'Sign In ✨' : 'Create Account 🌸',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white))),
              ),
            ).animate().scale(begin: const Offset(0.97, 0.97)),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? "Don't have an account? Sign up →" : 'Already have an account? Sign in →',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w500)),
            ),
          ])).animate(delay: 300.ms).fadeIn().slideY(begin: 0.15),

          const SizedBox(height: 24),
          // Guest option
          Center(child: GestureDetector(
            onTap: () => AppState.instance.login('Guest', 'guest@nishaffs.app'),
            child: Text('Continue as Guest', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.6),
              decoration: TextDecoration.underline, decorationColor: Colors.white.withOpacity(0.5))),
          )),

          // Cute kawaii row
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _img(0, w: 40, h: 40), const SizedBox(width: 12),
            _img(9, w: 36, h: 36), const SizedBox(width: 12),
            _img(1, w: 40, h: 40), const SizedBox(width: 12),
            _img(16, w: 40, h: 40),
          ]).animate(delay: 500.ms).fadeIn(),
        ]),
      )),
    ]),
  );

  Widget _formField(TextEditingController ctrl, String hint, IconData icon, {TextInputType? type, bool obscure = false}) =>
    TextField(
      controller: ctrl, keyboardType: type, obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
        filled: true, fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: C.pinkTheme, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
}

// ════════════════════════════════════════════════════════════════════
//  SHELL ROUTE — with left drawer
// ════════════════════════════════════════════════════════════════════
class ShellRoute extends StatefulWidget {
  const ShellRoute({super.key});
  @override
  State<ShellRoute> createState() => _ShellRouteState();
}

class _ShellRouteState extends State<ShellRoute> with SingleTickerProviderStateMixin {
  int _tab = 0;
  bool _drawerOpen = false;
  late AnimationController _drawerCtrl;
  late Animation<double> _drawerAnim;

  static const _drawerWidth = 300.0;

  void _openDrawer() { setState(() => _drawerOpen = true); _drawerCtrl.forward(); }
  void _closeDrawer() { _drawerCtrl.reverse().then((_) { if (mounted) setState(() => _drawerOpen = false); }); }

  @override
  void initState() {
    super.initState();
    _drawerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _drawerAnim = CurvedAnimation(parent: _drawerCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() { _drawerCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // ── Main app
      SparkleOverlay(
        child: AnimatedBuilder(
          animation: _drawerAnim,
          builder: (_, child) => Transform.translate(
            offset: Offset(_drawerAnim.value * _drawerWidth, 0),
            child: GestureDetector(
              onHorizontalDragEnd: (d) {
                if (!_drawerOpen && d.primaryVelocity! > 200) _openDrawer();
                if (_drawerOpen && d.primaryVelocity! < -200) _closeDrawer();
              },
              child: child,
            ),
          ),
          child: Scaffold(
            extendBody: true,
            body: IndexedStack(index: _tab, children: [
              HomeView(onOpenDrawer: _openDrawer),
              const LibraryView(),
              const StudioView(),
              const CommunityView(),
              const ProfileView(),
            ]),
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
                      _NavBtn(1, _tab, Icons.auto_stories_rounded, 'Library', () => setState(() => _tab = 1)),
                      _NavBtn(2, _tab, Icons.add_circle_rounded, 'Studio', () => setState(() => _tab = 2)),
                      _NavBtn(3, _tab, Icons.favorite_rounded, 'Vibes', () => setState(() => _tab = 3)),
                      _NavBtn(4, _tab, Icons.person_rounded, 'Me', () => setState(() => _tab = 4)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // ── Drawer overlay dimmer
      if (_drawerOpen)
        AnimatedBuilder(
          animation: _drawerAnim,
          builder: (_, __) => GestureDetector(
            onTap: _closeDrawer,
            child: Container(color: Colors.black.withOpacity(0.4 * _drawerAnim.value)),
          ),
        ),

      // ── Left drawer panel
      AnimatedBuilder(
        animation: _drawerAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset((_drawerAnim.value - 1) * _drawerWidth, 0),
          child: child,
        ),
        child: _LeftDrawer(onClose: _closeDrawer),
      ),
    ]);
  }
}

class _NavBtn extends StatelessWidget {
  final int index, current; final IconData icon; final String label; final VoidCallback onTap;
  const _NavBtn(this.index, this.current, this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) {
    final on = index == current;
    return GestureDetector(
      onTap: onTap, behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding: EdgeInsets.symmetric(horizontal: on ? 14 : 8, vertical: 10),
        decoration: BoxDecoration(color: on ? C.pinkTheme.withOpacity(0.18) : Colors.transparent, borderRadius: BorderRadius.circular(24)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: on ? C.pinkDark : C.textSub, size: 24),
          if (on) ...[
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark))
              .animate().fadeIn().slideX(begin: 0.2),
          ],
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  LEFT DRAWER PANEL
// ════════════════════════════════════════════════════════════════════
class _LeftDrawer extends StatelessWidget {
  final VoidCallback onClose;
  const _LeftDrawer({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: C.pink1,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(6, 0))],
      ),
      child: SafeArea(child: ValueListenableBuilder(
        valueListenable: AppState.instance.user,
        builder: (_, user, __) => ListView(padding: const EdgeInsets.all(24), children: [
          // Profile mini
          Row(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [C.pinkTheme, C.purple])),
              child: Center(child: Text(user?['avatar'] ?? 'N', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?['name'] ?? 'Guest', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textDark)),
              Text(user?['email'] ?? '', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
          ]),
          const SizedBox(height: 32),

          // Stats row
          Row(children: [
            _drawerStat('Streak', '7🔥'),
            const SizedBox(width: 8),
            _drawerStat('Affs', '21✨'),
            const SizedBox(width: 8),
            _drawerStat('Books', '3📚'),
          ]),
          const SizedBox(height: 28),

          _drawerItem(Icons.bookmark_rounded, 'Saved', C.gold, () {}),
          _drawerItem(Icons.favorite_rounded, 'Liked Posts', C.pinkDark, () {}),
          _drawerItem(Icons.edit_note_rounded, 'My Affirmations', C.purple, () {}),
          _drawerItem(Icons.notifications_rounded, 'Notifications', C.pinkTheme, () {}),
          _drawerItem(Icons.settings_rounded, 'Settings', C.textSub, () {}),
          const SizedBox(height: 32),

          // Bookmarks section header
          Text('Saved Affirmations', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: AppState.instance.customAffs,
            builder: (_, affs, __) => affs.isEmpty
              ? Text('No saved affirmations yet.\nCreate one from Studio! 🎨', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub, height: 1.6))
              : Column(children: affs.take(4).map((a) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Text(a['text'] ?? '', style: GoogleFonts.lora(fontSize: 13, color: C.textDark, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                )).toList()),
          ),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: () { AppState.instance.logout(); onClose(); },
            child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text('Sign Out', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)))),
          ),
        ]),
      )),
    );
  }

  Widget _drawerStat(String label, String val) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
    child: Column(children: [
      Text(val, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: C.textSub)),
    ]),
  ));

  Widget _drawerItem(IconData icon, String label, Color color, VoidCallback onTap) =>
    GestureDetector(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 14),
        Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: C.textDark)),
        const Spacer(),
        Icon(Icons.chevron_right_rounded, color: C.textSub, size: 18),
      ])),
    );
}

// ════════════════════════════════════════════════════════════════════
//  HOME VIEW
// ════════════════════════════════════════════════════════════════════
class HomeView extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const HomeView({super.key, required this.onOpenDrawer});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _affIdx = 0;
  late Timer _timer;
  bool _todayLiked = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (mounted) setState(() => _affIdx = (_affIdx + 1) % _dailyAffirmations.length);
    });
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: _img(12, w: double.infinity, h: double.infinity, fit: BoxFit.cover)),
      Positioned.fill(child: Container(color: Colors.white.withOpacity(0.88))),
      SafeArea(bottom: false, child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            // Header
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Left drawer handle
              GestureDetector(
                onTap: widget.onOpenDrawer,
                child: ValueListenableBuilder(
                  valueListenable: AppState.instance.user,
                  builder: (_, user, __) => Container(width: 44, height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]),
                    child: Center(child: Text(user?['avatar'] ?? 'N',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)))),
                ),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Daily Radiance ✨', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark)),
                ValueListenableBuilder(
                  valueListenable: AppState.instance.user,
                  builder: (_, user, __) => Text('Hey, ${user?['name'] ?? 'Beautiful'} 🌸',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
                ),
              ]),
            ]).animate().fadeIn(duration: 600.ms),
            const SizedBox(height: 32),

            // TODAY'S AFFIRMATION giant card
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.05), end: Offset.zero).animate(anim), child: child)),
              child: _TodayCard(
                key: ValueKey(_affIdx),
                text: _dailyAffirmations[_affIdx],
                liked: _todayLiked,
                onLike: () => setState(() => _todayLiked = !_todayLiked),
              ),
            ),
            const SizedBox(height: 32),

            // Quick action pills
            Row(children: [
              _quickPill('📖 Read', C.purpleLgt),
              const SizedBox(width: 10),
              _quickPill('🎵 Sounds', C.goldLgt),
              const SizedBox(width: 10),
              _quickPill('✍️ Create', C.pink1),
            ]).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 32),

            // Curated section
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Curated for you', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: C.textDark)),
              Text('See All', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)),
            ]).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 16),
            SizedBox(height: 220, child: ListView.builder(
              scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (ctx, i) => Container(
                width: 150, margin: const EdgeInsets.only(right: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20),
                    child: _img(i + 2, w: 150, h: double.infinity, fit: BoxFit.cover))),
                  const SizedBox(height: 10),
                  Text(['Inner Peace', 'Level Up', 'Healing Era', 'Lucky Girl', 'Deep Sleep'][i],
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
                  Text(['5 Tracks', '10 Affs', 'Guided', 'Music', '8 Hours'][i],
                    style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                ]),
              ).animate(delay: (300 + i * 80).ms).fadeIn().slideY(begin: 0.1),
            )),
            const SizedBox(height: 32),

            // Kawaii strip decoration
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(24),
                border: Border.all(color: C.pink2, width: 1.5)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) =>
                _img(i * 3, w: 44, h: 44))),
            ).animate(delay: 400.ms).fadeIn(),
            const SizedBox(height: 120),
          ]),
        ))],
      )),
    ]);
  }

  Widget _quickPill(String label, Color bg) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: C.pink2, width: 1.2)),
    child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark))),
  ));
}

class _TodayCard extends StatelessWidget {
  final String text; final bool liked; final VoidCallback onLike;
  const _TodayCard({super.key, required this.text, required this.liked, required this.onLike});
  @override
  Widget build(BuildContext context) => Container(
    height: 420, width: double.infinity,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(36)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Stack(children: [
        Positioned.fill(child: _img(12, w: double.infinity, h: double.infinity, fit: BoxFit.cover)),
        Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.75)])))),
        Positioned(top: 20, left: 20, child: GlassCard(radius: 100, opacity: 0.15,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.wb_sunny_rounded, color: C.gold, size: 14),
            const SizedBox(width: 6),
            Text('Today · ${_monthDay()}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
          ]))),
        Positioned(bottom: 28, left: 28, right: 28, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('"$text"', style: GoogleFonts.lora(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600, height: 1.45)),
          const SizedBox(height: 20),
          Row(children: [
            GestureDetector(onTap: onLike, child: GlassCard(radius: 100, tint: liked ? C.pinkTheme : Colors.white, opacity: liked ? 0.8 : 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(liked ? 'Loved ✨' : 'Feel It', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              ]))).animate(target: liked ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05)),
            const Spacer(),
            GlassCard(radius: 100, opacity: 0.2, padding: const EdgeInsets.all(12),
              child: const Icon(Icons.share_outlined, color: Colors.white, size: 22)),
            const SizedBox(width: 10),
            GlassCard(radius: 100, opacity: 0.2, padding: const EdgeInsets.all(12),
              child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 22)),
          ]),
        ])),
      ]),
    ),
  );
}

String _monthDay() {
  final m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  final d = DateTime.now();
  return '${m[d.month - 1]} ${d.day}';
}

// ════════════════════════════════════════════════════════════════════
//  LIBRARY — BOOKS WITH KINDLE PAGE FLIP
// ════════════════════════════════════════════════════════════════════
class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(24, 20, 24, 0), child: Row(children: [
        Text('Wisdom Library 📚', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: C.textDark)),
      ])),
      const SizedBox(height: 20),
      // Category chips
      SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 24),
        children: ['All', 'LOA', 'Mindfulness', 'Spiritual', 'Self-Love'].asMap().entries.map((e) =>
          Container(margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              gradient: e.key == 0 ? const LinearGradient(colors: [C.pinkTheme, C.purple]) : null,
              color: e.key == 0 ? null : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: e.key == 0 ? Colors.transparent : C.pink2, width: 1.2),
            ),
            child: Text(e.value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: e.key == 0 ? Colors.white : C.textSub)))).toList())),
      const SizedBox(height: 20),
      Expanded(child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 16, mainAxisSpacing: 20),
        itemCount: _booksData.length,
        itemBuilder: (ctx, i) {
          final book = _booksData[i];
          return GestureDetector(
            onTap: () => Navigator.push(ctx, _pageRoute(KindleReader(book: book))),
            child: Column(children: [
              Expanded(child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(18), bottomRight: Radius.circular(18), topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: book.grad),
                  boxShadow: [BoxShadow(color: book.grad.last.withOpacity(0.4), blurRadius: 16, offset: const Offset(5, 6))],
                ),
                child: Stack(children: [
                  Positioned(left: 0, top: 0, bottom: 0, width: 10, child: Container(color: Colors.black.withOpacity(0.18),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))))),
                  Center(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(book.emoji, style: const TextStyle(fontSize: 38)),
                    const SizedBox(height: 10),
                    Text(book.title, textAlign: TextAlign.center, style: GoogleFonts.playfairDisplay(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ]))),
                  Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
                    child: Text(book.tag, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)))),
                ]),
              )),
              const SizedBox(height: 10),
              Text(book.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text('by ${book.author}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
            ]),
          ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.1);
        },
      )),
    ])),
  );
}

PageRoute _pageRoute(Widget page) => PageRouteBuilder(
  pageBuilder: (_, a, __) => page,
  transitionDuration: const Duration(milliseconds: 450),
  transitionsBuilder: (_, anim, __, child) => SlideTransition(
    position: Tween(begin: const Offset(1, 0), end: Offset.zero)
      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
    child: child,
  ),
);

// ════════════════════════════════════════════════════════════════════
//  KINDLE READER — Real page flip animation
// ════════════════════════════════════════════════════════════════════
class KindleReader extends StatefulWidget {
  final Book book;
  const KindleReader({super.key, required this.book});
  @override
  State<KindleReader> createState() => _KindleReaderState();
}

class _KindleReaderState extends State<KindleReader> with SingleTickerProviderStateMixin {
  int _cur = 0;
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _isFlipping = false;
  bool _toNext = true;
  int _nextPage = 0;
  Offset _dragStart = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        setState(() { _cur = _nextPage; _isFlipping = false; });
        _ctrl.reset();
      }
    });
  }

  void _flip(bool next) {
    if (_isFlipping) return;
    final np = next ? _cur + 1 : _cur - 1;
    if (np < 0 || np >= widget.book.pages.length) {
      if (!next) Navigator.pop(context);
      return;
    }
    setState(() { _isFlipping = true; _toNext = next; _nextPage = np; });
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.book,
      body: GestureDetector(
        onHorizontalDragStart: (d) => _dragStart = d.globalPosition,
        onHorizontalDragEnd: (d) {
          if (d.primaryVelocity! < -200) _flip(true);
          else if (d.primaryVelocity! > 200) _flip(false);
        },
        onTapDown: (d) {
          final w = MediaQuery.of(context).size.width;
          if (d.globalPosition.dx > w * 0.65) _flip(true);
          else if (d.globalPosition.dx < w * 0.35) _flip(false);
        },
        child: AnimatedBuilder(
          animation: _anim,
          builder: (ctx, __) {
            final sz = MediaQuery.of(ctx).size;
            final v = _anim.value;

            Widget frontPage = _buildPageContent(widget.book.pages[_cur], sz);
            Widget nextPg   = _isFlipping ? _buildPageContent(widget.book.pages[_nextPage], sz) : frontPage;

            if (!_isFlipping) return frontPage;

            return Stack(children: [
              // Destination page (always visible behind)
              nextPg,

              // Shadow cast by flipping page
              if (v < 0.5)
                Positioned(right: 0, top: 0, bottom: 0,
                  child: Container(
                    width: sz.width * (1 - v * 2),
                    decoration: BoxDecoration(gradient: LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: [Colors.black.withOpacity(0.2 * (1 - v * 2)), Colors.transparent])),
                  )),

              // Flipping page with 3D perspective
              if (v < 0.5)
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateY(-v * pi),
                  alignment: Alignment.centerRight,
                  child: frontPage,
                )
              else
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateY((1.0 - v) * pi),
                  alignment: Alignment.centerLeft,
                  child: Container(color: C.book, child: Stack(children: [nextPg,
                    Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: [Colors.black.withOpacity(0.12), Colors.transparent, Colors.transparent])))),
                  ])),
                ),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildPageContent(BookPage page, Size sz) {
    return Container(
      width: sz.width, height: sz.height,
      color: C.book,
      child: SafeArea(child: Column(children: [
        // Top bar
        Padding(padding: const EdgeInsets.fromLTRB(28, 16, 28, 0), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF8B6040))),
          const Spacer(),
          Text(widget.book.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF8B6040))),
          const Spacer(),
          Text('${_cur + 1} / ${widget.book.pages.length}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400)),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(
            value: (_cur + 1) / widget.book.pages.length, minHeight: 2,
            backgroundColor: Colors.brown.withOpacity(0.1), color: const Color(0xFFD4956A)))),
        Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 28), color: Colors.brown.withOpacity(0.1)),

        // Content
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(36, 28, 36, 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(page.chapter, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700,
              color: const Color(0xFFD4956A), letterSpacing: 2)),
            const SizedBox(height: 16),
            if (page.title != null) ...[
              Text(page.title!, style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF3D2B1F))),
              const SizedBox(height: 16),
              Container(height: 2, width: 50, color: const Color(0xFFD4956A)),
              const SizedBox(height: 24),
            ],
            Text(page.body, style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF4A3520), height: 1.95, letterSpacing: 0.2)),
            const SizedBox(height: 40),
            Center(child: Text('· · ·', style: GoogleFonts.lora(fontSize: 20, color: const Color(0xFFD4956A)))),
          ]),
        )),

        // Bottom nav
        Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 16), child: Row(children: [
          if (_cur > 0) GestureDetector(onTap: () => _flip(false), child: Row(children: [
            const Icon(Icons.arrow_back_ios, size: 13, color: Color(0xFFD4956A)),
            Text('Prev', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFD4956A))),
          ])),
          const Spacer(),
          Text('Swipe to turn page', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400)),
          const Spacer(),
          if (_cur < widget.book.pages.length - 1) GestureDetector(onTap: () => _flip(true), child: Row(children: [
            Text('Next', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFD4956A))),
            const Icon(Icons.arrow_forward_ios, size: 13, color: Color(0xFFD4956A)),
          ])),
        ])),
      ])),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  STUDIO — CREATE & POST
// ════════════════════════════════════════════════════════════════════
class StudioView extends StatefulWidget {
  const StudioView({super.key});
  @override
  State<StudioView> createState() => _StudioViewState();
}

class _StudioViewState extends State<StudioView> {
  final _tc = TextEditingController();
  String _vibe = 'Self Love';
  int _bgIdx = 0;

  final _vibes = [
    ('Self Love', C.pink2, C.pinkDark),
    ('Abundance', const Color(0xFFD1FFE0), const Color(0xFF2A9D59)),
    ('Confidence', C.purpleLgt, C.purple),
    ('Healing', const Color(0xFFD1EAFF), const Color(0xFF3A7FD4)),
    ('Gratitude', C.goldLgt, const Color(0xFF9B7B14)),
    ('Peace', const Color(0xFFE8FFF5), const Color(0xFF2A9D7A)),
  ];

  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  void _createPost() {
    if (_tc.text.trim().isEmpty) return;
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _PostPreviewSheet(
        text: _tc.text.trim(), vibe: _vibe, bgIdx: _bgIdx,
        onPost: (target) async {
          if (target == 'community') {
            final user = AppState.instance.user.value;
            await AppState.instance.addPost({
              'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
              'user': user?['name'] ?? 'You',
              'avatar': user?['avatar'] ?? 'Y',
              'time': 'Just now',
              'imgIdx': _bgIdx,
              'text': _tc.text.trim(),
              'likes': 0,
              'comments': <String>[],
              'vibe': _vibe,
            });
            await AppState.instance.addCustomAff({'text': _tc.text.trim(), 'vibe': _vibe, 'ts': DateTime.now().toIso8601String()});
          }
          if (mounted) {
            _tc.clear();
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(target == 'community' ? '🌸 Posted to community!' : '✨ ${target == 'save' ? 'Saved!' : 'Shared!'}'),
              backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
      children: [
        Text('Studio 🎨', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: C.textDark)),
        const SizedBox(height: 6),
        Text('Create your affirmation post', style: GoogleFonts.poppins(fontSize: 14, color: C.textSub)),
        const SizedBox(height: 28),

        // Affirmation text input
        Text('Your Affirmation', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.textDark)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
          child: TextField(
            controller: _tc, maxLines: 4,
            style: GoogleFonts.lora(fontSize: 16, color: C.textDark, height: 1.7),
            decoration: InputDecoration(
              hintText: '"I am a magnet for miracles and abundance..."',
              hintStyle: GoogleFonts.lora(fontSize: 15, color: C.textSub.withOpacity(0.6), fontStyle: FontStyle.italic),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              fillColor: Colors.transparent, filled: true,
              contentPadding: const EdgeInsets.all(20)),
          ),
        ),
        const SizedBox(height: 24),

        // Vibe picker
        Text('Choose Your Vibe', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.textDark)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: _vibes.map((v) {
          final on = _vibe == v.$1;
          return GestureDetector(
            onTap: () => setState(() => _vibe = v.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: on ? v.$2 : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: on ? v.$3 : C.pink2, width: on ? 2 : 1.2),
                boxShadow: on ? [BoxShadow(color: v.$3.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))] : [],
              ),
              child: Text(v.$1, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: on ? v.$3 : C.textSub)),
            ),
          );
        }).toList()),
        const SizedBox(height: 24),

        // Background picker
        Text('Background', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.textDark)),
        const SizedBox(height: 12),
        SizedBox(height: 80, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => setState(() => _bgIdx = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70, height: 70,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _bgIdx == i ? C.pinkDark : Colors.transparent, width: 3),
                boxShadow: _bgIdx == i ? [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 8)] : [],
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(13), child: _img(i + 3, w: 70, h: 70, fit: BoxFit.cover)),
            ),
          ),
        )),
        const SizedBox(height: 32),

        // Preview mini
        Text('Preview', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.textDark)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(height: 200, child: Stack(children: [
            Positioned.fill(child: _img(_bgIdx + 3, w: double.infinity, h: double.infinity, fit: BoxFit.cover)),
            Positioned.fill(child: Container(color: Colors.black.withOpacity(0.35))),
            Center(child: Padding(padding: const EdgeInsets.all(20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('"${_tc.text.isEmpty ? "Your affirmation here..." : _tc.text}"', textAlign: TextAlign.center,
                  style: GoogleFonts.lora(fontSize: 16, color: Colors.white, height: 1.5, fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text('#NishAffs • $_vibe', style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600))),
              ]))),
          ])),
        ),
        const SizedBox(height: 28),

        // Create button
        GestureDetector(
          onTap: _createPost,
          child: Container(
            width: double.infinity, height: 56,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(100),
              boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]),
            child: Center(child: Text('Create & Share ✨', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white))),
          ),
        ).animate().scale(begin: const Offset(0.97, 0.97)),
      ],
    )),
  );
}

class _PostPreviewSheet extends StatelessWidget {
  final String text, vibe; final int bgIdx; final void Function(String) onPost;
  const _PostPreviewSheet({required this.text, required this.vibe, required this.bgIdx, required this.onPost});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    child: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
      const SizedBox(height: 20),
      Text('Your Affirmation is Ready! 🌸', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: C.textDark)),
      const SizedBox(height: 16),
      // Mini preview
      ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(height: 140, child: Stack(children: [
        Positioned.fill(child: _img(bgIdx + 3, w: double.infinity, h: double.infinity, fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.35))),
        Center(child: Text('"$text"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 14, color: Colors.white, height: 1.5, fontStyle: FontStyle.italic),
          overflow: TextOverflow.ellipsis, maxLines: 4)),
      ]))),
      const SizedBox(height: 24),
      Text('Where would you like to share?', style: GoogleFonts.poppins(fontSize: 14, color: C.textSub)),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _shareBtn(context, '🌸 Community', C.pink1, C.pinkDark, 'community')),
        const SizedBox(width: 10),
        Expanded(child: _shareBtn(context, '💾 Save', C.purpleLgt, C.purple, 'save')),
        const SizedBox(width: 10),
        Expanded(child: _shareBtn(context, '📤 Share', C.goldLgt, const Color(0xFF9B7B14), 'share')),
      ]),
      const SizedBox(height: 12),
      _shareBtn(context, '📱 Post as Story', C.bg, C.textDark, 'story', full: true),
    ]))),
  );

  Widget _shareBtn(BuildContext ctx, String label, Color bg, Color fg, String target, {bool full = false}) =>
    GestureDetector(
      onTap: () => onPost(target),
      child: Container(
        width: full ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: fg.withOpacity(0.3), width: 1.2)),
        child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: fg), textAlign: TextAlign.center)),
      ),
    );
}

// ════════════════════════════════════════════════════════════════════
//  COMMUNITY (VIBE CHECK) — Stories + Posts
// ════════════════════════════════════════════════════════════════════
class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      // Header
      Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 0), child: Row(children: [
        Text('NishAffs', style: GoogleFonts.pacifico(fontSize: 26, color: C.textDark)),
        const SizedBox(width: 8),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(8)),
          child: Text('Vibes ✨', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
        const Spacer(),
        const Icon(Icons.search_rounded, size: 24, color: C.textSub),
      ])),
      const SizedBox(height: 16),

      // Stories
      SizedBox(height: 100, child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: _storiesData.asMap().entries.map((e) => _StoryBubble(story: e.value, index: e.key)).toList(),
      )),
      const SizedBox(height: 8),

      // Posts feed
      Expanded(child: ValueListenableBuilder(
        valueListenable: AppState.instance.posts,
        builder: (_, posts, __) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 120),
          itemCount: posts.length,
          itemBuilder: (ctx, i) => _PostCard(post: posts[i], index: i),
        ),
      )),
    ])),
  );
}

final _storiesData = [
  {'user': 'Ananya', 'avatar': 'A', 'pages': ['I am worthy of all the love in the universe. 🌸', 'Today I choose joy, no matter what. ✨']},
  {'user': 'Priya', 'avatar': 'P', 'pages': ['I attract miracles effortlessly. 💫']},
  {'user': 'Meera✨', 'avatar': 'M', 'pages': ['The universe is my co-creator. 🌌', 'I trust my journey completely.', 'Abundance is my birthright! 💰']},
  {'user': 'Siya', 'avatar': 'S', 'pages': ['I am healing and glowing every day. 🌿']},
  {'user': 'Radha', 'avatar': 'R', 'pages': ['My vibe attracts my tribe. 🦋', 'Love flows to me from all directions. 💖']},
  {'user': 'Nova', 'avatar': 'N', 'pages': ['I am the energy I wish to see. ✨']},
];

class _StoryBubble extends StatelessWidget {
  final Map<String, dynamic> story; final int index;
  const _StoryBubble({required this.story, required this.index});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, PageRouteBuilder(
      opaque: false, barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) => StoryViewer(stories: _storiesData, initialIndex: index),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: ScaleTransition(scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)), child: child)),
    )),
    child: Container(margin: const EdgeInsets.only(right: 14), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 64, height: 64,
        decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [C.pinkTheme, C.purple]),
          border: Border.all(color: C.bg, width: 2),
          boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]),
        child: Center(child: Text(story['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)))),
      const SizedBox(height: 6),
      Text(story['user'] ?? '', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
    ])),
  );
}

// ════════════════════════════════════════════════════════════════════
//  STORY VIEWER — Full screen with progress bar
// ════════════════════════════════════════════════════════════════════
class StoryViewer extends StatefulWidget {
  final List<Map<String, dynamic>> stories; final int initialIndex;
  const StoryViewer({super.key, required this.stories, required this.initialIndex});
  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> with TickerProviderStateMixin {
  late int _userIdx;
  int _pageIdx = 0;
  late AnimationController _progress;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _userIdx = widget.initialIndex;
    _progress = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _startTimer();
  }

  void _startTimer() {
    _progress.reset();
    _progress.forward();
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), _advance);
  }

  void _advance() {
    final pages = (widget.stories[_userIdx]['pages'] as List<dynamic>);
    if (_pageIdx < pages.length - 1) {
      setState(() => _pageIdx++);
      _startTimer();
    } else if (_userIdx < widget.stories.length - 1) {
      setState(() { _userIdx++; _pageIdx = 0; });
      _startTimer();
    } else {
      Navigator.pop(context);
    }
  }

  void _goBack() {
    if (_pageIdx > 0) { setState(() => _pageIdx--); _startTimer(); }
    else if (_userIdx > 0) { setState(() { _userIdx--; _pageIdx = 0; }); _startTimer(); }
  }

  @override
  void dispose() { _progress.dispose(); _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_userIdx];
    final pages = story['pages'] as List<dynamic>;
    final sz = MediaQuery.of(context).size;

    return GestureDetector(
      onTapDown: (d) { if (d.globalPosition.dx < sz.width / 2) _goBack(); else _advance(); },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(fit: StackFit.expand, children: [
          // Background
          Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [C.pink3.withOpacity(0.9), C.purple.withOpacity(0.9)], ))),
          _img((_userIdx + _pageIdx) % 19, w: sz.width, h: sz.height, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.45)),

          SafeArea(child: Column(children: [
            // Progress bars
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: Row(
              children: List.generate(pages.length, (i) => Expanded(child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2), height: 3,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.35), borderRadius: BorderRadius.circular(2)),
                child: i < _pageIdx
                  ? Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))
                  : i == _pageIdx
                    ? AnimatedBuilder(animation: _progress, builder: (_, __) => FractionallySizedBox(
                        widthFactor: _progress.value, alignment: Alignment.centerLeft,
                        child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))))
                    : const SizedBox.shrink(),
              ))),
            )),

            // User header
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
                border: Border.all(color: Colors.white, width: 2)),
                child: Center(child: Text(story['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)))),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(story['user'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                Text('Now', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withOpacity(0.7))),
              ]),
              const Spacer(),
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white, size: 26)),
            ])),

            const Spacer(),
            Padding(padding: const EdgeInsets.all(28),
              child: Text('"${pages[_pageIdx]}"', textAlign: TextAlign.center,
                style: GoogleFonts.lora(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600, height: 1.45))),
            const Spacer(),
          ])),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  POST CARD — Working like / comment / share / bookmark
// ════════════════════════════════════════════════════════════════════
class _PostCard extends StatefulWidget {
  final Map<String, dynamic> post; final int index;
  const _PostCard({required this.post, required this.index});
  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late bool _liked;
  late bool _saved;
  late int _likes;

  @override
  void initState() {
    super.initState();
    final id = widget.post['id'] as String;
    _liked = AppState.instance.liked.value.contains(id);
    _saved = AppState.instance.saved.value.contains(id);
    _likes = widget.post['likes'] as int? ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final id = post['id'] as String;
    final comments = (post['comments'] as List<dynamic>? ?? []);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // User row
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 10), child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [C.pinkTheme, C.purple])),
          child: Center(child: Text(post['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)))),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(post['user'] ?? '', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
          Text('${post['time']} · #${post['vibe']}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
        ]),
        const Spacer(),
        const Icon(Icons.more_horiz_rounded, color: C.textSub),
      ])),

      // Post image + text
      Container(
        height: 380, margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Stack(children: [
          Positioned.fill(child: _img((post['imgIdx'] as int? ?? 0) + 3, w: double.infinity, h: double.infinity, fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
          Center(child: Padding(padding: const EdgeInsets.all(28),
            child: Text('"${post['text']}"', textAlign: TextAlign.center,
              style: GoogleFonts.lora(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600, height: 1.4)))),
          Positioned(bottom: 14, right: 14, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Text('#NishAffs', style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)))),
        ]),
      ),

      // Actions
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
        // Like
        GestureDetector(
          onTap: () async {
            await AppState.instance.toggleLike(id);
            setState(() { _liked = AppState.instance.liked.value.contains(id); _likes += _liked ? 1 : -1; });
          },
          child: Row(children: [
            Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _liked ? C.pinkDark : C.textDark, size: 26)
              .animate(target: _liked ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3)).then().scale(end: const Offset(1, 1)),
            const SizedBox(width: 4),
            Text('$_likes', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark)),
          ]),
        ),
        const SizedBox(width: 20),

        // Comment
        GestureDetector(
          onTap: () => _showComments(context, post, id),
          child: Row(children: [
            const Icon(Icons.mode_comment_outlined, color: C.textDark, size: 24),
            const SizedBox(width: 4),
            Text('${comments.length}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark)),
          ]),
        ),
        const SizedBox(width: 20),

        // Share
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('📤 Link copied to clipboard!'),
            backgroundColor: C.purple, behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
          child: const Icon(Icons.send_outlined, color: C.textDark, size: 24),
        ),

        const Spacer(),
        // Bookmark
        GestureDetector(
          onTap: () async {
            await AppState.instance.toggleSave(id);
            setState(() => _saved = AppState.instance.saved.value.contains(id));
          },
          child: Icon(_saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: _saved ? C.pinkDark : C.textDark, size: 26),
        ),
      ])),

      // Preview first comment
      if (comments.isNotEmpty)
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          child: RichText(text: TextSpan(style: GoogleFonts.poppins(fontSize: 13, color: C.textDark),
            children: [
              TextSpan(text: 'Top comment: ', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: C.textSub)),
              TextSpan(text: comments.first.toString()),
            ]))),
      Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Text('View all ${comments.length} comments', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub))),

      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Divider(color: C.pink2.withOpacity(0.5), height: 1)),
    ]);
  }

  void _showComments(BuildContext context, Map<String, dynamic> post, String id) {
    final tc = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 16),
          Text('Comments', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: AppState.instance.posts,
            builder: (_, posts, __) {
              final p = posts.firstWhere((e) => e['id'] == id, orElse: () => post);
              final cmts = (p['comments'] as List<dynamic>? ?? []);
              return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 250),
  child: cmts.isEmpty
                  ? Center(child: Text('Be the first to comment! 🌸', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)))
                  : ListView(shrinkWrap: true, children: cmts.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Container(width: 34, height: 34, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [C.pink3, C.purpleLgt])),
                          child: const Center(child: Text('🌸', style: TextStyle(fontSize: 16)))),
                        const SizedBox(width: 10),
                        Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(14)),
                          child: Text(c.toString(), style: GoogleFonts.poppins(fontSize: 13, color: C.textDark)))),
                      ]),
                    )).toList()),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextField(controller: tc,
              style: GoogleFonts.poppins(fontSize: 13, color: C.textDark),
              decoration: InputDecoration(hintText: 'Add a comment... 💬', hintStyle: GoogleFonts.poppins(color: C.textSub, fontSize: 13),
                filled: true, fillColor: C.pink1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)))),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                if (tc.text.trim().isEmpty) return;
                await AppState.instance.addComment(id, tc.text.trim());
                tc.clear(); setS(() {});
              },
              child: Container(width: 48, height: 48, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [C.pinkTheme, C.purple])),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20))),
          ]),
        ]),
      )),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  PROFILE — Soundscapes + Journal + Settings
// ════════════════════════════════════════════════════════════════════
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  late TabController _tc;
  int _playingIdx = -1;
  bool _notifs = true;
  bool _darkMode = false;

  final _soundscapes = [
    _Sound('432Hz Deep Healing', 'Binaural Beats', '∞', '🎵', C.purpleLgt, const Color(0xFF8B5CF6)),
    _Sound('Morning Abundance Flow', 'Solfeggio 528Hz', '30 min', '☀️', C.goldLgt, C.gold),
    _Sound('Inner Peace Rain', 'Nature Sounds', '60 min', '🌧️', const Color(0xFFD1EAFF), const Color(0xFF4A90D9)),
    _Sound('Deep Sleep Delta', 'Delta Waves', '8 hrs', '🌙', const Color(0xFFE8E0FF), const Color(0xFF6B5CE7)),
    _Sound('Study Focus Beta', 'Beta Waves', '45 min', '📚', C.mint, const Color(0xFF2A9D7A)),
    _Sound('Manifest While You Sleep', 'Affirmation + Music', '6 hrs', '✨', C.pink1, C.pinkDark),
    _Sound('Chakra Balancing', '7 Chakra Tones', '25 min', '🌈', const Color(0xFFFFF0D1), C.gold),
    _Sound('Self Love Morning', 'Guided + Music', '15 min', '💗', C.pink2, C.pinkDark),
  ];

  @override
  void initState() { super.initState(); _tc = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      // Profile header
      ValueListenableBuilder(
        valueListenable: AppState.instance.user,
        builder: (_, user, __) => Container(
          padding: const EdgeInsets.all(24),
          child: Row(children: [
            Stack(children: [
              Container(width: 72, height: 72, decoration: BoxDecoration(shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]),
                child: Center(child: Text(user?['avatar'] ?? 'N', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)))),
              Positioned(bottom: 2, right: 2, child: Container(width: 20, height: 20,
                decoration: BoxDecoration(color: const Color(0xFF22C55E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            ]),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?['name'] ?? 'Guest', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: C.textDark)),
              Text('Manifesting since 2026 ✨', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
              const SizedBox(height: 10),
              Row(children: [
                _statPill('7🔥', 'Streak'),
                const SizedBox(width: 8),
                _statPill('21✨', 'Affs'),
                const SizedBox(width: 8),
                _statPill('3📚', 'Books'),
              ]),
            ])),
            GestureDetector(
              onTap: () => AppState.instance.logout(),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.pink2)),
                child: Text('Sign Out', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark))),
            ),
          ]),
        ),
      ),

      // Tabs
      Container(margin: const EdgeInsets.symmetric(horizontal: 24), decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(16)),
        child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: C.textSub,
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          indicator: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(14)),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [Tab(text: '🎵 Sounds'), Tab(text: '📓 Journal'), Tab(text: '⚙️ Settings')])),

      Expanded(child: TabBarView(controller: _tc, children: [
        // SOUNDSCAPES
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          itemCount: _soundscapes.length,
          itemBuilder: (ctx, i) => _SoundCard(
            sound: _soundscapes[i], isPlaying: _playingIdx == i,
            onTap: () => setState(() => _playingIdx = _playingIdx == i ? -1 : i),
          ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.06),
        ),

        // JOURNAL
        ValueListenableBuilder(
          valueListenable: AppState.instance.customAffs,
          builder: (_, affs, __) => affs.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                _img(1, w: 80, h: 80), const SizedBox(height: 16),
                Text('No entries yet!\nCreate one from Studio 🎨', textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14, color: C.textSub, height: 1.6)),
              ]))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                itemCount: affs.length,
                itemBuilder: (_, i) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: C.pink2, width: 1.2),
                    boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 3))]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('"${affs[i]['text']}"', style: GoogleFonts.lora(fontSize: 15, color: C.textDark, height: 1.6)),
                    const SizedBox(height: 8),
                    Text('${affs[i]['vibe']} • ${(affs[i]['ts'] as String?)?.split('T').first ?? ''}',
                      style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
                  ]),
                ).animate(delay: (i * 50).ms).fadeIn(),
              ),
        ),

        // SETTINGS
        ListView(padding: const EdgeInsets.fromLTRB(24, 16, 24, 120), children: [
          _settingToggle('🔔 Daily Affirmation at 8AM', _notifs, (v) => setState(() => _notifs = v)),
          _settingToggle('📱 Home Screen Widget', false, (_) {}),
          _settingToggle('🌙 Dark Mode', _darkMode, (v) => setState(() => _darkMode = v)),
          const SizedBox(height: 16),
          _settingTile('🎨 Theme', 'Pink Blossom'),
          _settingTile('🌍 Language', 'English'),
          _settingTile('⭐ Rate Us', ''),
          _settingTile('💌 Feedback', ''),
          _settingTile('📤 Share App', ''),
          const SizedBox(height: 28),
          Center(child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: _img(i * 2, w: 36, h: 36)))),
            const SizedBox(height: 14),
            Text('NishAffs v4.0 · Made with 💖 in India', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
          ])),
        ]),
      ])),
    ])),
  );

  Widget _statPill(String val, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(10), border: Border.all(color: C.pink2)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(val, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
      Text(label, style: GoogleFonts.poppins(fontSize: 9, color: C.textSub)),
    ]),
  );

  Widget _settingToggle(String label, bool val, Function(bool) cb) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
    child: Row(children: [
      Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: C.textDark))),
      Switch(value: val, onChanged: cb, activeColor: C.pinkTheme),
    ]),
  );

  Widget _settingTile(String label, String val) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
    child: Row(children: [
      Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: C.textDark))),
      if (val.isNotEmpty) Text(val, style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
      const SizedBox(width: 4),
      const Icon(Icons.chevron_right_rounded, size: 18, color: C.textSub),
    ]),
  );
}

class _Sound { final String name, artist, duration, emoji; final Color bg, accent;
  const _Sound(this.name, this.artist, this.duration, this.emoji, this.bg, this.accent); }

class _SoundCard extends StatelessWidget {
  final _Sound sound; final bool isPlaying; final VoidCallback onTap;
  const _SoundCard({required this.sound, required this.isPlaying, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPlaying ? sound.bg : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPlaying ? sound.accent.withOpacity(0.4) : C.pink2.withOpacity(0.4), width: isPlaying ? 2 : 1.2),
        boxShadow: isPlaying ? [BoxShadow(color: sound.accent.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: sound.bg, borderRadius: BorderRadius.circular(14)),
          child: Center(child: Text(sound.emoji, style: const TextStyle(fontSize: 26)))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(sound.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
          Text('${sound.artist} · ${sound.duration}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
          if (isPlaying) ...[
            const SizedBox(height: 8),
            _WaveWidget(color: sound.accent),
          ],
        ])),
        Container(width: 44, height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: isPlaying ? const LinearGradient(colors: [C.pinkTheme, C.purple]) : null,
            color: isPlaying ? null : C.pink1,
            boxShadow: isPlaying ? [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 8)] : []),
          child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: isPlaying ? Colors.white : C.textDark, size: 24)),
      ]),
    ),
  );
}

class _WaveWidget extends StatefulWidget {
  final Color color;
  const _WaveWidget({required this.color});
  @override
  State<_WaveWidget> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<_WaveWidget> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(); }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => CustomPaint(size: const Size(double.infinity, 18), painter: _WavePainter(_ctrl.value, widget.color)),
  );
}

class _WavePainter extends CustomPainter {
  final double t; final Color color;
  _WavePainter(this.t, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final path = Path();
    final bars = 20;
    for (var i = 0; i < bars; i++) {
      final x = i * (size.width / bars);
      final h = (sin((i / bars * 2 * pi) + (t * 2 * pi)) * 0.4 + 0.6) * size.height;
      canvas.drawLine(Offset(x, size.height / 2 - h / 2), Offset(x, size.height / 2 + h / 2), p);
    }
  }
  @override bool shouldRepaint(_WavePainter o) => true;
}

// ════════════════════════════════════════════════════════════════════
//  MISSING: goldLgt on C (add extension)
// ════════════════════════════════════════════════════════════════════
extension CExtra on C {
  static const goldLgt = Color(0xFFFFF4D1);
  static const mint    = Color(0xFFD1FFE0);
}

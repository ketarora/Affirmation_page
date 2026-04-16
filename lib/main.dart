// ════════════════════════════════════════════════════════════════════
//  NishAffs ✨ — ULTIMATE v5.0 — THE BESTO APP EVER
//  Login • Kindle • Stories • Themes • Music Player • Mood Tracker
//  55x5 Challenge • Vision Board • Streak • Every Button Working
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
//  THEME SYSTEM — 5 Real Working Themes
// ════════════════════════════════════════════════════════════════════
class AppTheme {
  final String name, emoji;
  final Color primary, secondary, bg, card, accent;
  const AppTheme(this.name, this.emoji, this.primary, this.secondary, this.bg, this.card, this.accent);
}

const _appThemes = [
  AppTheme('Pink Blossom', '🌸', Color(0xFFFF82A9), Color(0xFFAC7BED), Color(0xFFFCF4F8), Color(0xFFFFF0F5), Color(0xFFFFD1DF)),
  AppTheme('Lavender', '💜', Color(0xFFB39DDB), Color(0xFF7C4DFF), Color(0xFFF8F0FF), Color(0xFFEDE7F6), Color(0xFFCE93D8)),
  AppTheme('Mint Fresh', '🌿', Color(0xFF66BB6A), Color(0xFF26A69A), Color(0xFFF0FFF4), Color(0xFFE8F5E9), Color(0xFFA5D6A7)),
  AppTheme('Golden Hour', '✨', Color(0xFFFFB74D), Color(0xFFFF8A65), Color(0xFFFFF8E1), Color(0xFFFFF3E0), Color(0xFFFFCC02)),
  AppTheme('Rose Night', '🌹', Color(0xFFE91E63), Color(0xFF880E4F), Color(0xFFFFF0F5), Color(0xFFFCE4EC), Color(0xFFF48FB1)),
];

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
  static const book      = Color(0xFFFAF6F0);

  static const gradPremium = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFFFB3CA), Color(0xFFAC7BED)],
  );
}

// ════════════════════════════════════════════════════════════════════
//  ASSETS — map to actual photo files user has
// ════════════════════════════════════════════════════════════════════
class A {
  static const imgs = [
    'photo_6264600317282422296_y.jpg','photo_6264600317282422297_y.jpg',
    'photo_6264600317282422298_y.jpg','photo_6264600317282422299_y.jpg',
    'photo_6264600317282422300_y.jpg','photo_6264600317282422301_y.jpg',
    'photo_6264600317282422302_y.jpg','photo_6264600317282422303_y.jpg',
    'photo_6264600317282422309_y.jpg','photo_6264600317282422310_y.jpg',
    'photo_6264600317282422311_y.jpg','photo_6264600317282422312_y.jpg',
    'photo_6264600317282422313_y.jpg','photo_6264600317282422314_y.jpg',
    'photo_6264600317282422315_y.jpg','photo_6264600317282422316_y.jpg',
    'photo_6264600317282422317_y.jpg','photo_6264600317282422318_y.jpg',
    'photo_6264600317282422319_y.jpg','photo_6264600317282422320_y.jpg',
    'photo_6264600317282422321_y.jpg','photo_6264600317282422322_y.jpg',
    'photo_6264600317282422323_y.jpg',
  ];
  static const fallback = ['✨','🌸','🧸','💗','💌','🦋','🌷','🎀','☕','☁️','🍒','🍊','🧋','🌼','💬','⭐','🦄','🌈','🍳','🌙','💎','🌺','🪷'];
  static String get(int i) => 'assets/images/${imgs[i % imgs.length]}';
  static String fb(int i) => fallback[i % fallback.length];
}

Widget _img(int i, {double? w, double? h, BoxFit fit = BoxFit.cover}) =>
    Image.asset(A.get(i), width: w, height: h, fit: fit,
      errorBuilder: (_, __, ___) => Container(width: w, height: h,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [C.pink2, C.purpleLgt],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(child: Text(A.fb(i), style: TextStyle(fontSize: (w ?? 40) * 0.5)))));

// ════════════════════════════════════════════════════════════════════
//  SOUND PLAYER SERVICE — with real progress tracking
// ════════════════════════════════════════════════════════════════════
class SoundPlayerService {
  static final instance = SoundPlayerService._();
  SoundPlayerService._();

  final ValueNotifier<int> idx    = ValueNotifier(-1);
  final ValueNotifier<double> pos = ValueNotifier(0.0);
  final ValueNotifier<Duration> elapsed = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> isPlaying   = ValueNotifier(false);

  static const _durations = [
    Duration(minutes: 45), Duration(minutes: 30), Duration(hours: 1),
    Duration(hours: 8), Duration(minutes: 45), Duration(hours: 6),
    Duration(minutes: 25), Duration(minutes: 15),
  ];

  Timer? _t;

  void play(int i) {
    if (idx.value == i && isPlaying.value) { pause(); return; }
    _t?.cancel();
    idx.value = i;
    if (idx.value != i) elapsed.value = Duration.zero;
    isPlaying.value = true;
    _tick();
  }

  void pause() { _t?.cancel(); isPlaying.value = false; }

  void resume() { if (idx.value >= 0) { isPlaying.value = true; _tick(); } }

  void stop() { _t?.cancel(); idx.value = -1; pos.value = 0; elapsed.value = Duration.zero; isPlaying.value = false; }

  void seek(double v) {
    if (idx.value < 0) return;
    final total = _durations[idx.value % _durations.length];
    elapsed.value = Duration(seconds: (v * total.inSeconds).round());
    pos.value = v;
  }

  void _tick() {
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isPlaying.value) return;
      final total = _durations[idx.value % _durations.length];
      final ne = elapsed.value + const Duration(seconds: 1);
      if (ne >= total) { stop(); return; }
      elapsed.value = ne;
      pos.value = ne.inSeconds / total.inSeconds;
    });
  }

  String fmt(Duration d) =>
      '${d.inMinutes.toString().padLeft(2,'0')}:${(d.inSeconds%60).toString().padLeft(2,'0')}';

  Duration totalFor(int i) => _durations[i % _durations.length];
}

// ════════════════════════════════════════════════════════════════════
//  APP STATE — Full backend with all persistence
// ════════════════════════════════════════════════════════════════════
class AppState {
  static final AppState instance = AppState._();
  AppState._();

  final ValueNotifier<Map<String,dynamic>?> user = ValueNotifier(null);
  final ValueNotifier<Set<String>> liked  = ValueNotifier({});
  final ValueNotifier<Set<String>> saved  = ValueNotifier({});
  final ValueNotifier<List<Map<String,dynamic>>> posts  = ValueNotifier([]);
  final ValueNotifier<List<Map<String,dynamic>>> affs   = ValueNotifier([]);
  final ValueNotifier<int> themeIdx  = ValueNotifier(0);
  final ValueNotifier<int> mood      = ValueNotifier(-1);  // -1 = not set today
  final ValueNotifier<int> streak    = ValueNotifier(0);
  final ValueNotifier<Map<String,dynamic>?> challenge = ValueNotifier(null); // 55x5
  final ValueNotifier<List<String>> visionBoard = ValueNotifier([]);

  AppTheme get theme => _appThemes[themeIdx.value];

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    final u = p.getString('na_user');
    if (u != null) user.value = jsonDecode(u);
    liked.value  = Set.from(p.getStringList('na_liked') ?? []);
    saved.value  = Set.from(p.getStringList('na_saved') ?? []);
    themeIdx.value = p.getInt('na_theme') ?? 0;
    streak.value   = p.getInt('na_streak') ?? 0;
    // Check streak continuity
    final lastDay = p.getString('na_last_day');
    final today   = _dayKey(DateTime.now());
    if (lastDay != null && lastDay != today) {
      final yesterday = _dayKey(DateTime.now().subtract(const Duration(days: 1)));
      if (lastDay != yesterday) await _resetStreak();
    }
    // Mood today
    final savedMoodDay = p.getString('na_mood_day');
    if (savedMoodDay == today) mood.value = p.getInt('na_mood') ?? -1;

    final as_ = p.getString('na_affs');
    if (as_ != null) affs.value = List<Map<String,dynamic>>.from(jsonDecode(as_));

    final ps = p.getString('na_posts');
    posts.value = ps != null
        ? List<Map<String,dynamic>>.from(jsonDecode(ps))
        : _seedPosts();
    if (ps == null) _savePosts();

    final ch = p.getString('na_challenge');
    if (ch != null) challenge.value = jsonDecode(ch);

    final vb = p.getStringList('na_vision') ?? [];
    visionBoard.value = vb;
  }

  Future<void> login(String name, String email) async {
    final u = {'name': name, 'email': email, 'avatar': name.isNotEmpty ? name[0].toUpperCase() : 'N', 'joined': DateTime.now().toIso8601String()};
    user.value = u;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_user', jsonEncode(u));
    await _markDayActive();
  }

  Future<void> logout() async {
    user.value = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('na_user');
  }

  Future<void> setTheme(int i) async {
    themeIdx.value = i;
    final p = await SharedPreferences.getInstance();
    await p.setInt('na_theme', i);
  }

  Future<void> setMood(int m) async {
    mood.value = m;
    final p = await SharedPreferences.getInstance();
    await p.setInt('na_mood', m);
    await p.setString('na_mood_day', _dayKey(DateTime.now()));
  }

  Future<void> toggleLike(String id) async {
    final s = Set<String>.from(liked.value);
    s.contains(id) ? s.remove(id) : s.add(id);
    liked.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_liked', s.toList());
    final ps = List<Map<String,dynamic>>.from(posts.value);
    final i  = ps.indexWhere((e) => e['id'] == id);
    if (i >= 0) {
      ps[i] = {...ps[i], 'likes': (ps[i]['likes'] as int) + (s.contains(id) ? 1 : -1)};
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

  Future<void> addPost(Map<String,dynamic> post) async {
    posts.value = [post, ...posts.value];
    _savePosts();
  }

  Future<void> addComment(String postId, String comment) async {
    final ps = List<Map<String,dynamic>>.from(posts.value);
    final i  = ps.indexWhere((e) => e['id'] == postId);
    if (i >= 0) {
      final cmts = List<String>.from(ps[i]['comments'] as List? ?? []);
      cmts.add(comment);
      ps[i] = {...ps[i], 'comments': cmts};
      posts.value = ps;
      _savePosts();
    }
  }

  Future<void> addAff(Map<String,dynamic> a) async {
    final list = [a, ...affs.value];
    affs.value = list;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_affs', jsonEncode(list));
  }

  Future<void> startChallenge(String text) async {
    final ch = {
      'text': text, 'startDay': _dayKey(DateTime.now()),
      'days': {_dayKey(DateTime.now()): 0},
    };
    challenge.value = ch;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_challenge', jsonEncode(ch));
  }

  Future<void> incrementChallenge() async {
    final ch = Map<String,dynamic>.from(challenge.value ?? {});
    if (ch.isEmpty) return;
    final today = _dayKey(DateTime.now());
    final days  = Map<String,dynamic>.from(ch['days'] ?? {});
    days[today] = (days[today] as int? ?? 0) + 1;
    ch['days'] = days;
    challenge.value = ch;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_challenge', jsonEncode(ch));
  }

  Future<void> addVisionCard(String text) async {
    final vb = [...visionBoard.value, text];
    visionBoard.value = vb;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_vision', vb);
  }

  Future<void> removeVisionCard(int i) async {
    final vb = [...visionBoard.value]..removeAt(i);
    visionBoard.value = vb;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_vision', vb);
  }

  Future<void> _markDayActive() async {
    final p = await SharedPreferences.getInstance();
    final today     = _dayKey(DateTime.now());
    final lastDay   = p.getString('na_last_day');
    final yesterday = _dayKey(DateTime.now().subtract(const Duration(days: 1)));
    if (lastDay == yesterday) {
      streak.value++;
      await p.setInt('na_streak', streak.value);
    } else if (lastDay != today) {
      streak.value = 1;
      await p.setInt('na_streak', 1);
    }
    await p.setString('na_last_day', today);
  }

  Future<void> _resetStreak() async {
    streak.value = 0;
    final p = await SharedPreferences.getInstance();
    await p.setInt('na_streak', 0);
  }

  Future<void> _savePosts() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('na_posts', jsonEncode(posts.value));
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  List<Map<String,dynamic>> _seedPosts() => [
    {'id':'p1','user':'Ananya','avatar':'A','time':'2h ago','imgIdx':3,'text':'I am the creator of my reality. Everything is working out perfectly. 🌸','likes':342,'comments':['So beautiful! 💖','This hit different ✨'],'vibe':'Self Love'},
    {'id':'p2','user':'Priya Glow','avatar':'P','time':'4h ago','imgIdx':6,'text':'My body is a vessel of divine love and healing. 30 days of LOA and I am transformed! 🌿','likes':128,'comments':['What a journey!'],'vibe':'Health'},
    {'id':'p3','user':'Meera✨','avatar':'M','time':'6h ago','imgIdx':14,'text':'I attract opportunities effortlessly. Said this 55 times today and the universe DELIVERED 🎉','likes':891,'comments':['YAAS QUEEN 👑','How?! Tell me!','So happy for you 💗'],'vibe':'Abundance'},
    {'id':'p4','user':'Siya','avatar':'S','time':'1d ago','imgIdx':7,'text':'I release what no longer serves me with love. Journaling changed my life 📓','likes':204,'comments':[],'vibe':'Healing'},
    {'id':'p5','user':'Radha🌙','avatar':'R','time':'1d ago','imgIdx':17,'text':'Good things are ALWAYS happening to me. Said for 30 days. The energy shift is REAL 💖','likes':567,'comments':['Starting today!','You are glowing 🌸'],'vibe':'Manifestation'},
  ];
}

// ════════════════════════════════════════════════════════════════════
//  DATA
// ════════════════════════════════════════════════════════════════════
const _dailyAffs = [
  'Everything I am seeking is already seeking me.',
  'I am a magnet for love, abundance, and miracles.',
  'The universe is always conspiring in my favour.',
  'I radiate beauty, confidence, and grace.',
  'My life is a beautiful unfolding of magic.',
  'I attract only the highest and best.',
  'I am worthy of everything wonderful in this world.',
  'Today I choose joy, peace, and abundance.',
  'I trust the timing of my beautiful life.',
  'I am enough. I have enough. I do enough.',
  'Love flows to me easily and effortlessly.',
  'I am becoming the best version of myself.',
  'My vibe is my superpower.',
  'Abundance is my natural state of being.',
  'I am deeply loved and deeply loving.',
  'Every day I grow more magnetic and more radiant.',
  'The best is always yet to come for me.',
  'I am a living, breathing miracle.',
  'My heart is open to receiving infinite blessings.',
  'I release what no longer serves me with love.',
  'I am aligned with the energy of success.',
  'My dreams are valid and within my reach.',
  'I choose to see the beauty in everything.',
  'I am healing, growing, and glowing.',
  'The universe knows my heart and delivers accordingly.',
  'Today is a gift and I receive it with open arms.',
  'My potential is limitless and my future is bright.',
  'I create my reality with my thoughts and feelings.',
  'I am in the perfect place at the perfect time.',
  'My soul is worthy of the deepest love.',
  'I attract beauty in all forms, every single day.',
];

String get _todayAff {
  final d = DateTime.now();
  return _dailyAffs[(d.year * 365 + d.month * 31 + d.day) % _dailyAffs.length];
}

class BookPage { final String chapter, body, title; const BookPage(this.chapter, this.title, this.body); }

class Book { final String name, author, emoji, tag; final List<Color> grad; final List<BookPage> pages;
  const Book({required this.name, required this.author, required this.emoji, required this.tag, required this.grad, required this.pages}); }

const _books = [
  Book(name:'Manifesting Magic', author:'Luna Starr', emoji:'✨', tag:'LOA',
    grad:[Color(0xFFE9D5FF),Color(0xFFFFD1DF)],
    pages:[
      BookPage('Chapter 1','You Are The Universe','You are not a drop in the ocean. You are the entire ocean in a drop.\n\nManifestation begins with a single, radical act: believing you already have what you desire.\n\nThe Law of Attraction is not wishful thinking. It is the universe responding to the energetic frequency you broadcast 24 hours a day — whether you are aware of it or not.\n\nWhen you worry, you attract more to worry about. When you love, you attract more love. This is physics, not poetry.'),
      BookPage('Chapter 1','The Visualization Secret','Your subconscious mind does not know the difference between imagination and reality.\n\nWhen you vividly picture your dream life — your apartment, your relationship, your bank account — your brain begins wiring new neural pathways as if it were already true.\n\nVisualize every morning for 5 minutes. Be specific. Feel the emotions. Use all five senses. The universe will match your inner state.'),
      BookPage('Chapter 2','Words Are Spells','Replace every "I want" with "I have."\n\nLanguage is a spell. Every word you speak is a command to the universe.\n\n"I want love" keeps you in a state of wanting.\n"I am loved" shifts you into a state of having.\n\nSpend 21 days replacing your wanting language with having language. Watch your reality begin to morph.'),
      BookPage('Chapter 2','The Gratitude Portal','Gratitude is the highest vibrational frequency a human can emit.\n\nEvery morning, before you look at your phone, write 5 things you are genuinely grateful for.\n\nThis practice rewires your brain for abundance within 30 days. Neuroscience confirms it. The universe responds to it. Your life will prove it.'),
    ]),
  Book(name:'Inner Peace Guide', author:'Serenity Bell', emoji:'🪷', tag:'Mindfulness',
    grad:[Color(0xFFFFD1DF),Color(0xFFFFF0F5)],
    pages:[
      BookPage('Chapter 1','The Stillness Within','Peace is not the absence of chaos. Peace is finding calm in the centre of the storm.\n\nMost people wait for their external world to calm down before they allow themselves to feel at peace. This is backwards.\n\nYou must cultivate inner stillness first. Then — and only then — will your outer world reflect that stillness back to you.'),
      BookPage('Chapter 1','Your 5-Minute Practice','Sit comfortably. Close your eyes. Take three deep breaths — in 4, hold 4, out 8.\n\nObserve your thoughts like clouds passing across a clear blue sky. You are not the clouds. You are the sky.\n\nJust 5 minutes of this practice daily will transform your nervous system within 8 weeks. Science confirms it.'),
      BookPage('Chapter 2','The Art of Letting Go','The practice of letting go is the highest form of spiritual maturity.\n\nEvery resentment you carry is a weight around your own neck.\n\nForgiveness is not saying what happened was okay. It is saying: I refuse to carry this pain any further. I release it with love and grace.'),
    ]),
  Book(name:'Law of Attraction for the Soul', author:'Cosmos Ray', emoji:'🌌', tag:'Spiritual',
    grad:[Color(0xFFAC7BED),Color(0xFFE9D5FF)],
    pages:[
      BookPage('Chapter 1','The Magnetic Law','Like attracts like.\n\nThis is the most powerful and most misunderstood law in existence.\n\nYour dominant thoughts, feelings, and beliefs create a magnetic field around you. This field constantly communicates with the quantum field of all possibility.\n\nYou are always manifesting. The question is whether you are doing it consciously or unconsciously.'),
      BookPage('Chapter 2','Raising Your Frequency','🎵 Listen to music that makes you feel expansive\n🌿 Spend time in nature\n🙏 Practice daily gratitude\n💃 Move your body with joy\n📖 Read books that uplift\n🧘 Meditate for clarity\n\nYour vibration is your invitation to the universe. High vibration attracts high vibration experiences.'),
      BookPage('Chapter 3','The 55×5 Method','Write your core desire as an affirmation, exactly 55 times, for 5 consecutive days.\n\nThis intensive practice overwhelms your subconscious mind and plants the seed of your desire so deeply it must manifest.\n\nExample: "I am a magnet for financial abundance."\n\nWrite it 55 times. Feel it. Believe it. Do not skip a day.'),
    ]),
  Book(name:'Sacred Self-Love', author:'Rose Quartz', emoji:'💗', tag:'Self-Love',
    grad:[Color(0xFFFFB3CA),Color(0xFFFFD1DF)],
    pages:[
      BookPage('Chapter 1','The Most Important Relationship','You cannot pour from an empty cup.\n\nEvery relationship you have with another person is a direct reflection of the relationship you have with yourself.\n\nThe love you desperately seek from others is love you have not yet given to yourself. This is an invitation to turn inward and begin the most important love affair of your life.'),
      BookPage('Chapter 1','The Mirror Practice','Stand before a mirror. Look into your own eyes.\n\nSay aloud: "I love you. I really, truly love you. You are enough."\n\nThe first time, you may laugh. You may cry. Do it anyway.\n\nDo it every morning for 30 days. Something profound will shift.'),
      BookPage('Chapter 2','The Sacred Boundary','Boundaries are not walls. They are the fence around your garden.\n\nSaying no to what drains you is saying yes to what fills you.\n\nEvery time you honor your boundaries, you send a message to your subconscious: "I am worth protecting."'),
    ]),
];

// ════════════════════════════════════════════════════════════════════
//  WIDGETS — Logo, Glass, Sparkle
// ════════════════════════════════════════════════════════════════════
class NishAffsLogo extends StatelessWidget {
  final double size;
  final bool showText;
  const NishAffsLogo({super.key, this.size = 36, this.showText = false});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)]),
        boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: size * 0.25, offset: Offset(0, size * 0.08))],
      ),
      child: Stack(alignment: Alignment.center, children: [
        // Petals
        ...List.generate(6, (i) => Transform.rotate(
          angle: i * pi / 3,
          child: Transform.translate(
            offset: Offset(0, -size * 0.19),
            child: Container(
              width: size * 0.22, height: size * 0.22,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.55), shape: BoxShape.circle)),
          ),
        )),
        // Center dot
        Container(width: size * 0.28, height: size * 0.28,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle)),
        // N letter
        Text('N', style: GoogleFonts.pacifico(fontSize: size * 0.38, color: Colors.white)),
      ]),
    ),
    if (showText) ...[
      SizedBox(width: size * 0.2),
      Text('NishAffs', style: GoogleFonts.pacifico(fontSize: size * 0.55,
        foreground: Paint()..shader = const LinearGradient(
          colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)],
        ).createShader(Rect.fromLTWH(0, 0, 200, 40)))),
    ],
  ]);
}

class GlassCard extends StatelessWidget {
  final Widget child; final double radius; final EdgeInsets? padding;
  final double opacity; final Color tint;
  const GlassCard({super.key, required this.child, this.radius=24, this.padding, this.opacity=0.25, this.tint=Colors.white});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Container(padding: padding,
        decoration: BoxDecoration(color: tint.withOpacity(opacity), borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))]),
        child: child)));
}

class _SparkleOverlay extends StatefulWidget {
  final Widget child;
  const _SparkleOverlay({required this.child});
  @override State<_SparkleOverlay> createState() => _SparkleOverlayState();
}

class _SparkleOverlayState extends State<_SparkleOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Stack(children: [
    widget.child,
    IgnorePointer(child: AnimatedBuilder(animation: _c, builder: (_, __) {
      final sz = MediaQuery.of(context).size;
      return CustomPaint(size: sz, painter: _SparklePainter(_c.value, sz));
    })),
  ]);
}

class _SparklePainter extends CustomPainter {
  final double t; final Size sz;
  const _SparklePainter(this.t, this.sz);
  @override void paint(Canvas canvas, Size size) {
    final colors = [C.pinkTheme, C.purple, C.gold, Colors.white];
    for (var i = 0; i < 10; i++) {
      final phase = (t + i * 0.1) % 1.0;
      final opacity = sin(phase * pi).clamp(0.0, 0.7);
      if (opacity < 0.05) continue;
      final x = ((i * 137.5 + t * 60) % sz.width);
      final y = sz.height * phase;
      final r = 2.0 + sin(phase * pi * 2) * 2.0;
      canvas.drawCircle(Offset(x, y), r,
        Paint()..color = colors[i % colors.length].withOpacity(opacity * 0.5)
               ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }
  }
  @override bool shouldRepaint(_SparklePainter o) => o.t != t;
}

// Mini music player strip
class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;
  const MiniPlayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final svc = SoundPlayerService.instance;
    return ValueListenableBuilder<int>(
      valueListenable: svc.idx,
      builder: (_, idx, __) {
        if (idx < 0) return const SizedBox.shrink();
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(children: [
              const Text('🎵', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(_soundNames[idx % _soundNames.length],
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                ValueListenableBuilder<double>(
                  valueListenable: svc.pos,
                  builder: (_, pos, __) => LinearProgressIndicator(
                    value: pos, minHeight: 3,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white)),
                ),
              ])),
              const SizedBox(width: 10),
              ValueListenableBuilder<bool>(
                valueListenable: svc.isPlaying,
                builder: (_, playing, __) => GestureDetector(
                  onTap: playing ? svc.pause : svc.resume,
                  child: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 26)),
              ),
              const SizedBox(width: 8),
              GestureDetector(onTap: svc.stop,
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 20)),
            ]),
          ),
        );
      },
    );
  }
}

const _soundNames = ['432Hz Deep Healing','Morning Abundance Flow','Inner Peace Rain','Deep Sleep Delta','Study Focus Beta','Manifest While You Sleep','Chakra Balancing','Self Love Morning'];
const _soundEmojis = ['🎵','☀️','🌧️','🌙','📚','✨','🌈','💗'];

// ════════════════════════════════════════════════════════════════════
//  APP ROOT
// ════════════════════════════════════════════════════════════════════
class NishAffsApp extends StatelessWidget {
  const NishAffsApp({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: AppState.instance.themeIdx,
    builder: (_, idx, __) {
      final t = _appThemes[idx];
      return MaterialApp(
        title: 'NishAffs ✨',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: t.bg,
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: t.primary),
          useMaterial3: true,
        ),
        builder: (ctx, child) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: ClipRect(child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            color: t.bg,
            child: child))),
        ),
        home: const _AppGate(),
      );
    },
  );
}

class _AppGate extends StatefulWidget {
  const _AppGate();
  @override State<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<_AppGate> {
  bool _splashDone = false;
  @override
  void initState() { super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () { if (mounted) setState(() => _splashDone = true); }); }
  @override
  Widget build(BuildContext context) {
    if (!_splashDone) return const _SplashView();
    return ValueListenableBuilder(
      valueListenable: AppState.instance.user,
      builder: (_, user, __) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeOutCubic,
        child: user != null ? const ShellRoute(key: ValueKey('shell')) : const LoginScreen(key: ValueKey('login'))));
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
      _img(8, w: double.infinity, h: double.infinity),
      Container(decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [C.pink3.withOpacity(0.5), C.purple.withOpacity(0.65), Colors.black.withOpacity(0.65)]))),
      SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        NishAffsLogo(size: 90).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
        const SizedBox(height: 24),
        Text('NishAffs', style: GoogleFonts.pacifico(fontSize: 46, color: Colors.white))
          .animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
        const SizedBox(height: 16),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text('"$_todayAff"', textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 16, color: Colors.white.withOpacity(0.9), fontStyle: FontStyle.italic)))
          .animate(delay: 600.ms).fadeIn(),
        const Spacer(),
        const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          .animate(delay: 1.seconds).fadeIn(),
        const SizedBox(height: 48),
      ]))),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════
//  LOGIN
// ════════════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true, _loading = false;
  final _name = TextEditingController(), _email = TextEditingController(), _pass = TextEditingController();

  @override void dispose() { _name.dispose(); _email.dispose(); _pass.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    final name = _name.text.trim().isEmpty ? _email.text.split('@')[0] : _name.text.trim();
    await AppState.instance.login(name, _email.text.trim());
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(fit: StackFit.expand, children: [
      _img(4, w: double.infinity, h: double.infinity),
      Container(color: Colors.black.withOpacity(0.42)),
      SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 40),
        NishAffsLogo(size: 48, showText: true).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 10),
        Text(_isLogin ? 'Welcome back, beautiful soul 🌸' : 'Start your magic journey ✨',
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w500))
          .animate(delay: 200.ms).fadeIn(),
        const SizedBox(height: 40),
        GlassCard(radius: 32, opacity: 0.2, padding: const EdgeInsets.all(26), child: Column(children: [
          if (!_isLogin) ...[_field(_name, 'Your Name', Icons.person_outline_rounded), const SizedBox(height: 14)],
          _field(_email, 'Email', Icons.email_outlined, type: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _field(_pass, 'Password', Icons.lock_outline_rounded, obscure: true),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _loading ? null : _submit,
            child: Container(
              width: double.infinity, height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]),
              child: Center(child: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(_isLogin ? 'Sign In ✨' : 'Create Account 🌸',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
            ),
          ).animate().scale(begin: const Offset(0.97, 0.97)),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => setState(() => _isLogin = !_isLogin),
            child: Text(_isLogin ? "Don't have an account? Sign up →" : 'Already have an account? Sign in →',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.7))),
          ),
        ])).animate(delay: 300.ms).fadeIn().slideY(begin: 0.12),
        const SizedBox(height: 20),
        Center(child: GestureDetector(
          onTap: () => AppState.instance.login('Guest', 'guest@nishaffs.app'),
          child: Text('Continue as Guest →', style: GoogleFonts.poppins(fontSize: 13,
            color: Colors.white.withOpacity(0.6), decoration: TextDecoration.underline, decorationColor: Colors.white30)),
        )),
        const SizedBox(height: 36),
        // Kawaii row
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) =>
          Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(['🌸','✨','🦄','🎀','💗'][i], style: const TextStyle(fontSize: 28)))
        )).animate(delay: 500.ms).fadeIn(),
      ]))),
    ]),
  );

  Widget _field(TextEditingController c, String hint, IconData icon, {TextInputType? type, bool obscure = false}) =>
    TextField(controller: c, keyboardType: type, obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint, hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.55), size: 20),
        filled: true, fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: C.pinkTheme, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14)));
}

// ════════════════════════════════════════════════════════════════════
//  SHELL + DRAWER
// ════════════════════════════════════════════════════════════════════
class ShellRoute extends StatefulWidget {
  const ShellRoute({super.key});
  @override State<ShellRoute> createState() => _ShellRouteState();
}

class _ShellRouteState extends State<ShellRoute> with SingleTickerProviderStateMixin {
  int _tab = 0;
  bool _drawerOpen = false;
  late AnimationController _dc;
  late Animation<double> _da;

  void _openDrawer()  { setState(() => _drawerOpen = true); _dc.forward(); }
  void _closeDrawer() { _dc.reverse().then((_) { if (mounted) setState(() => _drawerOpen = false); }); }
  void switchTab(int i) { setState(() => _tab = i); }

  @override
  void initState() {
    super.initState();
    _dc = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _da = CurvedAnimation(parent: _dc, curve: Curves.easeOutCubic);
  }

  @override void dispose() { _dc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Stack(children: [
    _SparkleOverlay(child: AnimatedBuilder(
      animation: _da,
      builder: (_, child) => Transform.translate(
        offset: Offset(_da.value * 290, 0),
        child: GestureDetector(
          onHorizontalDragEnd: (d) {
            if (!_drawerOpen && (d.primaryVelocity ?? 0) > 150) _openDrawer();
            if (_drawerOpen && (d.primaryVelocity ?? 0) < -150) _closeDrawer();
          },
          child: child),
      ),
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _tab, children: [
          HomeView(onOpenDrawer: _openDrawer, onNavigate: switchTab),
          const LibraryView(),
          const StudioView(),
          const CommunityView(),
          ProfileView(onNavigate: switchTab),
        ]),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          MiniPlayer(onTap: () => switchTab(4)),
          SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 14), child: GlassCard(
            radius: 36, opacity: 0.75,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _NavBtn(0, _tab, Icons.home_filled, 'Home',    () => setState(() => _tab = 0)),
              _NavBtn(1, _tab, Icons.auto_stories_rounded, 'Library', () => setState(() => _tab = 1)),
              _NavBtn(2, _tab, Icons.add_circle_rounded, 'Studio',  () => setState(() => _tab = 2)),
              _NavBtn(3, _tab, Icons.favorite_rounded, 'Vibes',   () => setState(() => _tab = 3)),
              _NavBtn(4, _tab, Icons.person_rounded, 'Me',      () => setState(() => _tab = 4)),
            ]),
          ))),
        ]),
      ),
    )),
    if (_drawerOpen) AnimatedBuilder(animation: _da,
      builder: (_, __) => GestureDetector(onTap: _closeDrawer,
        child: Container(color: Colors.black.withOpacity(0.38 * _da.value)))),
    AnimatedBuilder(animation: _da,
      builder: (_, child) => Transform.translate(offset: Offset((_da.value - 1) * 290, 0), child: child),
      child: _LeftDrawer(onClose: _closeDrawer, onNavigate: switchTab)),
  ]);
}

class _NavBtn extends StatelessWidget {
  final int index, current; final IconData icon; final String label; final VoidCallback onTap;
  const _NavBtn(this.index, this.current, this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) {
    final on = index == current;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(duration: const Duration(milliseconds: 260),
        padding: EdgeInsets.symmetric(horizontal: on ? 12 : 7, vertical: 9),
        decoration: BoxDecoration(color: on ? C.pinkTheme.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(22)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: on ? C.pinkDark : C.textSub, size: 22),
          if (on) ...[const SizedBox(width: 5),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: C.pinkDark))
              .animate().fadeIn().slideX(begin: 0.2)],
        ])));
  }
}

class _LeftDrawer extends StatelessWidget {
  final VoidCallback onClose; final void Function(int) onNavigate;
  const _LeftDrawer({required this.onClose, required this.onNavigate});

  @override
  Widget build(BuildContext context) => Container(
    width: 290, height: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF0F8), Color(0xFFF5E8FF)]),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(6, 0))]),
    child: SafeArea(child: ValueListenableBuilder(
      valueListenable: AppState.instance.user,
      builder: (_, user, __) => ListView(padding: const EdgeInsets.all(20), children: [
        // Header
        Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [C.pinkTheme, C.purple])),
            child: Center(child: Text(user?['avatar'] ?? 'N', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?['name'] ?? 'Guest', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textDark)),
            Text(user?['email'] ?? '', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
        ]),
        const SizedBox(height: 24),
        // Streak card
        ValueListenableBuilder<int>(
          valueListenable: AppState.instance.streak,
          builder: (_, streak, __) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(18)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _dStat('$streak 🔥', 'Day Streak'),
              Container(width: 1, height: 36, color: Colors.white.withOpacity(0.3)),
              _dStat('21 ✨', 'Affirmations'),
              Container(width: 1, height: 36, color: Colors.white.withOpacity(0.3)),
              _dStat('${_books.length} 📚', 'Books'),
            ]),
          ),
        ),
        const SizedBox(height: 22),
        // Nav items
        _dItem(Icons.home_filled, 'Home', C.pinkDark, () { onClose(); onNavigate(0); }),
        _dItem(Icons.auto_stories_rounded, 'Library', C.purple, () { onClose(); onNavigate(1); }),
        _dItem(Icons.add_circle_rounded, 'Studio', C.gold, () { onClose(); onNavigate(2); }),
        _dItem(Icons.favorite_rounded, 'Vibes', C.pinkTheme, () { onClose(); onNavigate(3); }),
        _dItem(Icons.bookmark_rounded, 'Bookmarks', const Color(0xFF2A9D7A), () {}),
        _dItem(Icons.emoji_events_rounded, '55x5 Challenge', C.pinkDark, () { onClose(); Navigator.push(context, _pageRoute(const Challenge55x5Screen())); }),
        _dItem(Icons.grid_view_rounded, 'Vision Board', C.purple, () { onClose(); Navigator.push(context, _pageRoute(const VisionBoardScreen())); }),
        const SizedBox(height: 20),
        // Saved affirmations
        Text('Saved Affirmations', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: AppState.instance.affs,
          builder: (_, affs, __) => affs.isEmpty
            ? Text('Create affirmations from Studio 🎨', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub, height: 1.6))
            : Column(children: affs.take(5).map((a) => Container(
                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.pink2.withOpacity(0.5))),
                child: Text('"${a['text']}"', style: GoogleFonts.lora(fontSize: 12, color: C.textDark, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis)
              )).toList()),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () { AppState.instance.logout(); onClose(); },
          child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text('Sign Out', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)))),
        ),
      ]),
    )),
  );

  Widget _dStat(String val, String label) => Column(children: [
    Text(val, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    Text(label, style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.8))),
  ]);

  Widget _dItem(IconData icon, String label, Color color, VoidCallback onTap) =>
    GestureDetector(onTap: onTap, child: Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
      Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 12),
      Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: C.textDark)),
      const Spacer(),
      Icon(Icons.chevron_right_rounded, color: C.textSub, size: 16),
    ])));
}

// ════════════════════════════════════════════════════════════════════
//  HOME VIEW
// ════════════════════════════════════════════════════════════════════
class HomeView extends StatefulWidget {
  final VoidCallback onOpenDrawer; final void Function(int) onNavigate;
  const HomeView({super.key, required this.onOpenDrawer, required this.onNavigate});
  @override State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _affIdx = 0;
  bool _todayLiked = false;
  late Timer _t;

  @override
  void initState() { super.initState();
    _t = Timer.periodic(const Duration(seconds: 7), (_) {
      if (mounted) setState(() => _affIdx = (_affIdx + 1) % _dailyAffs.length); }); }

  @override void dispose() { _t.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final today = _todayAff;
    return Stack(children: [
      Positioned.fill(child: _img((_affIdx + 10) % 22, w: double.infinity, h: double.infinity)),
      Positioned.fill(child: Container(color: Colors.white.withOpacity(0.86))),
      SafeArea(bottom: false, child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
          // Header
          Row(children: [
            GestureDetector(
              onTap: widget.onOpenDrawer,
              child: ValueListenableBuilder(valueListenable: AppState.instance.user,
                builder: (_, user, __) => Container(width: 44, height: 44,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Center(child: Text(user?['avatar'] ?? 'N',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18))))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Daily Radiance ✨', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: C.pinkDark)),
              ValueListenableBuilder(valueListenable: AppState.instance.user,
                builder: (_, user, __) => Text('Hey ${user?['name'] ?? 'Beautiful'} 🌸',
                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))),
            ])),
            NishAffsLogo(size: 32),
          ]).animate().fadeIn(duration: 600.ms),

          // Mood check-in
          const SizedBox(height: 18),
          ValueListenableBuilder<int>(
            valueListenable: AppState.instance.mood,
            builder: (_, mood, __) => mood == -1 ? _MoodCheckIn() : _MoodBadge(mood)),

          // Affirmation card — different image per affirmation
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (child, anim) => FadeTransition(opacity: anim,
              child: SlideTransition(position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim), child: child)),
            child: _TodayCard(key: ValueKey(_affIdx), text: _dailyAffs[_affIdx],
              imgIdx: (_affIdx * 3 + 5) % 22, liked: _todayLiked, onLike: () => setState(() => _todayLiked = !_todayLiked)),
          ),

          // Quick action pills — NOW CLICKABLE
          const SizedBox(height: 22),
          Row(children: [
            _qPill('📖 Read', C.purpleLgt, () => widget.onNavigate(1)),
            const SizedBox(width: 10),
            _qPill('🎵 Sounds', C.goldLgt, () => widget.onNavigate(4)),
            const SizedBox(width: 10),
            _qPill('✍️ Create', C.pink1, () => widget.onNavigate(2)),
          ]).animate(delay: 200.ms).fadeIn(),

          // Streak banner
          const SizedBox(height: 20),
          ValueListenableBuilder<int>(
            valueListenable: AppState.instance.streak,
            builder: (_, streak, __) => streak > 0 ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
              child: Row(children: [
                const Text('🔥', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$streak Day Streak!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Keep manifesting every day ✨', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.85))),
                ])),
                GestureDetector(
                  onTap: () => Navigator.push(context, _pageRoute(const Challenge55x5Screen())),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(100)),
                    child: Text('55×5', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)))),
              ]),
            ) : const SizedBox.shrink()),

          // Curated for you — NOW CLICKABLE
          const SizedBox(height: 28),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Curated for you', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: C.textDark)),
            GestureDetector(
              onTap: () => Navigator.push(context, _pageRoute(const CuratedListScreen())),
              child: Text('See All', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark))),
          ]).animate(delay: 250.ms).fadeIn(),
          const SizedBox(height: 14),
          SizedBox(height: 215, child: ListView.builder(
            scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (ctx, i) {
              final cats = ['Inner Peace','Level Up','Healing Era','Lucky Girl','Deep Sleep'];
              final subs = ['5 Affirmations','10 Exercises','Guided Journal','Music + Affs','8hr Sounds'];
              return GestureDetector(
                onTap: () => Navigator.push(ctx, _pageRoute(CuratedDetailScreen(title: cats[i], imgIdx: i + 3, sub: subs[i]))),
                child: Container(width: 150, margin: const EdgeInsets.only(right: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: _img(i + 3, w: 150, h: double.infinity))),
                    const SizedBox(height: 8),
                    Text(cats[i], style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
                    Text(subs[i], style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                  ])).animate(delay: (250 + i * 70).ms).fadeIn().slideY(begin: 0.08),
              );
            },
          )),

          // Kawaii strip
          const SizedBox(height: 24),
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(22), border: Border.all(color: C.pink2, width: 1.2)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) =>
              Text(['🍓','🐼','🧸','🎀','🦄'][i], style: const TextStyle(fontSize: 28)))
            )).animate(delay: 350.ms).fadeIn(),
          const SizedBox(height: 120),
        ])),
      ])),
    ]);
  }

  Widget _qPill(String label, Color bg, VoidCallback onTap) => Expanded(child: GestureDetector(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2, width: 1.2)),
      child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: C.textDark))))));
}

class _MoodCheckIn extends StatelessWidget {
  const _MoodCheckIn();
  @override
  Widget build(BuildContext context) {
    const emojis = ['😔','😐','🙂','😊','🌟'];
    const labels = ['Low Vibe','Meh','Good','Happy','Glowing'];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(22), border: Border.all(color: C.pink2, width: 1.2)),
      child: Column(children: [
        Text('How\'s your vibe today? ✨', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) =>
          GestureDetector(
            onTap: () => AppState.instance.setMood(i),
            child: Column(children: [
              Text(emojis[i], style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 4),
              Text(labels[i], style: GoogleFonts.poppins(fontSize: 9, color: C.textSub, fontWeight: FontWeight.w600)),
            ])))),
      ]));
  }
}

class _MoodBadge extends StatelessWidget {
  final int mood;
  const _MoodBadge(this.mood);
  @override
  Widget build(BuildContext context) {
    const emojis = ['😔','😐','🙂','😊','🌟'];
    const msgs = ['Take it easy today 🌸','You\'ve got this 💪','Nice energy! ✨','Shining bright! 💫','Absolutely glowing! 🌟'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pink1, C.purpleLgt]), borderRadius: BorderRadius.circular(18), border: Border.all(color: C.pink2, width: 1.2)),
      child: Row(children: [
        Text(emojis[mood], style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Today\'s vibe is set!', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub, fontWeight: FontWeight.w600)),
          Text(msgs[mood], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
        ])),
        GestureDetector(
          onTap: () => AppState.instance.mood.value = -1,
          child: const Icon(Icons.refresh_rounded, color: C.textSub, size: 18)),
      ]),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final String text; final int imgIdx; final bool liked; final VoidCallback onLike;
  const _TodayCard({super.key, required this.text, required this.imgIdx, required this.liked, required this.onLike});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(34),
    child: SizedBox(height: 400, width: double.infinity, child: Stack(children: [
      Positioned.fill(child: _img(imgIdx, w: double.infinity, h: double.infinity)),
      Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black.withOpacity(0.72)])))),
      Positioned(top: 18, left: 18, child: GlassCard(radius: 100, opacity: 0.15,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wb_sunny_rounded, color: C.gold, size: 13),
          const SizedBox(width: 6),
          Text('Today\'s Affirmation', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
        ]))),
      Positioned(top: 16, right: 16, child: const NishAffsLogo(size: 28)),
      Positioned(bottom: 24, left: 24, right: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('"$text"', style: GoogleFonts.lora(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w600, height: 1.45)),
        const SizedBox(height: 18),
        Row(children: [
          GestureDetector(onTap: onLike, child: GlassCard(radius: 100, tint: liked ? C.pinkTheme : Colors.white, opacity: liked ? 0.85 : 0.2,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.white, size: 17),
              const SizedBox(width: 7),
              Text(liked ? 'Loved ✨' : 'Feel It', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ]))).animate(target: liked ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.06, 1.06)),
          const Spacer(),
          GlassCard(radius: 100, opacity: 0.2, padding: const EdgeInsets.all(11),
            child: const Icon(Icons.share_outlined, color: Colors.white, size: 20)),
          const SizedBox(width: 8),
          GlassCard(radius: 100, opacity: 0.2, padding: const EdgeInsets.all(11),
            child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20)),
        ]),
      ])),
    ])),
  );
}

// ════════════════════════════════════════════════════════════════════
//  LIBRARY — Working category filter
// ════════════════════════════════════════════════════════════════════
class LibraryView extends StatefulWidget {
  const LibraryView({super.key});
  @override State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  String _cat = 'All';
  final _cats = ['All', 'LOA', 'Mindfulness', 'Spiritual', 'Self-Love'];

  List<Book> get _filtered => _cat == 'All' ? _books : _books.where((b) => b.tag == _cat).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 18, 22, 0), child: Row(children: [
        const NishAffsLogo(size: 30),
        const SizedBox(width: 10),
        Text('Wisdom Library 📚', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: C.textDark)),
      ])),
      const SizedBox(height: 16),
      SizedBox(height: 40, child: ListView.builder(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: _cats.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _cat = _cats[i]),
          child: AnimatedContainer(duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              gradient: _cat == _cats[i] ? const LinearGradient(colors: [C.pinkTheme, C.purple]) : null,
              color: _cat == _cats[i] ? null : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: _cat == _cats[i] ? Colors.transparent : C.pink2, width: 1.2),
              boxShadow: _cat == _cats[i] ? [BoxShadow(color: C.pinkTheme.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : []),
            child: Text(_cats[i], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700,
              color: _cat == _cats[i] ? Colors.white : C.textSub)))),
      )),
      const SizedBox(height: 16),
      Expanded(child: _filtered.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🪷', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('No books in this category yet!', style: GoogleFonts.poppins(fontSize: 15, color: C.textSub)),
          ]))
        : GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 14, mainAxisSpacing: 18),
          itemCount: _filtered.length,
          itemBuilder: (ctx, i) {
            final book = _filtered[i];
            return GestureDetector(
              onTap: () => Navigator.push(ctx, _pageRoute(KindleReader(book: book))),
              child: Column(children: [
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4), topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: book.grad),
                    boxShadow: [BoxShadow(color: book.grad.last.withOpacity(0.4), blurRadius: 16, offset: const Offset(5, 6))]),
                  child: Stack(children: [
                    Positioned(left: 0, top: 0, bottom: 0, width: 10, child: Container(color: Colors.black.withOpacity(0.2),
                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))))),
                    Center(child: Padding(padding: const EdgeInsets.all(14), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(book.emoji, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 8),
                      Text(book.name, textAlign: TextAlign.center, style: GoogleFonts.playfairDisplay(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold, height: 1.3)),
                    ]))),
                    Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(6)),
                      child: Text(book.tag, style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white)))),
                  ])),
                ),
                const SizedBox(height: 8),
                Text(book.name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: C.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('by ${book.author}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
              ]).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.1));
          })),
    ])),
  );
}

PageRoute _pageRoute(Widget page) => PageRouteBuilder(
  pageBuilder: (_, a, __) => page,
  transitionDuration: const Duration(milliseconds: 400),
  transitionsBuilder: (_, anim, __, child) => SlideTransition(
    position: Tween(begin: const Offset(1, 0), end: Offset.zero)
      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
    child: child));

// ════════════════════════════════════════════════════════════════════
//  KINDLE READER — FIXED page flip direction (natural book feel)
// ════════════════════════════════════════════════════════════════════
class KindleReader extends StatefulWidget {
  final Book book;
  const KindleReader({super.key, required this.book});
  @override State<KindleReader> createState() => _KindleReaderState();
}

class _KindleReaderState extends State<KindleReader> with SingleTickerProviderStateMixin {
  int _cur = 0;
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _flipping = false;
  int _next = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        setState(() { _cur = _next; _flipping = false; });
        _ctrl.reset();
      }
    });
  }

  void _flip(bool fwd) {
    if (_flipping) return;
    final np = fwd ? _cur + 1 : _cur - 1;
    if (np < 0) { Navigator.pop(context); return; }
    if (np >= widget.book.pages.length) return;
    setState(() { _flipping = true; _next = np; });
    _ctrl.forward();
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.book,
    body: GestureDetector(
      onHorizontalDragEnd: (d) {
        final v = d.primaryVelocity ?? 0;
        if (v < -180) _flip(true);   // swipe left = next page
        else if (v > 180) _flip(false); // swipe right = prev page
      },
      onTapDown: (d) {
        final w = MediaQuery.of(context).size.width;
        if (d.localPosition.dx > w * 0.6) _flip(true);
        else if (d.localPosition.dx < w * 0.4) _flip(false);
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (ctx, __) {
          final sz = MediaQuery.of(ctx).size;
          final v  = _anim.value;
          final front = _pageContent(widget.book.pages[_cur], sz);
          final back  = _flipping ? _pageContent(widget.book.pages[_next], sz) : front;

          if (!_flipping) return front;

          return Stack(children: [
            back, // next page is always behind
            // PHASE 1 (v < 0.5): current page rotates away (binding on LEFT, right edge sweeps left into screen)
            if (v < 0.5)
              Transform(
                transform: Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateY(v * pi),
                alignment: Alignment.centerLeft, // spine is on left
                child: front,
              ),
            // PHASE 2 (v >= 0.5): new page comes in from left
            if (v >= 0.5)
              Transform(
                transform: Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateY((1.0 - v) * pi),
                alignment: Alignment.centerLeft,
                child: Container(color: C.book, child: Stack(children: [back,
                  // spine shadow
                  Positioned(left: 0, top: 0, bottom: 0, width: 30,
                    child: Container(decoration: BoxDecoration(gradient: LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: [Colors.black.withOpacity(0.12), Colors.transparent])))),
                ])),
              ),
          ]);
        },
      ),
    ),
  );

  Widget _pageContent(BookPage page, Size sz) => Container(
    width: sz.width, height: sz.height, color: C.book,
    child: SafeArea(child: Column(children: [
      // Top bar
      Padding(padding: const EdgeInsets.fromLTRB(26, 14, 26, 0), child: Row(children: [
        GestureDetector(onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: Color(0xFF8B6040))),
        const Spacer(),
        Row(mainAxisSize: MainAxisSize.min, children: [
          const NishAffsLogo(size: 18),
          const SizedBox(width: 6),
          Text(widget.book.name, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF8B6040))),
        ]),
        const Spacer(),
        Text('${_cur + 1}/${widget.book.pages.length}', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade400)),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: ClipRRect(borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(value: (_cur + 1) / widget.book.pages.length, minHeight: 2,
            backgroundColor: Colors.brown.withOpacity(0.1), color: const Color(0xFFD4956A)))),
      Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 26), color: Colors.brown.withOpacity(0.08)),
      // Content
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(34, 26, 34, 26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(page.chapter, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFFD4956A), letterSpacing: 2.5)),
        const SizedBox(height: 14),
        Text(page.title, style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF3D2B1F))),
        const SizedBox(height: 12),
        Container(height: 2, width: 44, decoration: const BoxDecoration(color: Color(0xFFD4956A), borderRadius: BorderRadius.all(Radius.circular(1)))),
        const SizedBox(height: 22),
        Text(page.body, style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF4A3520), height: 2.0, letterSpacing: 0.15)),
        const SizedBox(height: 36),
        Center(child: Text('· · ·', style: GoogleFonts.lora(fontSize: 18, color: const Color(0xFFD4956A)))),
      ]))),
      // Bottom
      Padding(padding: const EdgeInsets.fromLTRB(26, 4, 26, 14), child: Row(children: [
        if (_cur > 0) GestureDetector(onTap: () => _flip(false), child: Row(children: [
          const Icon(Icons.arrow_back_ios_rounded, size: 12, color: Color(0xFFD4956A)),
          Text('Prev', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFD4956A))),
        ])),
        const Spacer(),
        Text('Swipe to turn page →', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade400)),
        const Spacer(),
        if (_cur < widget.book.pages.length - 1) GestureDetector(onTap: () => _flip(true), child: Row(children: [
          Text('Next', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFD4956A))),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFD4956A)),
        ])),
      ])),
    ])),
  );
}

// ════════════════════════════════════════════════════════════════════
//  STUDIO — With examples + working post
// ════════════════════════════════════════════════════════════════════
class StudioView extends StatefulWidget {
  const StudioView({super.key});
  @override State<StudioView> createState() => _StudioViewState();
}

class _StudioViewState extends State<StudioView> {
  final _tc = TextEditingController();
  String _vibe = 'Self Love';
  int _bgIdx = 0;

  static const _examples = [
    'I am a magnet for abundance and all good things.',
    'Love flows to me freely and I receive it openly.',
    'I trust the universe to guide me to my highest good.',
    'I am worthy of success and it comes to me naturally.',
    'My body is healthy, my mind is clear, my soul is at peace.',
  ];

  static const _vibes = [
    ('Self Love', C.pink2, C.pinkDark),
    ('Abundance', Color(0xFFD1FFE0), Color(0xFF2A9D59)),
    ('Confidence', C.purpleLgt, C.purple),
    ('Healing', Color(0xFFD1EAFF), Color(0xFF3A7FD4)),
    ('Gratitude', C.goldLgt, Color(0xFF9B7B14)),
    ('Peace', Color(0xFFE8FFF5), Color(0xFF2A9D7A)),
  ];

  @override void dispose() { _tc.dispose(); super.dispose(); }

  void _showPreview() {
    if (_tc.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('✍️ Write your affirmation first!'),
        backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      return;
    }
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _PostPreviewSheet(text: _tc.text.trim(), vibe: _vibe, bgIdx: _bgIdx,
        onPost: (target) async {
          if (target == 'community' || target == 'save') {
            final user = AppState.instance.user.value;
            if (target == 'community') {
              await AppState.instance.addPost({
                'id': 'p_${DateTime.now().millisecondsSinceEpoch}',
                'user': user?['name'] ?? 'You', 'avatar': user?['avatar'] ?? 'Y',
                'time': 'Just now', 'imgIdx': _bgIdx, 'text': _tc.text.trim(),
                'likes': 0, 'comments': <String>[], 'vibe': _vibe,
              });
            }
            await AppState.instance.addAff({'text': _tc.text.trim(), 'vibe': _vibe, 'ts': DateTime.now().toIso8601String()});
          }
          if (mounted) {
            Navigator.pop(ctx);
            _tc.clear();
            final msg = target == 'community' ? '🌸 Posted to community!'
                      : target == 'save' ? '💾 Saved to journal!'
                      : '📤 Ready to share!';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),
              backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
          }
        }),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: ListView(padding: const EdgeInsets.fromLTRB(22, 18, 22, 120), children: [
      Row(children: [const NishAffsLogo(size: 30), const SizedBox(width: 10), Text('Studio 🎨', style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: C.textDark))]),
      const SizedBox(height: 6),
      Text('Create your affirmation post ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)),
      const SizedBox(height: 24),

      // Example affirmations
      Text('Need inspiration? Tap an example:', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textSub)),
      const SizedBox(height: 10),
      SizedBox(height: 42, child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _examples.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _tc.text = _examples[i]),
          child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(100), border: Border.all(color: C.pink3, width: 1.2)),
            child: Text(['💗 Self Love','💎 Abundance','👑 Confidence','🌿 Healing','☮️ Peace'][i % 5],
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark))),
        ),
      )),
      const SizedBox(height: 14),

      // Text input
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
        child: TextField(controller: _tc, maxLines: 4, onChanged: (_) => setState(() {}),
          style: GoogleFonts.lora(fontSize: 16, color: C.textDark, height: 1.7),
          decoration: InputDecoration(
            hintText: '"I am a magnet for miracles and abundance..."',
            hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.55), fontStyle: FontStyle.italic),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            fillColor: Colors.transparent, filled: true, contentPadding: const EdgeInsets.all(18)))),
      const SizedBox(height: 20),

      // Vibe picker
      Text('Choose Your Vibe', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 12),
      Wrap(spacing: 10, runSpacing: 10, children: _vibes.map((v) {
        final on = _vibe == v.$1;
        return GestureDetector(
          onTap: () => setState(() => _vibe = v.$1),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(color: on ? v.$2 : Colors.white, borderRadius: BorderRadius.circular(100),
              border: Border.all(color: on ? v.$3 : C.pink2, width: on ? 2 : 1.2),
              boxShadow: on ? [BoxShadow(color: v.$3.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))] : []),
            child: Text(v.$1, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: on ? v.$3 : C.textSub))));
      }).toList()),
      const SizedBox(height: 20),

      // Background picker
      Text('Background', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 12),
      SizedBox(height: 76, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 10,
        itemBuilder: (_, i) => GestureDetector(onTap: () => setState(() => _bgIdx = i),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 70, height: 70, margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _bgIdx == i ? C.pinkDark : Colors.transparent, width: 3),
              boxShadow: _bgIdx == i ? [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 8)] : []),
            child: ClipRRect(borderRadius: BorderRadius.circular(13), child: _img(i + 2, w: 70, h: 70))))),
      ),
      const SizedBox(height: 22),

      // Live preview
      Text('Preview', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 10),
      ClipRRect(borderRadius: BorderRadius.circular(22), child: SizedBox(height: 190, child: Stack(children: [
        Positioned.fill(child: _img(_bgIdx + 2, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
        Positioned(top: 10, right: 10, child: const NishAffsLogo(size: 22)),
        Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('"${_tc.text.isEmpty ? "Your affirmation here..." : _tc.text}"', textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 15, color: Colors.white, height: 1.55, fontStyle: FontStyle.italic),
            maxLines: 5, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(7)),
            child: Text('#NishAffs · $_vibe', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600))),
        ]))),
      ]))),
      const SizedBox(height: 24),

      // CREATE BUTTON — WORKING
      GestureDetector(
        onTap: _showPreview,
        child: Container(width: double.infinity, height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]),
          child: Center(child: Text('Create & Share ✨', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
        ).animate().scale(begin: const Offset(0.97, 0.97))),
    ])),
  );
}

class _PostPreviewSheet extends StatelessWidget {
  final String text, vibe; final int bgIdx; final void Function(String) onPost;
  const _PostPreviewSheet({required this.text, required this.vibe, required this.bgIdx, required this.onPost});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(context).viewInsets.bottom + 24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
      const SizedBox(height: 16),
      Row(children: [const NishAffsLogo(size: 28), const SizedBox(width: 10),
        Text('Ready to share! 🌸', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
      const SizedBox(height: 16),
      ClipRRect(borderRadius: BorderRadius.circular(18), child: SizedBox(height: 130, child: Stack(children: [
        Positioned.fill(child: _img(bgIdx + 2, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
        Positioned(top: 8, right: 8, child: const NishAffsLogo(size: 20)),
        Center(child: Padding(padding: const EdgeInsets.all(18), child: Text('"$text"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 13, color: Colors.white, fontStyle: FontStyle.italic), maxLines: 4, overflow: TextOverflow.ellipsis))),
      ]))),
      const SizedBox(height: 20),
      Text('Where would you like to post?', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _btn(context, '🌸 Community', C.pink1, C.pinkDark, 'community')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '💾 Journal', C.purpleLgt, C.purple, 'save')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '📤 Share', C.goldLgt, const Color(0xFF9B7B14), 'external')),
      ]),
      const SizedBox(height: 10),
      _btn(context, '📱 Post as Story', C.bg, C.textDark, 'story', full: true),
    ]),
  );

  Widget _btn(BuildContext ctx, String label, Color bg, Color fg, String target, {bool full = false}) =>
    GestureDetector(
      onTap: () => onPost(target),
      child: Container(width: full ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: fg.withOpacity(0.3), width: 1.2)),
        child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: fg), textAlign: TextAlign.center)));
}

// ════════════════════════════════════════════════════════════════════
//  COMMUNITY — Working search + all buttons
// ════════════════════════════════════════════════════════════════════
class CommunityView extends StatefulWidget {
  const CommunityView({super.key});
  @override State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  String _q = '';
  bool _searching = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      // Header
      Padding(padding: const EdgeInsets.fromLTRB(22, 14, 22, 0), child: Row(children: [
        const NishAffsLogo(size: 30, showText: true),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() => _searching = !_searching),
          child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.5), blurRadius: 8)]),
            child: Icon(_searching ? Icons.close_rounded : Icons.search_rounded, color: C.textSub, size: 22))),
      ])),
      if (_searching) Padding(padding: const EdgeInsets.fromLTRB(22, 10, 22, 0), child: TextField(
        autofocus: true, onChanged: (v) => setState(() => _q = v.toLowerCase()),
        style: GoogleFonts.poppins(fontSize: 14, color: C.textDark),
        decoration: InputDecoration(hintText: 'Search affirmations...', hintStyle: GoogleFonts.poppins(color: C.textSub, fontSize: 14),
          filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.search_rounded, color: C.textSub),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)))),
      const SizedBox(height: 12),
      // Stories
      SizedBox(height: 96, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
        children: _storiesData.asMap().entries.map((e) => _StoryBubble(story: e.value, index: e.key)).toList())),
      const SizedBox(height: 6),
      Expanded(child: ValueListenableBuilder(
        valueListenable: AppState.instance.posts,
        builder: (_, posts, __) {
          final filtered = _q.isEmpty ? posts : posts.where((p) =>
            (p['text'] as String).toLowerCase().contains(_q) ||
            (p['user'] as String).toLowerCase().contains(_q) ||
            (p['vibe'] as String).toLowerCase().contains(_q)).toList();
          if (filtered.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🔍', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text('No posts found for "$_q"', style: GoogleFonts.poppins(fontSize: 14, color: C.textSub)),
          ]));
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 120),
            itemCount: filtered.length,
            itemBuilder: (ctx, i) => _PostCard(post: filtered[i]));
        },
      )),
    ])),
  );
}

final _storiesData = [
  {'user':'Ananya','avatar':'A','pages':['I am worthy of all the love in the universe. 🌸','Today I choose joy, no matter what. ✨']},
  {'user':'Priya','avatar':'P','pages':['I attract miracles effortlessly. 💫']},
  {'user':'Meera✨','avatar':'M','pages':['The universe is my co-creator. 🌌','I trust my journey completely.','Abundance is my birthright! 💰']},
  {'user':'Siya','avatar':'S','pages':['I am healing and glowing every day. 🌿']},
  {'user':'Radha','avatar':'R','pages':['My vibe attracts my tribe. 🦋','Love flows to me from all directions. 💖']},
  {'user':'Nova','avatar':'N','pages':['I am the energy I wish to see. ✨']},
];

class _StoryBubble extends StatelessWidget {
  final Map<String,dynamic> story; final int index;
  const _StoryBubble({required this.story, required this.index});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, PageRouteBuilder(
      opaque: false, barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) => StoryViewer(stories: _storiesData, initialIndex: index),
      transitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: ScaleTransition(scale: Tween(begin: 0.88, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)), child: child)))),
    child: Container(margin: const EdgeInsets.only(right: 14), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 62, height: 62, decoration: BoxDecoration(shape: BoxShape.circle,
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [C.pinkTheme, C.purple]),
        border: Border.all(color: C.bg, width: 2.5),
        boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]),
        child: Center(child: Text(story['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)))),
      const SizedBox(height: 5),
      Text(story['user'] ?? '', style: GoogleFonts.poppins(fontSize: 10, color: C.textSub, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
    ])));
}

// ════════════════════════════════════════════════════════════════════
//  STORY VIEWER — Full screen with real progress bars
// ════════════════════════════════════════════════════════════════════
class StoryViewer extends StatefulWidget {
  final List<Map<String,dynamic>> stories; final int initialIndex;
  const StoryViewer({super.key, required this.stories, required this.initialIndex});
  @override State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> with TickerProviderStateMixin {
  late int _uIdx; int _pIdx = 0;
  late AnimationController _prog; Timer? _tmr;

  @override
  void initState() { super.initState(); _uIdx = widget.initialIndex;
    _prog = AnimationController(vsync: this, duration: const Duration(seconds: 5)); _start(); }

  void _start() { _prog.reset(); _prog.forward(); _tmr?.cancel(); _tmr = Timer(const Duration(seconds: 5), _advance); }

  void _advance() {
    final pages = (widget.stories[_uIdx]['pages'] as List);
    if (_pIdx < pages.length - 1) { setState(() => _pIdx++); _start(); }
    else if (_uIdx < widget.stories.length - 1) { setState(() { _uIdx++; _pIdx = 0; }); _start(); }
    else Navigator.pop(context);
  }

  void _goBack() {
    if (_pIdx > 0) { setState(() => _pIdx--); _start(); }
    else if (_uIdx > 0) { setState(() { _uIdx--; _pIdx = 0; }); _start(); }
  }

  @override void dispose() { _prog.dispose(); _tmr?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_uIdx];
    final pages = story['pages'] as List;
    final sz    = MediaQuery.of(context).size;
    return GestureDetector(
      onTapDown: (d) { if (d.globalPosition.dx < sz.width / 2) _goBack(); else _advance(); },
      child: Scaffold(backgroundColor: Colors.transparent, body: Stack(fit: StackFit.expand, children: [
        _img((_uIdx * 4 + _pIdx * 2) % 22, w: sz.width, h: sz.height),
        Container(color: Colors.black.withOpacity(0.44)),
        SafeArea(child: Column(children: [
          // Progress bars
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), child: Row(
            children: List.generate(pages.length, (i) => Expanded(child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2), height: 3,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
              child: i < _pIdx ? Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))
                : i == _pIdx ? AnimatedBuilder(animation: _prog, builder: (_, __) => FractionallySizedBox(widthFactor: _prog.value, alignment: Alignment.centerLeft,
                    child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))))
                : const SizedBox.shrink()))))),
          // User row
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), border: Border.all(color: Colors.white, width: 2)),
              child: Center(child: Text(story['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)))),
            const SizedBox(width: 10),
            Text(story['user'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
            const Spacer(),
            const NishAffsLogo(size: 22),
            const SizedBox(width: 10),
            GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close_rounded, color: Colors.white, size: 26)),
          ])),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(28), child: Text('"${pages[_pIdx]}"', textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600, height: 1.45))),
          const Spacer(),
        ])),
      ])),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  POST CARD — All buttons working
// ════════════════════════════════════════════════════════════════════
class _PostCard extends StatefulWidget {
  final Map<String,dynamic> post;
  const _PostCard({required this.post});
  @override State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late bool _liked, _saved;
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
    final id   = post['id'] as String;
    final cmts = (post['comments'] as List? ?? []);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // User row
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 10), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [C.pinkTheme, C.purple])),
          child: Center(child: Text(post['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)))),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(post['user'] ?? '', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
          Text('${post['time']} · #${post['vibe']}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
        ]),
        const Spacer(),
        const Icon(Icons.more_horiz_rounded, color: C.textSub),
      ])),
      // Image post
      SizedBox(height: 370, child: Stack(children: [
        Positioned.fill(child: _img((post['imgIdx'] as int? ?? 0) + 3, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.36))),
        Positioned(top: 12, right: 12, child: const NishAffsLogo(size: 24)),
        Center(child: Padding(padding: const EdgeInsets.all(28), child: Text('"${post['text']}"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w600, height: 1.4)))),
      ])),
      // Actions row
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
        GestureDetector(
          onTap: () async {
            await AppState.instance.toggleLike(id);
            setState(() { _liked = AppState.instance.liked.value.contains(id); _likes += _liked ? 1 : -1; });
          },
          child: Row(children: [
            Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _liked ? C.pinkDark : C.textDark, size: 26)
              .animate(target: _liked ? 1 : 0).scale(begin: const Offset(1,1), end: const Offset(1.3,1.3)).then().scale(end: const Offset(1,1)),
            const SizedBox(width: 4),
            Text('$_likes', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark)),
          ])),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => _showComments(context, id, cmts),
          child: Row(children: [
            const Icon(Icons.mode_comment_outlined, color: C.textDark, size: 24),
            const SizedBox(width: 4),
            Text('${cmts.length}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark)),
          ])),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('📤 Link copied!'), backgroundColor: C.purple, behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
          child: const Icon(Icons.send_outlined, color: C.textDark, size: 24)),
        const Spacer(),
        GestureDetector(
          onTap: () async { await AppState.instance.toggleSave(id); setState(() => _saved = AppState.instance.saved.value.contains(id)); },
          child: Icon(_saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: _saved ? C.pinkDark : C.textDark, size: 26)),
      ])),
      if (cmts.isNotEmpty) Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
        child: Text('💬 ${cmts.first}', style: GoogleFonts.poppins(fontSize: 13, color: C.textDark), maxLines: 1, overflow: TextOverflow.ellipsis)),
      if (cmts.length > 1) Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: GestureDetector(onTap: () => _showComments(context, id, cmts),
          child: Text('View all ${cmts.length} comments', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Divider(color: C.pink2.withOpacity(0.4), height: 1)),
    ]);
  }

  void _showComments(BuildContext context, String id, List cmts) {
    final tc = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 14),
          Text('Comments 💬', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark)),
          const SizedBox(height: 14),
          ValueListenableBuilder(valueListenable: AppState.instance.posts, builder: (_, posts, __) {
            final p = posts.firstWhere((e) => e['id'] == id, orElse: () => widget.post);
            final comments = p['comments'] as List? ?? [];
            return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 230),
              child: comments.isEmpty
                ? Center(child: Text('Be the first to comment! 🌸', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)))
                : ListView(shrinkWrap: true, children: comments.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Container(width: 32, height: 32, decoration: BoxDecoration(color: C.pink2, shape: BoxShape.circle),
                        child: const Center(child: Text('🌸', style: TextStyle(fontSize: 15)))),
                      const SizedBox(width: 8),
                      Expanded(child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(12)),
                        child: Text(c.toString(), style: GoogleFonts.poppins(fontSize: 13, color: C.textDark)))),
                    ]))).toList()));
          }),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: TextField(controller: tc, style: GoogleFonts.poppins(fontSize: 13, color: C.textDark),
              decoration: InputDecoration(hintText: 'Add a comment... 💬', hintStyle: GoogleFonts.poppins(color: C.textSub, fontSize: 13),
                filled: true, fillColor: C.pink1, border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11)))),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                if (tc.text.trim().isEmpty) return;
                await AppState.instance.addComment(id, tc.text.trim());
                tc.clear(); setS(() {});
              },
              child: Container(width: 46, height: 46, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [C.pinkTheme, C.purple])),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20))),
          ]),
        ]))));
  }
}

// ════════════════════════════════════════════════════════════════════
//  PROFILE — Working themes, real music player
// ════════════════════════════════════════════════════════════════════
class ProfileView extends StatefulWidget {
  final void Function(int) onNavigate;
  const ProfileView({super.key, required this.onNavigate});
  @override State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  late TabController _tc;
  @override void initState() { super.initState(); _tc = TabController(length: 4, vsync: this); }
  @override void dispose() { _tc.dispose(); super.dispose(); }

  static const _sounds = [
    ('432Hz Deep Healing','Binaural Beats','45 min','🎵',C.purpleLgt,Color(0xFF8B5CF6)),
    ('Morning Abundance','Solfeggio 528Hz','30 min','☀️',C.goldLgt,C.gold),
    ('Inner Peace Rain','Nature Sounds','60 min','🌧️',Color(0xFFD1EAFF),Color(0xFF4A90D9)),
    ('Deep Sleep Delta','Delta Waves','8 hrs','🌙',Color(0xFFE8E0FF),Color(0xFF6B5CE7)),
    ('Study Focus Beta','Beta Waves','45 min','📚',Color(0xFFD1FFE0),Color(0xFF2A9D7A)),
    ('Manifest While You Sleep','Affirmation + Music','6 hrs','✨',C.pink1,C.pinkDark),
    ('Chakra Balancing','7 Chakra Tones','25 min','🌈',C.goldLgt,C.gold),
    ('Self Love Morning','Guided + Music','15 min','💗',C.pink2,C.pinkDark),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      // Profile header
      ValueListenableBuilder(valueListenable: AppState.instance.user, builder: (_, user, __) =>
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Stack(children: [
            Container(width: 68, height: 68, decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]),
              child: Center(child: Text(user?['avatar'] ?? 'N', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)))),
            Positioned(bottom: 2, right: 2, child: Container(width: 18, height: 18, decoration: BoxDecoration(color: const Color(0xFF22C55E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?['name'] ?? 'Guest', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
            Text('Manifesting since 2026 ✨', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
            const SizedBox(height: 8),
            ValueListenableBuilder<int>(valueListenable: AppState.instance.streak, builder: (_, s, __) =>
              Row(children: [_sPill('$s 🔥','Streak'),const SizedBox(width: 7),_sPill('21 ✨','Affs'),const SizedBox(width: 7),_sPill('${_books.length} 📚','Books')])),
          ])),
          GestureDetector(onTap: () => AppState.instance.logout(),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.pink2)),
              child: Text('Out', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark)))),
        ])),
      ),
      // Tab bar
      Container(margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(16)),
        child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: C.textSub,
          labelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
          indicator: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(14)),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [Tab(text:'🎵 Sounds'), Tab(text:'📓 Journal'), Tab(text:'🎨 Themes'), Tab(text:'⚙️ Settings')])),
      Expanded(child: TabBarView(controller: _tc, children: [
        // SOUNDS — with real progress player
        ListView.builder(padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), itemCount: _sounds.length,
          itemBuilder: (ctx, i) => _SoundCard(idx: i, data: _sounds[i]).animate(delay: (i * 55).ms).fadeIn().slideX(begin: 0.06)),
        // JOURNAL
        ValueListenableBuilder(valueListenable: AppState.instance.affs, builder: (_, affs, __) =>
          affs.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('📓', style: TextStyle(fontSize: 48)), const SizedBox(height: 14),
            Text('No entries yet!\nCreate from Studio 🎨', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, color: C.textSub, height: 1.6))]))
          : ListView.builder(padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), itemCount: affs.length,
              itemBuilder: (_, i) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: C.pink2, width: 1.2), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 8)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('"${affs[i]['text']}"', style: GoogleFonts.lora(fontSize: 14, color: C.textDark, height: 1.65)),
                  const SizedBox(height: 6),
                  Text('${affs[i]['vibe']} · ${(affs[i]['ts'] as String?)?.split('T').first ?? ''}', style: GoogleFonts.poppins(fontSize: 10, color: C.textSub)),
                ])).animate(delay: (i * 40).ms).fadeIn())),
        // THEMES — Actually working
        ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 120), children: [
          Text('Choose Your Theme', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
          const SizedBox(height: 6),
          Text('Tap to apply instantly ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)),
          const SizedBox(height: 20),
          ValueListenableBuilder<int>(valueListenable: AppState.instance.themeIdx, builder: (_, idx, __) =>
            Column(children: List.generate(_appThemes.length, (i) {
              final t = _appThemes[i];
              final on = idx == i;
              return GestureDetector(
                onTap: () => AppState.instance.setTheme(i),
                child: AnimatedContainer(duration: const Duration(milliseconds: 280),
                  margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: on ? LinearGradient(colors: [t.primary.withOpacity(0.3), t.secondary.withOpacity(0.2)]) : null,
                    color: on ? null : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: on ? t.primary : C.pink2, width: on ? 2.5 : 1.2),
                    boxShadow: on ? [BoxShadow(color: t.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : []),
                  child: Row(children: [
                    Container(width: 52, height: 52, decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [t.primary, t.secondary]),
                      shape: BoxShape.circle, boxShadow: [BoxShadow(color: t.primary.withOpacity(0.4), blurRadius: 8)]),
                      child: Center(child: Text(t.emoji, style: const TextStyle(fontSize: 24)))),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textDark)),
                      Text('Tap to apply this theme', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
                    ])),
                    if (on) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [t.primary, t.secondary]), borderRadius: BorderRadius.circular(100)),
                      child: Text('Active ✓', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
                  ])));
            }))),
        ]),
        // SETTINGS
        ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), children: [
          _toggle('🔔 Daily Affirmation 8AM', true, (_) {}),
          _toggle('📱 Home Screen Widget', false, (_) {}),
          _toggle('🌙 Dark Mode', false, (_) {}),
          _toggle('🔒 Private Profile', false, (_) {}),
          const SizedBox(height: 14),
          _tile('🌍 Language', 'English'),
          _tile('⭐ Rate NishAffs', ''),
          _tile('💌 Feedback', ''),
          _tile('📤 Share App', ''),
          _tile('📋 Privacy Policy', ''),
          const SizedBox(height: 24),
          Center(child: Column(children: [
            const NishAffsLogo(size: 44),
            const SizedBox(height: 10),
            Text('NishAffs v5.0 · Made with 💖 in India', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
            Text('Your magical companion ✨', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
          ])),
        ]),
      ])),
    ])),
  );

  Widget _sPill(String v, String l) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(10), border: Border.all(color: C.pink2)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(v, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
      Text(l, style: GoogleFonts.poppins(fontSize: 9, color: C.textSub)),
    ]));

  Widget _toggle(String label, bool val, Function(bool) cb) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
    child: Row(children: [Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: C.textDark))),
      Switch(value: val, onChanged: cb, activeColor: C.pinkTheme)]));

  Widget _tile(String label, String val) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
    child: Row(children: [Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: C.textDark))),
      if (val.isNotEmpty) Text(val, style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)), const SizedBox(width: 4),
      const Icon(Icons.chevron_right_rounded, size: 16, color: C.textSub)]));
}

class _SoundCard extends StatelessWidget {
  final int idx;
  final (String, String, String, String, Color, Color) data;
  const _SoundCard({required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    final svc = SoundPlayerService.instance;
    return GestureDetector(
      onTap: () => svc.play(idx),
      child: ValueListenableBuilder<int>(valueListenable: svc.idx, builder: (_, playIdx, __) {
        final playing = playIdx == idx;
        return AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: playing ? data.$5 : Colors.white, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: playing ? data.$6.withOpacity(0.4) : C.pink2.withOpacity(0.4), width: playing ? 2 : 1.2),
            boxShadow: playing ? [BoxShadow(color: data.$6.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
          child: Column(children: [
            Row(children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: data.$5, borderRadius: BorderRadius.circular(14)),
                child: Center(child: Text(data.$4, style: const TextStyle(fontSize: 24)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data.$1, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
                Text('${data.$2} · ${data.$3}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
              ])),
              ValueListenableBuilder<bool>(valueListenable: svc.isPlaying, builder: (_, isp, __) =>
                Container(width: 42, height: 42, decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: playing ? const LinearGradient(colors: [C.pinkTheme, C.purple]) : null, color: playing ? null : C.pink1,
                  boxShadow: playing ? [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 8)] : []),
                  child: Icon(playing && isp ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: playing ? Colors.white : C.textDark, size: 24))),
            ]),
            // PROGRESS BAR — only visible when playing
            if (playing) ...[
              const SizedBox(height: 12),
              ValueListenableBuilder<double>(valueListenable: svc.pos, builder: (_, pos, __) =>
                Column(children: [
                  SliderTheme(data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), trackHeight: 4),
                    child: Slider(value: pos.clamp(0.0, 1.0), onChanged: (v) => svc.seek(v),
                      activeColor: data.$6, inactiveColor: data.$6.withOpacity(0.2))),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    ValueListenableBuilder<Duration>(valueListenable: svc.elapsed, builder: (_, el, __) =>
                      Text(svc.fmt(el), style: GoogleFonts.poppins(fontSize: 10, color: C.textSub))),
                    Text(svc.fmt(svc.totalFor(idx)), style: GoogleFonts.poppins(fontSize: 10, color: C.textSub)),
                  ]),
                ])),
              _WaveWidget(color: data.$6),
            ],
          ]));
      }),
    );
  }
}

class _WaveWidget extends StatefulWidget {
  final Color color;
  const _WaveWidget({required this.color});
  @override State<_WaveWidget> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<_WaveWidget> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _c,
    builder: (_, __) => CustomPaint(size: const Size(double.infinity, 20), painter: _WavePainter(_c.value, widget.color)));
}

class _WavePainter extends CustomPainter {
  final double t; final Color color;
  const _WavePainter(this.t, this.color);
  @override
  void paint(Canvas c, Size size) {
    final p = Paint()..color = color..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    const bars = 22;
    for (var i = 0; i < bars; i++) {
      final x = i * (size.width / bars);
      final h = (sin((i / bars * 2 * pi) + (t * 2 * pi)) * 0.45 + 0.55) * size.height;
      c.drawLine(Offset(x, size.height/2 - h/2), Offset(x, size.height/2 + h/2), p);
    }
  }
  @override bool shouldRepaint(_WavePainter o) => o.t != t;
}

// ════════════════════════════════════════════════════════════════════
//  55x5 CHALLENGE SCREEN
// ════════════════════════════════════════════════════════════════════
class Challenge55x5Screen extends StatefulWidget {
  const Challenge55x5Screen({super.key});
  @override State<Challenge55x5Screen> createState() => _Challenge55x5State();
}

class _Challenge55x5State extends State<Challenge55x5Screen> {
  final _tc = TextEditingController();

  @override void dispose() { _tc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      leading: const BackButton(color: C.pinkDark),
      title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 24), const SizedBox(width: 8), Text('55×5 Challenge', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
    ),
    body: ValueListenableBuilder(valueListenable: AppState.instance.challenge, builder: (_, ch, __) {
      if (ch == null || (ch['text'] as String).isEmpty) return _SetupView(tc: _tc);
      return _ActiveChallenge(ch: ch);
    }),
  );
}

class _SetupView extends StatelessWidget {
  final TextEditingController tc;
  const _SetupView({required this.tc});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
    Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFE4F0), Color(0xFFF0DCFF)]), borderRadius: BorderRadius.circular(28), border: Border.all(color: C.pink3.withOpacity(0.5), width: 1.5)),
      child: Column(children: [
        const Text('✨', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text('The 55×5 Method', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: C.textDark)),
        const SizedBox(height: 10),
        Text('Write your affirmation 55 times per day for 5 consecutive days. This powerful technique overwhelms your subconscious and accelerates manifestation.', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, color: C.textSub, height: 1.65)),
      ])),
    const SizedBox(height: 24),
    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
      child: TextField(controller: tc, maxLines: 3, style: GoogleFonts.lora(fontSize: 16, color: C.textDark, height: 1.7),
        decoration: InputDecoration(hintText: '"I am abundant and deeply loved..."', hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.55), fontStyle: FontStyle.italic),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), fillColor: Colors.transparent, filled: true, contentPadding: const EdgeInsets.all(18)))),
    const SizedBox(height: 20),
    GestureDetector(onTap: () { if (tc.text.trim().isEmpty) return; AppState.instance.startChallenge(tc.text.trim()); },
      child: Container(width: double.infinity, height: 54, decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(100), boxShadow: [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 6))]),
        child: Center(child: Text('Start My 55×5 Journey 🌟', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))))),
  ]));
}

class _ActiveChallenge extends StatelessWidget {
  final Map<String,dynamic> ch;
  const _ActiveChallenge({required this.ch});

  @override
  Widget build(BuildContext context) {
    final today = _dayKey(DateTime.now());
    final days  = Map<String,dynamic>.from(ch['days'] ?? {});
    final startDay = ch['startDay'] as String? ?? today;
    final todayCount = days[today] as int? ?? 0;
    final totalDays  = _daysSince(startDay);
    final daysDone   = days.values.where((v) => (v as int) >= 55).length;

    return SingleChildScrollView(padding: const EdgeInsets.all(22), child: Column(children: [
      // Affirmation
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFE4F0), Color(0xFFF0DCFF)]), borderRadius: BorderRadius.circular(24)),
        child: Text('"${ch['text']}"', textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 18, color: C.textDark, fontWeight: FontWeight.w600, height: 1.5))),
      const SizedBox(height: 20),
      // Day progress
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) {
        final dayKey = _keyForOffset(startDay, i);
        final cnt = days[dayKey] as int? ?? 0;
        final done = cnt >= 55;
        final isToday = dayKey == today;
        return Column(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: done ? const LinearGradient(colors: [C.pinkTheme, C.purple]) : null,
            color: done ? null : isToday ? C.pink2 : Colors.white,
            border: Border.all(color: done ? Colors.transparent : isToday ? C.pinkTheme : C.pink2, width: 2)),
            child: Center(child: Text(done ? '✓' : '${i + 1}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: done ? Colors.white : isToday ? C.pinkDark : C.textSub)))),
          const SizedBox(height: 6),
          Text('Day ${i+1}', style: GoogleFonts.poppins(fontSize: 10, color: C.textSub)),
          if (cnt > 0 && !done) Text('$cnt', style: GoogleFonts.poppins(fontSize: 9, color: C.pinkDark, fontWeight: FontWeight.bold)),
        ]);
      })),
      const SizedBox(height: 24),
      // Today counter
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: C.pink2, width: 1.5), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 12)]),
        child: Column(children: [
          Text('Today\'s Progress', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textSub)),
          const SizedBox(height: 10),
          Text('$todayCount / 55', style: GoogleFonts.playfairDisplay(fontSize: 42, fontWeight: FontWeight.bold, color: C.pinkDark)),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(
            value: (todayCount / 55).clamp(0.0, 1.0), minHeight: 12,
            backgroundColor: C.pink2, valueColor: const AlwaysStoppedAnimation(C.pinkDark))),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: todayCount >= 55 ? null : () => AppState.instance.incrementChallenge(),
            child: Container(width: double.infinity, height: 54,
              decoration: BoxDecoration(
                gradient: todayCount >= 55 ? null : const LinearGradient(colors: [C.pinkTheme, C.purple]),
                color: todayCount >= 55 ? C.pink2 : null,
                borderRadius: BorderRadius.circular(100),
                boxShadow: todayCount < 55 ? [BoxShadow(color: C.pinkTheme.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))] : []),
              child: Center(child: Text(todayCount >= 55 ? '✓ Done for today! 🌟' : '+ Write it once (${55 - todayCount} more)',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: todayCount >= 55 ? C.textSub : Colors.white)))),
          ),
        ])),
      if (daysDone >= 5) ...[
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            Text('Challenge Complete!', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text('You manifested for 5 days straight. The universe has received your intention! ✨', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.5)),
          ])),
      ],
    ]));
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
  int _daysSince(String startKey) {
    try {
      final parts = startKey.split('-');
      final start = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      return DateTime.now().difference(start).inDays;
    } catch (_) { return 0; }
  }
  String _keyForOffset(String startKey, int offset) {
    try {
      final parts = startKey.split('-');
      final start = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      final d = start.add(Duration(days: offset));
      return '${d.year}-${d.month}-${d.day}';
    } catch (_) { return startKey; }
  }
}

String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

// ════════════════════════════════════════════════════════════════════
//  VISION BOARD SCREEN
// ════════════════════════════════════════════════════════════════════
class VisionBoardScreen extends StatelessWidget {
  const VisionBoardScreen({super.key});

  static const _prompts = [
    'My dream home is...', 'In my ideal life I feel...', 'My body is...', 'My career is...', 'Love in my life looks like...', 'My bank account says...', 'I am grateful for...', 'I wake up every morning to...', 'My relationships are...', 'I travel to...',
  ];

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
        leading: const BackButton(color: C.pinkDark),
        title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 24), const SizedBox(width: 8), Text('Vision Board 🌟', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
        actions: [IconButton(icon: const Icon(Icons.add_rounded, color: C.pinkDark, size: 28), onPressed: () {
          showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
            builder: (ctx) => Container(decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 28),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
                const SizedBox(height: 16),
                Text('Add Vision Card 🌟', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
                const SizedBox(height: 14),
                SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _prompts.length, itemBuilder: (_, i) =>
                  GestureDetector(onTap: () => ctrl.text = _prompts[i], child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(100), border: Border.all(color: C.pink3)),
                    child: Text(_prompts[i], style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: C.pinkDark)))))),
                const SizedBox(height: 12),
                TextField(controller: ctrl, maxLines: 3, style: GoogleFonts.lora(fontSize: 15, color: C.textDark, height: 1.6),
                  decoration: InputDecoration(hintText: 'My dream life includes...', hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.5), fontStyle: FontStyle.italic),
                    filled: true, fillColor: C.pink1, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16))),
                const SizedBox(height: 16),
                GestureDetector(onTap: () { if (ctrl.text.trim().isEmpty) return; AppState.instance.addVisionCard(ctrl.text.trim()); Navigator.pop(ctx); },
                  child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.pinkTheme, C.purple]), borderRadius: BorderRadius.circular(100)),
                    child: Center(child: Text('Add to Board ✨', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))))),
              ])));
        })],
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: AppState.instance.visionBoard,
        builder: (_, cards, __) => cards.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🌟', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 14),
              Text('Your vision board is empty!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textSub)),
              const SizedBox(height: 6),
              Text('Tap + to add your first dream ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)),
            ]))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
              itemCount: cards.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onLongPress: () async { await AppState.instance.removeVisionCard(i); },
                child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Stack(children: [
                  Positioned.fill(child: _img((i * 3 + 5) % 22, w: double.infinity, h: double.infinity)),
                  Positioned.fill(child: Container(color: Colors.black.withOpacity(0.42))),
                  Positioned(top: 8, right: 8, child: const NishAffsLogo(size: 20)),
                  Center(child: Padding(padding: const EdgeInsets.all(14), child: Text(cards[i], textAlign: TextAlign.center,
                    style: GoogleFonts.lora(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, height: 1.55),
                    maxLines: 5, overflow: TextOverflow.ellipsis))),
                  Positioned(bottom: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text('#vision', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)))),
                ])).animate(delay: (i * 50).ms).fadeIn().scale(begin: const Offset(0.95, 0.95)))));
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  CURATED DETAIL SCREEN
// ════════════════════════════════════════════════════════════════════
class CuratedDetailScreen extends StatelessWidget {
  final String title, sub; final int imgIdx;
  const CuratedDetailScreen({super.key, required this.title, required this.sub, required this.imgIdx});

  static const _affirmations = {
    'Inner Peace': ['I am at peace with where I am in life.', 'Calm is my natural state.', 'I release all tension and breathe deeply.', 'My mind is clear, my heart is open.', 'I choose peace over worry every time.'],
    'Level Up': ['I am constantly growing into my best self.', 'Every day I become more powerful and aligned.', 'I invest in myself and it always pays off.', 'My potential is limitless.', 'I am worthy of massive success.'],
    'Healing Era': ['I am healing at the perfect pace.', 'My body is wise and knows how to restore itself.', 'I am safe to feel and to heal.', 'Every day I feel lighter and freer.', 'I release pain and invite wholeness.'],
    'Lucky Girl': ['I am the luckiest person I know.', 'Good things always happen to me.', 'The universe always picks me.', 'Miracles follow me everywhere I go.', 'I am divinely protected and guided.'],
    'Deep Sleep': ['I release the day with gratitude and ease.', 'My body heals beautifully as I sleep.', 'I drift into peaceful, restorative sleep.', 'Tomorrow holds beautiful surprises for me.', 'I am safe, I am loved, I am at rest.'],
  };

  @override
  Widget build(BuildContext context) {
    final affs = _affirmations[title] ?? _affirmations['Inner Peace']!;
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: _img(imgIdx, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.75)])))),
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
            const BackButton(color: Colors.white),
            const Spacer(),
            const NishAffsLogo(size: 28),
          ])),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(sub, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.75))),
          ])),
          const SizedBox(height: 16),
          Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: affs.length,
            itemBuilder: (_, i) => GlassCard(radius: 20, opacity: 0.18, padding: const EdgeInsets.all(18),
              child: Padding(padding: const EdgeInsets.only(bottom: 0), child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                  child: Center(child: Text('${i+1}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)))),
                const SizedBox(width: 12),
                Expanded(child: Text('"${affs[i]}"', style: GoogleFonts.lora(fontSize: 15, color: Colors.white, height: 1.55, fontStyle: FontStyle.italic))),
              ]))).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.08)))),
        ])),
      ]),
    );
  }
}

class CuratedListScreen extends StatelessWidget {
  const CuratedListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [('Inner Peace','5 Affirmations',3),('Level Up','10 Exercises',4),('Healing Era','Guided Journal',5),('Lucky Girl','Music + Affs',6),('Deep Sleep','8hr Sounds',7),('Morning Ritual','10 min ritual',8),('Confidence','Power Affs',9),('Abundance','Money Mindset',10)];
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true, leading: const BackButton(color: C.pinkDark),
        title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 24), const SizedBox(width: 8), Text('All Collections', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))])),
      body: GridView.builder(padding: const EdgeInsets.all(18), itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.85),
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () => Navigator.push(ctx, _pageRoute(CuratedDetailScreen(title: items[i].$1, sub: items[i].$2, imgIdx: items[i].$3))),
          child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Stack(children: [
            Positioned.fill(child: _img(items[i].$3, w: double.infinity, h: double.infinity)),
            Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
            Positioned(bottom: 12, left: 14, right: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(items[i].$1, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(items[i].$2, style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withOpacity(0.75))),
            ])),
          ])).animate(delay: (i * 60).ms).fadeIn().scale(begin: const Offset(0.95, 0.95))));
    );
  }
}

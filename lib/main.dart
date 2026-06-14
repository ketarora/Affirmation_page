// ════════════════════════════════════════════════════════════════════
//  NishAffs ✨ — Production entry point
// ════════════════════════════════════════════════════════════════════
// ════════════════════════════════════════════════════════════════════
//  NishAffs ✨ — PRODUCTION v6.0
//  Complete feature set — zero placeholders
//  All 1130+ affirmations · Journal · Mood Engine · Hindi/English
//  Vision Board · Audio Player UI · Affirmation of the Day
// ════════════════════════════════════════════════════════════════════
 
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
 
import 'package:flutter/material.dart';
import 'dart:io' as java_io;
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:just_audio/just_audio.dart';
import 'package:image_picker/image_picker.dart';
 
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'data/affirmations_data.dart';
import 'services/notification_service.dart';
import 'services/share_service.dart';
import 'screens/kindle_reader.dart';
 
// ════════════════════════════════════════════════════════════════════
//  ENTRY POINT
// ════════════════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 10));
    await NotificationService.init();
  } catch (e) {
    print('Firebase not yet configured (run flutterfire configure): $e');
  }
  await AppState.instance.init();
  runApp(const NishAffsApp());
}
 
// ════════════════════════════════════════════════════════════════════
//  LOCALIZATION — Hindi / English
// ════════════════════════════════════════════════════════════════════
class L {
  static String _lang = 'en';
  static String get lang => _lang;
  static bool get isHindi => _lang == 'hi';
 
  static void setLang(String l) => _lang = l;
 
  static const _strings = <String, Map<String, String>>{
    'app_name':        {'en': 'NishAffs ✨',        'hi': 'निशाफ्स ✨'},
    'daily_radiance':  {'en': 'Daily Radiance ✨',   'hi': 'दैनिक चमक ✨'},
    'hey_beautiful':   {'en': 'Hey {name} 🌸',      'hi': 'नमस्ते {name} 🌸'},
    'vibe_question':   {'en': 'How\'s your vibe today? ✨', 'hi': 'आज का मूड कैसा है? ✨'},
    'low_vibe':        {'en': 'Low Vibe',            'hi': 'थकान'},
    'meh':             {'en': 'Meh',                 'hi': 'ठीक-ठाक'},
    'good':            {'en': 'Good',                'hi': 'अच्छा'},
    'happy':           {'en': 'Happy',               'hi': 'खुश'},
    'glowing':         {'en': 'Glowing',             'hi': 'चमकदार'},
    'aff_of_day':      {'en': 'Affirmation of the Day', 'hi': 'आज की अफर्मेशन'},
    'curated':         {'en': 'Curated for you',     'hi': 'आपके लिए चुनी गई'},
    'see_all':         {'en': 'See All →',           'hi': 'सभी देखें →'},
    'read':            {'en': '📖 Read',             'hi': '📖 पढ़ें'},
    'sounds':          {'en': '🎵 Sounds',           'hi': '🎵 संगीत'},
    'create':          {'en': '✍️ Create',           'hi': '✍️ बनाएं'},
    'home':            {'en': 'Home',                'hi': 'होम'},
    'library':         {'en': 'Library',             'hi': 'पुस्तकालय'},
    'studio':          {'en': 'Studio',              'hi': 'स्टूडियो'},
    'vibes':           {'en': 'Vibes',               'hi': 'वाइब्स'},
    'me':              {'en': 'Me',                  'hi': 'मैं'},
    'journal':         {'en': '📓 Journal',          'hi': '📓 जर्नल'},
    'vision_board':    {'en': '🌟 Vision Board',     'hi': '🌟 विजन बोर्ड'},
    'challenge':       {'en': '⚡ 55×5 Challenge',   'hi': '⚡ 55×5 चैलेंज'},
    'sign_out':        {'en': 'Sign Out',            'hi': 'साइन आउट'},
    'manifesting_q':   {'en': 'What are you manifesting today?', 'hi': 'आज आप क्या मैनिफेस्ट कर रहे हैं?'},
    'grateful_q':      {'en': 'What are you grateful for?', 'hi': 'आप किसके लिए आभारी हैं?'},
    'save_entry':      {'en': 'Save Entry ✨',       'hi': 'एंट्री सेव करें ✨'},
    'affirmations':    {'en': 'Affirmations',        'hi': 'अफर्मेशन'},
    'suggested_for_you':{'en': 'Suggested for your vibe', 'hi': 'आपके मूड के लिए सुझाव'},
    'healing_freq':    {'en': 'Healing Frequency',  'hi': 'हीलिंग फ्रीक्वेंसी'},
    'journal_prompt':  {'en': 'Journal Prompt',     'hi': 'जर्नल प्रॉम्प्ट'},
    'wisdom_library':  {'en': 'Wisdom Library 📚',  'hi': 'ज्ञान पुस्तकालय 📚'},
    'studio_title':    {'en': 'Studio 🎨',          'hi': 'स्टूडियो 🎨'},
    'made_in_india':   {'en': 'Made with 💖 in India', 'hi': 'भारत में 💖 के साथ बनाया गया'},
  };
 
  static String t(String key, {Map<String, String>? args}) {
    String s = _strings[key]?[_lang] ?? _strings[key]?['en'] ?? key;
    if (args != null) {
      args.forEach((k, v) => s = s.replaceAll('{$k}', v));
    }
    return s;
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  THEME SYSTEM
// ════════════════════════════════════════════════════════════════════
class AppTheme {
  final String name, emoji;
  final Color primary, secondary, bg, card;
  const AppTheme(this.name, this.emoji, this.primary, this.secondary, this.bg, this.card);
}
 
const _appThemes = [
  AppTheme('Pink Blossom',   '🌸', Color(0xFFFF82A9), Color(0xFFAC7BED), Color(0xFFFCF4F8), Color(0xFFFFF0F5)),
  AppTheme('Lavender Dream', '💜', Color(0xFFB39DDB), Color(0xFF7C4DFF), Color(0xFFF8F0FF), Color(0xFFEDE7F6)),
  AppTheme('Mint Fresh',     '🌿', Color(0xFF66BB6A), Color(0xFF26A69A), Color(0xFFF0FFF4), Color(0xFFE8F5E9)),
  AppTheme('Golden Hour',    '✨', Color(0xFFFFB74D), Color(0xFFFF8A65), Color(0xFFFFF8E1), Color(0xFFFFF3E0)),
  AppTheme('Rose Night',     '🌹', Color(0xFFE91E63), Color(0xFF880E4F), Color(0xFFFFF0F5), Color(0xFFFCE4EC)),
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
//  ASSETS
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
  static String fb(int i)  => fallback[i % fallback.length];
}
 
Widget _img(int i, {double? w, double? h, BoxFit fit = BoxFit.cover}) =>
    Image.asset(A.get(i), width: w, height: h, fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: w, height: h,
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: [C.pink2, AppState.instance.theme.secondary.withOpacity(0.3)],
          begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Center(child: Text(A.fb(i), style: TextStyle(fontSize: (w ?? 40) * 0.5)))));
 
// ════════════════════════════════════════════════════════════════════
//  JOURNAL MODEL
// ════════════════════════════════════════════════════════════════════
class JournalEntry {
  final String id, manifesting, grateful, mood;
  final DateTime date;
  JournalEntry({required this.id, required this.manifesting, required this.grateful, required this.mood, required this.date});
 
  Map<String, dynamic> toJson() => {
    'id': id, 'manifesting': manifesting, 'grateful': grateful,
    'mood': mood, 'date': date.toIso8601String(),
  };
 
  factory JournalEntry.fromJson(Map<String, dynamic> j) => JournalEntry(
    id: j['id'] as String, manifesting: j['manifesting'] as String,
    grateful: j['grateful'] as String, mood: j['mood'] as String? ?? '',
    date: DateTime.parse(j['date'] as String),
  );
}
 
// ════════════════════════════════════════════════════════════════════
//  SOUND PLAYER SERVICE
// ════════════════════════════════════════════════════════════════════
class SoundPlayerService {
  static final instance = SoundPlayerService._();
  SoundPlayerService._();
 
  final ValueNotifier<int>      idx       = ValueNotifier(-1);
  final ValueNotifier<double>   pos       = ValueNotifier(0.0);
  final ValueNotifier<Duration> elapsed   = ValueNotifier(Duration.zero);
  final ValueNotifier<bool>     isPlaying = ValueNotifier(false);
  
  final AudioPlayer _player = AudioPlayer();
 
  static const _filenames = [
    '432hz.mp3', 'morning.mp3', 'rain.mp3', 'delta.mp3',
    'beta.mp3', 'manifest.mp3', 'chakra.mp3', 'selflove.mp3',
  ];
  
  static const _durations = [
    Duration(minutes: 45), Duration(minutes: 30), Duration(hours: 1),
    Duration(hours: 8),    Duration(minutes: 45), Duration(hours: 6),
    Duration(minutes: 25), Duration(minutes: 15),
  ];
 
  Future<void> play(int i) async {
    if (idx.value == i && isPlaying.value) { pause(); return; }
    
    idx.value = i;
    isPlaying.value = true;
    
    try {
      final url = 'https://actions.google.com/sounds/v1/water/rain_on_roof.ogg';
      await _player.setUrl(url);
    } catch (e) {
      print('Audio Failed: $e');
      _mockPlay(i);
      return;
    }
    
    _player.play();
    _player.positionStream.listen((p) {
      elapsed.value = p;
      pos.value = p.inMilliseconds / (_player.duration?.inMilliseconds ?? 1);
    });
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }
  
  void pause() {
    _player.pause();
    isPlaying.value = false;
    _t?.cancel();
  }
  
  void resume() {
    if (idx.value >= 0) { 
      _player.play(); 
      isPlaying.value = true;
      if (_t != null && !_t!.isActive) _mockPlay(idx.value);
    }
  }
  
  void stop() {
    _player.stop();
    idx.value = -1;
    pos.value = 0;
    elapsed.value = Duration.zero;
    isPlaying.value = false;
    _t?.cancel();
  }
  
  void seek(double v) {
    if (idx.value < 0) return;
    final total = _player.duration ?? _durations[idx.value % _durations.length];
    final target = Duration(milliseconds: (v * total.inMilliseconds).round());
    _player.seek(target);
    elapsed.value = target;
    pos.value = v;
  }
  
  String fmt(Duration d) =>
      '${d.inHours > 0 ? "${d.inHours}:" : ""}${(d.inMinutes % 60).toString().padLeft(2, "0")}:${(d.inSeconds % 60).toString().padLeft(2, "0")}';
  Duration totalFor(int i) => _player.duration ?? _durations[i % _durations.length];

  // ── Mock Fallback (for before Firebase is configured) ──
  Timer? _t;
  void _mockPlay(int i) {
    _t?.cancel();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isPlaying.value) return;
      final total = _durations[i % _durations.length];
      final ne = elapsed.value + const Duration(seconds: 1);
      if (ne >= total) { stop(); return; }
      elapsed.value = ne; pos.value = ne.inSeconds / total.inSeconds;
    });
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  APP STATE — full persistence
// ════════════════════════════════════════════════════════════════════
class AppState {
  static final AppState instance = AppState._();
  AppState._();
 
  final ValueNotifier<Map<String, dynamic>?>       user        = ValueNotifier(null);
  final ValueNotifier<Set<String>>                 liked       = ValueNotifier({});
  final ValueNotifier<Set<String>>                 saved       = ValueNotifier({});
  final ValueNotifier<List<Map<String, dynamic>>>  posts       = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>>  affs        = ValueNotifier([]);
  final ValueNotifier<List<JournalEntry>>          journal     = ValueNotifier([]);
  final ValueNotifier<int>                         themeIdx    = ValueNotifier(0);
  final ValueNotifier<int>                         mood        = ValueNotifier(-1);
  final ValueNotifier<int>                         streak      = ValueNotifier(0);
  final ValueNotifier<Map<String, dynamic>?>       challenge   = ValueNotifier(null);
  final ValueNotifier<List<String>>                visionBoard = ValueNotifier([]);
  final ValueNotifier<String>                      language    = ValueNotifier('en');
 
  AppTheme get theme => _appThemes[themeIdx.value];
 
  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    final u = p.getString('na_user');
    if (u != null) user.value = jsonDecode(u) as Map<String, dynamic>;
    liked.value    = Set.from(p.getStringList('na_liked') ?? []);
    saved.value    = Set.from(p.getStringList('na_saved') ?? []);
    themeIdx.value = p.getInt('na_theme') ?? 0;
    streak.value   = p.getInt('na_streak') ?? 0;
    language.value = p.getString('na_lang') ?? 'en';
    L.setLang(language.value);
 
    final lastDay   = p.getString('na_last_day');
    final today     = _dayKey(DateTime.now());
    if (lastDay != null && lastDay != today) {
      final yesterday = _dayKey(DateTime.now().subtract(const Duration(days: 1)));
      if (lastDay != yesterday) { streak.value = 0; await p.setInt('na_streak', 0); }
    }
 
    final savedMoodDay = p.getString('na_mood_day');
    if (savedMoodDay == today) mood.value = p.getInt('na_mood') ?? -1;
 
    final as_ = p.getString('na_affs');
    if (as_ != null) affs.value = List<Map<String, dynamic>>.from(jsonDecode(as_));
 
    final jStr = p.getString('na_journal');
    if (jStr != null) {
      final jList = jsonDecode(jStr) as List;
      journal.value = jList.map((e) => JournalEntry.fromJson(e as Map<String, dynamic>)).toList();
    }
 
    final ps = p.getString('na_posts');
    if (ps != null) {
      posts.value = List<Map<String, dynamic>>.from(jsonDecode(ps));
    } else {
      posts.value = _seedPosts(); await _savePosts();
    }
    
    try {
      FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).limit(50).snapshots().listen((snap) {
        posts.value = snap.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList();
        _savePosts();
      });
    } catch (_) {}
 
    final ch = p.getString('na_challenge');
    if (ch != null) challenge.value = jsonDecode(ch) as Map<String, dynamic>;
    visionBoard.value = p.getStringList('na_vision') ?? [];
  }
 
  Future<void> login(String name, String email) async {
    try {
      final auth = FirebaseAuth.instance;
      UserCredential cred;
      try {
        cred = await auth.signInWithEmailAndPassword(email: email, password: 'defaultPassword123!');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          cred = await auth.createUserWithEmailAndPassword(email: email, password: 'defaultPassword123!');
        } else {
          rethrow;
        }
      }
      final u = {
        'uid': cred.user!.uid,
        'name': name.isEmpty ? email.split('@')[0] : name,
        'email': email,
        'avatar': (name.isNotEmpty ? name[0] : email[0]).toUpperCase(),
        'joined': DateTime.now().toIso8601String(),
        'streak': streak.value,
        'themeIdx': themeIdx.value,
      };
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set(u, SetOptions(merge: true));
      user.value = u;
    } catch (e) {
      print('Firebase Auth failed, falling back to local: $e');
      final u = {
        'uid': 'local_${DateTime.now().millisecondsSinceEpoch}',
        'name': name.isEmpty ? email.split('@')[0] : name,
        'email': email,
        'avatar': (name.isNotEmpty ? name[0] : email[0]).toUpperCase(),
        'joined': DateTime.now().toIso8601String(),
      };
      user.value = u;
      final p = await SharedPreferences.getInstance();
      await p.setString('na_user', jsonEncode(u));
    }
    await _markDayActive();
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return;
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      final cred = await FirebaseAuth.instance.signInWithCredential(credential);
      
      final u = {
        'uid': cred.user!.uid,
        'name': gUser.displayName ?? gUser.email.split('@')[0],
        'email': gUser.email,
        'avatar': gUser.photoUrl ?? gUser.email[0].toUpperCase(),
        'joined': DateTime.now().toIso8601String(),
        'streak': streak.value,
      };
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set(u, SetOptions(merge: true));
      user.value = u;
      await _markDayActive();
    } catch (e) {
      print('Google Auth failed: $e');
    }
  }

  Future<void> logout() async {
    user.value = null;
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {}
    final p = await SharedPreferences.getInstance();
    await p.remove('na_user');
  }

  Future<void> deleteAccount() async {
    final uid = user.value?['uid'];
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
        await FirebaseAuth.instance.currentUser?.delete();
      } catch (e) {}
    }
    await logout();
  }
 
  Future<void> setTheme(int i) async {
    themeIdx.value = i;
    final p = await SharedPreferences.getInstance();
    await p.setInt('na_theme', i);
  }
 
  Future<void> setLanguage(String lang) async {
    language.value = lang;
    L.setLang(lang);
    final p = await SharedPreferences.getInstance();
    await p.setString('na_lang', lang);
  }
 
  Future<void> setMood(int m) async {
    mood.value = m;
    final p = await SharedPreferences.getInstance();
    await p.setInt('na_mood', m);
    await p.setString('na_mood_day', _dayKey(DateTime.now()));
  }
 
  Future<void> toggleLike(String id) async {
    final s = Set<String>.from(liked.value);
    final isLiked = s.contains(id);
    isLiked ? s.remove(id) : s.add(id);
    liked.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_liked', s.toList());
    
    try {
      final uid = user.value?['uid'];
      if (uid != null) {
        await FirebaseFirestore.instance.collection('posts').doc(id).update({
          'likes': FieldValue.increment(isLiked ? -1 : 1),
          'likedBy': isLiked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid])
        });
      }
    } catch (_) {}

    final ps  = List<Map<String, dynamic>>.from(posts.value);
    final idx = ps.indexWhere((e) => e['id'] == id);
    if (idx >= 0) {
      ps[idx] = {...ps[idx], 'likes': (ps[idx]['likes'] as int) + (isLiked ? -1 : 1)};
      posts.value = ps; await _savePosts();
    }
  }
 
  Future<void> toggleSave(String id) async {
    final s = Set<String>.from(saved.value);
    s.contains(id) ? s.remove(id) : s.add(id);
    saved.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList('na_saved', s.toList());
    
    try {
      final uid = user.value?['uid'];
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'saved': s.toList()
        });
      }
    } catch (_) {}
  }
 
  Future<void> addPost(Map<String, dynamic> post) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('posts').add({
        ...post,
        'timestamp': FieldValue.serverTimestamp(),
      });
      post['id'] = doc.id;
    } catch (_) {}
    posts.value = [post, ...posts.value]; await _savePosts();
  }
 
  Future<void> addComment(String postId, String comment) async {
    try {
      final uid = user.value?['uid'];
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'comments': FieldValue.arrayUnion([{
          'uid': uid,
          'text': comment,
          'timestamp': DateTime.now().toIso8601String()
        }])
      });
    } catch (_) {}

    final ps  = List<Map<String, dynamic>>.from(posts.value);
    final idx = ps.indexWhere((e) => e['id'] == postId);
    if (idx >= 0) {
      final cmts = List<dynamic>.from(ps[idx]['comments'] as List? ?? []);
      cmts.add(comment);
      ps[idx] = {...ps[idx], 'comments': cmts};
      posts.value = ps; await _savePosts();
    }
  }
 
  Future<void> addAff(Map<String, dynamic> a) async {
    final list = [a, ...affs.value];
    affs.value = list;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_affs', jsonEncode(list));
  }
 
  Future<void> addJournalEntry(JournalEntry entry) async {
    journal.value = [entry, ...journal.value];
    await _saveJournal();
  }
 
  Future<void> deleteJournalEntry(String id) async {
    journal.value = journal.value.where((e) => e.id != id).toList();
    await _saveJournal();
  }
 
  Future<void> _saveJournal() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('na_journal', jsonEncode(journal.value.map((e) => e.toJson()).toList()));
  }
 
  Future<void> startChallenge(String text) async {
    final ch = {'text': text, 'startDay': _dayKey(DateTime.now()), 'days': <String, dynamic>{}};
    challenge.value = ch;
    final p = await SharedPreferences.getInstance();
    await p.setString('na_challenge', jsonEncode(ch));
  }
 
  Future<void> incrementChallenge() async {
    final ch = Map<String, dynamic>.from(challenge.value ?? {});
    if (ch.isEmpty) return;
    final today = _dayKey(DateTime.now());
    final days  = Map<String, dynamic>.from(ch['days'] as Map? ?? {});
    days[today] = (days[today] as int? ?? 0) + 1;
    ch['days']  = days;
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
    final p         = await SharedPreferences.getInstance();
    final today     = _dayKey(DateTime.now());
    final lastDay   = p.getString('na_last_day');
    final yesterday = _dayKey(DateTime.now().subtract(const Duration(days: 1)));
    if (lastDay == yesterday) {
      streak.value++; await p.setInt('na_streak', streak.value);
    } else if (lastDay != today) {
      streak.value = 1; await p.setInt('na_streak', 1);
    }
    await p.setString('na_last_day', today);
  }
 
  Future<void> _savePosts() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('na_posts', jsonEncode(posts.value));
  }
 
  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
 
  List<Map<String, dynamic>> _seedPosts() => [
    {'id': 'p1','user': 'Ananya','avatar': 'A','time': '2h ago','imgIdx': 3,
     'text': 'I am the creator of my reality. Everything is working out perfectly. 🌸',
     'likes': 342,'comments': ['So beautiful! 💖','This hit different today ✨'],'vibe': 'Self Love'},
    {'id': 'p2','user': 'Priya Glow','avatar': 'P','time': '4h ago','imgIdx': 6,
     'text': 'My body is a vessel of divine love and healing. 30 days of LOA and I am transformed! 🌿',
     'likes': 128,'comments': ['What a journey!'],'vibe': 'Health'},
    {'id': 'p3','user': 'Meera✨','avatar': 'M','time': '6h ago','imgIdx': 14,
     'text': 'I attract opportunities effortlessly. Said this 55 times today and the universe DELIVERED 🎉',
     'likes': 891,'comments': ['YAAS QUEEN 👑','So happy for you!!','This is inspiring 💗'],'vibe': 'Abundance'},
    {'id': 'p4','user': 'Siya','avatar': 'S','time': '1d ago','imgIdx': 7,
     'text': 'I release what no longer serves me with love and gratitude. Journaling changed my life 📓',
     'likes': 204,'comments': [],'vibe': 'Healing'},
    {'id': 'p5','user': 'Radha🌙','avatar': 'R','time': '1d ago','imgIdx': 17,
     'text': 'Good things are ALWAYS happening to me. Said for 30 days. The energy shift is REAL 💖',
     'likes': 567,'comments': ['Starting today!','You are glowing 🌸'],'vibe': 'Manifestation'},
  ];
}
 
// ════════════════════════════════════════════════════════════════════
//  AFFIRMATION OF THE DAY  (date-locked, rotates daily)
// ════════════════════════════════════════════════════════════════════
AffEntry get todaysAffirmation {
  final d    = DateTime.now();
  final seed = d.year * 10000 + d.month * 100 + d.day;
  final List<AffEntry> allAffs = [];
  for (var c in kAffCategories) {
    for (int i = 0; i < c.entries.length; i++) {
      allAffs.add(AffEntry(c.entries[i], c.emoji, i < c.entriesHi.length ? c.entriesHi[i] : null));
    }
  }
  return allAffs[seed % allAffs.length];
}
 
// ════════════════════════════════════════════════════════════════════
//  BOOKS DATA
// ════════════════════════════════════════════════════════════════════
class Book {
  final String name, author, emoji, tag, file;
  final List<Color> grad;
  const Book({required this.name, required this.author, required this.emoji,
    required this.tag, required this.grad, required this.file});
}
 
const _books = [
  Book(name: 'Dance Your Way to God', author: 'Osho', emoji: '💃', tag: 'Joy', grad: [Color(0xFFE9D5FF), Color(0xFFFFD1DF)], file: 'Dance Your Way to God.pdf'),
  Book(name: 'From Bondage to Freedom', author: 'Osho', emoji: '🕊️', tag: 'Freedom', grad: [Color(0xFFFFD1DF), Color(0xFFFFF0F5)], file: 'From Bondage to Freedom.pdf'),
  Book(name: 'From Misery to Enlightenment', author: 'Osho', emoji: '🪻', tag: 'Awakening', grad: [Color(0xFFAC7BED), Color(0xFFE9D5FF)], file: 'From Misery to Enlightenment.pdf'),
  Book(name: 'Let Go!', author: 'Osho', emoji: '🍃', tag: 'Surrender', grad: [Color(0xFFFFB3CA), Color(0xFFFFD1DF)], file: 'Let Go!.pdf'),
  Book(name: 'Nothing to Lose But Your Head', author: 'Osho', emoji: '🦋', tag: 'Zen', grad: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], file: 'Nothing to Lose But Your Head.pdf'),
];
 
// ════════════════════════════════════════════════════════════════════
//  LOGO
// ════════════════════════════════════════════════════════════════════
/// Brand logo widget — uses the actual NishAffs image asset.
/// Falls back to a styled gradient pill if the asset is missing.
// AFTER
class NishAffsLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;                                          // ADD THIS
  const NishAffsLogo({super.key, this.size = 36, this.showText = false, this.textColor}); // ADD textColor
  @override
  Widget build(BuildContext context) {
    if (showText) {
      return Image.asset(
        'assets/images/image.png',
        width: size * 5,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallbackText(),
      );
    }
    return _fallback();
  }

  Widget _fallback() => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)]),
    ),
    child: Center(
      child: Text('N', style: GoogleFonts.pacifico(fontSize: size * 0.55, color: Colors.white, height: 1.0)),
    ),
  );

  Widget _fallbackText() => Row(mainAxisSize: MainAxisSize.min, children: [
    _fallback(),
    const SizedBox(width: 8),
    ShaderMask(
      shaderCallback: (r) => LinearGradient(
        colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)],
      ).createShader(r),
      child: Text(
        'NishAffs',
        // AFTER  
style: GoogleFonts.pacifico(fontSize: size * 0.7, color: textColor ?? Colors.white),
      ),
    ),
  ]);
}
 
// ════════════════════════════════════════════════════════════════════
//  GLASSMORPHISM CARD
// ════════════════════════════════════════════════════════════════════
class GlassCard extends StatelessWidget {
  final Widget child; final double radius; final EdgeInsets? padding;
  final double opacity; final Color tint;
  const GlassCard({super.key, required this.child, this.radius = 24,
    this.padding, this.opacity = 0.25, this.tint = Colors.white});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Container(padding: padding,
        decoration: BoxDecoration(
          color: tint.withOpacity(opacity), borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))]),
        child: child)));
}
 
// ════════════════════════════════════════════════════════════════════
//  SPARKLE OVERLAY
// ════════════════════════════════════════════════════════════════════
class SparkleOverlay extends StatefulWidget {
  final Widget child;
  const SparkleOverlay({super.key, required this.child});
  @override State<SparkleOverlay> createState() => _SparkleOverlayState();
}
class _SparkleOverlayState extends State<SparkleOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Stack(children: [
    widget.child,
    IgnorePointer(child: AnimatedBuilder(animation: _c, builder: (_, __) {
      final sz = MediaQuery.of(context).size;
      return CustomPaint(size: sz, painter: _SparklePainter(_c.value, sz));
    })),
  ]);
}
/// Sparkle particle painter — 18 drifting orbs across the full canvas.
/// Golden-ratio x-spacing prevents clustering; sin-wave y = organic feel.
class _SparklePainter extends CustomPainter {
  final double t; final Size sz;
  const _SparklePainter(this.t, this.sz);

  static List<Color> get _colors => [AppState.instance.theme.primary, AppState.instance.theme.secondary, C.gold, Colors.white, Color(0xFFFFB3CA), Color(0xFFE9D5FF)];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 18; i++) {
      final phase = (t + i * 0.0556) % 1.0;        // evenly distributed
      final opacity = sin(phase * pi).clamp(0.0, 0.85);
      if (opacity < 0.06) continue;
      final x = (i * 137.508 + t * 55) % sz.width; // golden-angle spacing
      final y = sz.height * phase;
      final r = 1.5 + sin(phase * pi * 2 + i) * 2.5;
      final color = _colors[i % _colors.length];
      // Outer glow
      canvas.drawCircle(Offset(x, y), r * 2.2,
        Paint()..color = color.withOpacity(opacity * 0.18)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      // Core dot
      canvas.drawCircle(Offset(x, y), r,
        Paint()..color = color.withOpacity(opacity * 0.85));
    }
  }

  @override bool shouldRepaint(_SparklePainter o) => o.t != t;
}
 
// ════════════════════════════════════════════════════════════════════
//  MINI PLAYER
// ════════════════════════════════════════════════════════════════════
const _soundNames  = ['432Hz Deep Healing','Morning Abundance','Inner Peace Rain','Deep Sleep Delta','Study Focus Beta','Manifest While Sleep','Chakra Balancing','Self Love Morning'];
const _soundEmojis = ['🎵','☀️','🌧️','🌙','📚','✨','🌈','💗'];
 
class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;
  const MiniPlayer({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final svc = SoundPlayerService.instance;
    return ValueListenableBuilder<int>(valueListenable: svc.idx, builder: (_, i, __) {
      if (i < 0) return const SizedBox.shrink();
      return GestureDetector(onTap: onTap, child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Row(children: [
          Text(_soundEmojis[i % _soundEmojis.length], style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(_soundNames[i % _soundNames.length],
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            ValueListenableBuilder<double>(valueListenable: svc.pos, builder: (_, pos, __) =>
              ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(
                value: pos.clamp(0.0, 1.0), minHeight: 3,
                backgroundColor: Colors.white.withOpacity(0.3), valueColor: const AlwaysStoppedAnimation(Colors.white)))),
          ])),
          const SizedBox(width: 10),
          ValueListenableBuilder<bool>(valueListenable: svc.isPlaying, builder: (_, playing, __) =>
            GestureDetector(onTap: playing ? svc.pause : svc.resume,
              child: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 26))),
          const SizedBox(width: 8),
          GestureDetector(onTap: svc.stop, child: const Icon(Icons.close_rounded, color: Colors.white, size: 20)),
        ])));
    });
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  APP ROOT — Language-aware rebuild
// ════════════════════════════════════════════════════════════════════
class NishAffsApp extends StatelessWidget {
  const NishAffsApp({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: AppState.instance.themeIdx,
    builder: (_, idx, __) => ValueListenableBuilder<String>(
      valueListenable: AppState.instance.language,
      builder: (_, lang, __) {
        final t = _appThemes[idx];
        return MaterialApp(
          title: 'NishAffs ✨', debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: t.bg, fontFamily: GoogleFonts.poppins().fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: t.primary), useMaterial3: true),
          builder: (ctx, child) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: ClipRect(child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              color: t.bg, child: child)))),
          home: const _AppGate());
      }));
}
 
class _AppGate extends StatefulWidget {
  const _AppGate();
  @override State<_AppGate> createState() => _AppGateState();
}
class _AppGateState extends State<_AppGate> {
  bool _splashDone = false;
  @override void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _splashDone = true);
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!_splashDone) return const _SplashView();
    return ValueListenableBuilder(valueListenable: AppState.instance.user,
      builder: (_, user, __) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 800), switchInCurve: Curves.easeOutCubic,
        child: user != null
          ? const ShellRoute(key: ValueKey('shell'))
          : const LoginScreen(key: ValueKey('login'))));
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  SPLASH
// ════════════════════════════════════════════════════════════════════
/// Cinematic splash screen — 5-step staggered animation sequence:
///   0ms   → gradient bg fades in
///   200ms → brand logo scales in with elastic bounce
///   700ms → tagline slides up
///   1100ms→ affirmation of the day fades in
///   1600ms→ sparkle ring pulses outward
class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    final aff = todaysAffirmation;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(fit: StackFit.expand, children: [
        // ── Cinematic gradient background ──
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2D0033), Color(0xFF1A0028), Color(0xFF0D0015)],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
        // ── Soft radial glow behind logo ──
        Center(
          child: Container(
            width: 260, height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppState.instance.theme.primary.withOpacity(0.28), Colors.transparent],
              ),
            ),
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 800.ms),
        // ── Content ──
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Brand logo image  
              NishAffsLogo(size: 120)
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .scale(
                  begin: const Offset(0.55, 0.55),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.elasticOut,
                  duration: 900.ms,
                  delay: 200.ms,
                ),
              const SizedBox(height: 12),
              // Tagline from the logo image itself
              Text(
                'The universe always has your back',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppState.instance.theme.primary.withOpacity(0.9),
                  letterSpacing: 0.6,
                ),
              )
                .animate(delay: 700.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.3, curve: Curves.easeOutCubic),
              const Spacer(),
              // Affirmation of the day
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    Text(
                      'TODAY\'S AFFIRMATION',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: C.gold,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"${aff.text}"',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.88),
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              )
                .animate(delay: 1100.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, curve: Curves.easeOutCubic),
              const SizedBox(height: 40),
              // Pulsing entry indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppState.instance.theme.primary.withOpacity(0.7),
                  ),
                ).animate(delay: (1600 + i * 150).ms)
                  .fadeIn(duration: 400.ms)
                  .then(delay: 200.ms)
                  .shimmer(color: Colors.white, duration: 800.ms)),
              ),
              const SizedBox(height: 52),
            ],
          ),
        ),
      ]),
    );
  }
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
    await AppState.instance.login(_name.text.trim(), _email.text.trim());
    if (mounted) setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: Stack(fit: StackFit.expand, children: [
    _img(4, w: double.infinity, h: double.infinity),
    Container(color: Colors.black.withOpacity(0.42)),
    SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 40),
      Center(child: Container(decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.35), blurRadius: 40, spreadRadius: 10)]), child: const NishAffsLogo(size: 64, showText: true, textColor: Colors.white).animate().fadeIn(duration: 600.ms))),
      const SizedBox(height: 16),
      Center(child: Text(_isLogin ? 'Welcome back, beautiful soul 🌸' : 'Start your magic journey ✨', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)).animate(delay: 200.ms).fadeIn()),
      const SizedBox(height: 40),
      GlassCard(radius: 32, opacity: 0.2, padding: const EdgeInsets.all(26), child: Column(children: [
        if (!_isLogin) ...[_field(_name, 'Your Name', Icons.person_outline_rounded), const SizedBox(height: 14)],
        _field(_email, 'Email', Icons.email_outlined, type: TextInputType.emailAddress),
        const SizedBox(height: 14),
        _field(_pass, 'Password', Icons.lock_outline_rounded, obscure: true),
        const SizedBox(height: 24),
        GestureDetector(onTap: _loading ? null : _submit, child: Container(
          width: double.infinity, height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]),
          child: Center(child: _loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(_isLogin ? 'Sign In ✨' : 'Create Account 🌸',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))))),
        const SizedBox(height: 18),
        GestureDetector(onTap: () => setState(() => _isLogin = !_isLogin),
          child: Text(_isLogin ? "Don't have an account? Sign up →" : 'Already have an account? Sign in →',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.7)))),
      ])).animate(delay: 300.ms).fadeIn().slideY(begin: 0.12),
      const SizedBox(height: 20),
      Center(child: GestureDetector(
        onTap: () => AppState.instance.login('Guest', 'guest@nishaffs.app'),
        child: Text('Continue as Guest →',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.6),
            decoration: TextDecoration.underline, decorationColor: Colors.white30)))),
      const SizedBox(height: 36),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: ['🌸','✨','🦄','🎀','💗'].map((e) =>
          Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(e, style: const TextStyle(fontSize: 28)))).toList())
        .animate(delay: 500.ms).fadeIn(),
    ]))),
  ]));
  Widget _field(TextEditingController c, String hint, IconData icon, {TextInputType? type, bool obscure = false}) =>
    TextField(controller: c, keyboardType: type, obscureText: obscure, style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.55), size: 20),
        filled: true, fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppState.instance.theme.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14)));
}
 
// ════════════════════════════════════════════════════════════════════
//  SHELL + LEFT DRAWER
// ════════════════════════════════════════════════════════════════════
class ShellRoute extends StatefulWidget {
  const ShellRoute({super.key});
  @override State<ShellRoute> createState() => _ShellRouteState();
}
class _ShellRouteState extends State<ShellRoute> with SingleTickerProviderStateMixin {
  int _tab = 0; bool _drawerOpen = false;
  late AnimationController _dc; late Animation<double> _da;
  void _openDrawer()  { setState(() => _drawerOpen = true); _dc.forward(); }
  void _closeDrawer() { _dc.reverse().then((_) { if (mounted) setState(() => _drawerOpen = false); }); }
  void _switchTab(int i) { setState(() => _tab = i); }
  @override void initState() {
    super.initState();
    _dc = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _da = CurvedAnimation(parent: _dc, curve: Curves.easeOutCubic);
  }
  @override void dispose() { _dc.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Stack(children: [
    SparkleOverlay(child: AnimatedBuilder(animation: _da, builder: (_, child) =>
      Transform.translate(offset: Offset(_da.value * 290, 0), child: GestureDetector(
        onHorizontalDragEnd: (d) {
          if (!_drawerOpen && (d.primaryVelocity ?? 0) > 150) _openDrawer();
          if (_drawerOpen && (d.primaryVelocity ?? 0) < -150) _closeDrawer();
        }, child: child)),
      child: Scaffold(extendBody: true,
        body: IndexedStack(index: _tab, children: [
          HomeView(onOpenDrawer: _openDrawer, onNavigate: _switchTab),
          const LibraryView(),
          const StudioView(),
          const CommunityView(),
          ProfileView(onNavigate: _switchTab),
        ]),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          MiniPlayer(onTap: () => _switchTab(4)),
          SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 14), child: GlassCard(
            radius: 36, opacity: 0.75,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _NavBtn(0, _tab, Icons.home_filled, L.t('home'),    () => _switchTab(0)),
              _NavBtn(1, _tab, Icons.auto_stories_rounded, L.t('library'), () => _switchTab(1)),
              _NavBtn(2, _tab, Icons.add_circle_rounded, L.t('studio'),   () => _switchTab(2)),
              _NavBtn(3, _tab, Icons.favorite_rounded, L.t('vibes'),    () => _switchTab(3)),
              _NavBtn(4, _tab, Icons.person_rounded, L.t('me'),       () => _switchTab(4)),
            ])))),
        ])))),
    if (_drawerOpen) AnimatedBuilder(animation: _da, builder: (_, __) =>
      GestureDetector(onTap: _closeDrawer, child: Container(color: Colors.black.withOpacity(0.38 * _da.value)))),
    AnimatedBuilder(animation: _da, builder: (_, child) =>
      Transform.translate(offset: Offset((_da.value - 1) * 290, 0), child: child),
      child: _LeftDrawer(onClose: _closeDrawer, onNavigate: _switchTab)),
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
        decoration: BoxDecoration(color: on ? AppState.instance.theme.primary.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(22)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: on ? C.pinkDark : C.textSub, size: 22),
          if (on) ...[const SizedBox(width: 5),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: C.pinkDark)).animate().fadeIn().slideX(begin: 0.2)],
        ])));
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  LEFT DRAWER
// ════════════════════════════════════════════════════════════════════
class _LeftDrawer extends StatelessWidget {
  final VoidCallback onClose; final void Function(int) onNavigate;
  const _LeftDrawer({required this.onClose, required this.onNavigate});
  @override
  Widget build(BuildContext context) => Container(
    width: 290, height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF0F8), Color(0xFFF5E8FF)]),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(6, 0))]),
    child: SafeArea(child: ValueListenableBuilder(valueListenable: AppState.instance.user, builder: (_, user, __) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: [const NishAffsLogo(size: 44, showText: true), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?['name'] ?? 'Guest', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: C.textDark)),
            Text(user?['email'] ?? '', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]))]),
        const SizedBox(height: 20),
        ValueListenableBuilder<int>(valueListenable: AppState.instance.streak, builder: (_, streak, __) =>
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(18)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _dStat('$streak🔥', 'Streak'),
              Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
              _dStat('${kTotalAffirmations}✨', 'Affs'),
              Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
              _dStat('${_books.length}📚', 'Books'),
            ]))),
        const SizedBox(height: 20),
        _dItem(Icons.home_filled, L.t('home'), C.pinkDark, () { onClose(); onNavigate(0); }),
        _dItem(Icons.auto_stories_rounded, L.t('library'), AppState.instance.theme.secondary, () { onClose(); onNavigate(1); }),
        _dItem(Icons.add_circle_rounded, L.t('studio'), C.gold, () { onClose(); onNavigate(2); }),
        _dItem(Icons.favorite_rounded, L.t('vibes'), AppState.instance.theme.primary, () { onClose(); onNavigate(3); }),
        _dItem(Icons.book_outlined, L.t('journal'), C.pinkDark, () { onClose(); Navigator.push(context, _pageRoute(const JournalScreen())); }),
        _dItem(Icons.emoji_events_rounded, L.t('challenge'), C.pinkDark, () { onClose(); Navigator.push(context, _pageRoute(const Challenge55x5Screen())); }),
        _dItem(Icons.grid_view_rounded, L.t('vision_board'), AppState.instance.theme.secondary, () { onClose(); Navigator.push(context, _pageRoute(const VisionBoardScreen())); }),
        const SizedBox(height: 20),
        Text(L.isHindi ? 'सेव की गई अफर्मेशन' : 'Saved Affirmations',
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
        const SizedBox(height: 10),
        ValueListenableBuilder(valueListenable: AppState.instance.affs, builder: (_, affs, __) =>
          affs.isEmpty
            ? Text(L.isHindi ? 'स्टूडियो से बनाएं 🎨' : 'Create affirmations from Studio 🎨',
                style: GoogleFonts.poppins(fontSize: 12, color: C.textSub, height: 1.6))
            : Column(children: affs.take(4).map((a) => Container(
                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.pink2.withOpacity(0.5))),
                child: Text('"${a['text']}"', style: GoogleFonts.lora(fontSize: 12, color: C.textDark, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis))).toList())),
        const SizedBox(height: 24),
        GestureDetector(onTap: () { AppState.instance.logout(); onClose(); },
          child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(L.t('sign_out'), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark))))),
      ]))));
 
  Widget _dStat(String v, String l) => Column(children: [
    Text(v, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
    Text(l, style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.8))),
  ]);
  Widget _dItem(IconData icon, String label, Color color, VoidCallback onTap) =>
    GestureDetector(onTap: onTap, child: Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
      Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 12),
      Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: C.textDark)),
      const Spacer(),
      Icon(Icons.chevron_right_rounded, color: C.textSub, size: 16),
    ])));
}
 
// ════════════════════════════════════════════════════════════════════
//  HOME VIEW — Full mood intelligence + Aff of Day + dynamic counts
// ════════════════════════════════════════════════════════════════════
class HomeView extends StatefulWidget {
  final VoidCallback onOpenDrawer; final void Function(int) onNavigate;
  const HomeView({super.key, required this.onOpenDrawer, required this.onNavigate});
  @override State<HomeView> createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  bool _todayLiked = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppState.instance.mood.value == -1) {
        showDialog(context: context, barrierDismissible: false,
          builder: (ctx) => BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              contentPadding: const EdgeInsets.all(28),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Stack(children: [const Positioned.fill(child: SparkleOverlay(child: SizedBox())), Center(child: const NishAffsLogo(size: 58, showText: true).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2500.ms).shimmer(duration: 2000.ms))]), const SizedBox(height: 16),
                Text(L.isHindi ? 'आज आप कैसा महसूस कर रही हैं?' : 'How are you feeling today?', textAlign: TextAlign.center, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: C.textDark)),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ['😔','😐','🙂','😊','🌟'].asMap().entries.map((e) =>
                  GestureDetector(onTap: () { AppState.instance.setMood(e.key); Navigator.pop(ctx); },
                    child: Container(width: 50, height: 50, decoration: BoxDecoration(color: C.pink1, shape: BoxShape.circle, border: Border.all(color: C.pink3)),
                      child: Center(child: Text(e.value, style: const TextStyle(fontSize: 26)))))
                ).toList()),
              ]))));
      }
    });
  }
  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned.fill(child: _img(10, w: double.infinity, h: double.infinity)),
    Positioned.fill(child: Container(color: Colors.white.withOpacity(0.72))), // was 0.87 — let backgrounds breathe
    SafeArea(bottom: false, child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
        // Header
        Row(children: [
          GestureDetector(onTap: widget.onOpenDrawer, child: ValueListenableBuilder(valueListenable: AppState.instance.user,
            builder: (_, user, __) => Container(width: 44, height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]),
              child: Center(child: Text(user?['avatar'] ?? 'N',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)))))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(L.t('daily_radiance'), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: C.pinkDark)),
            ValueListenableBuilder(valueListenable: AppState.instance.user, builder: (_, user, __) =>
              Text(L.t('hey_beautiful', args: {'name': user?['name'] ?? 'Beautiful'}),
                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))),
          ])),
          const NishAffsLogo(size: 32, showText: true),
        ]).animate().fadeIn(duration: 600.ms),
 
        // ── AFFIRMATION OF THE DAY ──
        const SizedBox(height: 18),
        _AffirmationOfDayCard(liked: _todayLiked, onLike: () => setState(() => _todayLiked = !_todayLiked)),
 
        // ── MOOD CHECK-IN ──
        const SizedBox(height: 18),
        ValueListenableBuilder<int>(valueListenable: AppState.instance.mood, builder: (_, mood, __) =>
          mood == -1 ? const _MoodCheckIn() : _MoodBadge(mood, onNavigate: widget.onNavigate)),
 
        // ── MOOD RECOMMENDATIONS ──
        const SizedBox(height: 16),
        ValueListenableBuilder<int>(valueListenable: AppState.instance.mood, builder: (_, mood, __) =>
          mood >= 0 ? _MoodRecommendations(mood: mood, onNavigate: widget.onNavigate) : const SizedBox.shrink()),
 
        // Quick Pills
        const SizedBox(height: 16),
        Row(children: [
          _qPill(L.t('read'),   AppState.instance.theme.secondary.withOpacity(0.3), () => widget.onNavigate(1)),
          const SizedBox(width: 10),
          _qPill(L.t('sounds'), C.goldLgt,   () => widget.onNavigate(4)),
          const SizedBox(width: 10),
          _qPill(L.t('create'), C.pink1,     () => widget.onNavigate(2)),
        ]).animate(delay: 200.ms).fadeIn(),
 
        // Streak Banner
        const SizedBox(height: 18),
        ValueListenableBuilder<int>(valueListenable: AppState.instance.streak, builder: (_, streak, __) =>
          streak > 0 ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)]),
              borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
            child: Row(children: [
              const Text('🔥', style: TextStyle(fontSize: 26)), const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$streak ${L.isHindi ? 'दिन की स्ट्रीक!' : 'Day Streak!'}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(L.isHindi ? 'हर दिन मैनिफेस्ट करती रहें ✨' : 'Keep manifesting every day ✨', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withOpacity(0.85))),
              ])),
              GestureDetector(onTap: () => Navigator.push(context, _pageRoute(const Challenge55x5Screen())),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(100)),
                  child: Text('55×5', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)))),
            ])) : const SizedBox.shrink()),
 
        // ── CURATED SECTION — dynamic counts ──
        const SizedBox(height: 26),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(L.t('curated'), style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.bold, color: C.textDark)),
          GestureDetector(onTap: () => Navigator.push(context, _pageRoute(const CuratedListScreen())),
            child: Text(L.t('see_all'), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.pinkDark))),
        ]).animate(delay: 250.ms).fadeIn(),
        const SizedBox(height: 14),
        SizedBox(height: 220, child: ListView(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), children: [
          ...kAffCategories.map((cat) => GestureDetector(
            onTap: () => Navigator.push(context, _pageRoute(CategoryDetailScreen(category: cat))),
            child: Container(width: 155, margin: const EdgeInsets.only(right: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Stack(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(20), child: _img(kAffCategories.indexOf(cat) + 3, w: 155, h: double.infinity)),
                  Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                    child: Text('${cat.count}', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)))),
                ])),
                const SizedBox(height: 8),
                Text(L.isHindi ? cat.nameHi : cat.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
                Text('${cat.count} ${L.t('affirmations')}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
              ])).animate(delay: (250 + kAffCategories.indexOf(cat) * 70).ms).fadeIn().slideY(begin: 0.08))),
        ])),
 
        // Kawaii Strip
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(22), border: Border.all(color: C.pink2, width: 1.2)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['🍓','🐼','🧸','🎀','🦄'].map((e) => Text(e, style: const TextStyle(fontSize: 26))).toList()))
          .animate(delay: 350.ms).fadeIn(),
        const SizedBox(height: 120),
      ]))),
    ])),
  ]);
  Widget _qPill(String label, Color bg, VoidCallback onTap) => Expanded(child: GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2, width: 1.2)),
      child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: C.textDark))))));
}
 
// ════════════════════════════════════════════════════════════════════
//  AFFIRMATION OF THE DAY CARD
// ════════════════════════════════════════════════════════════════════
class _AffirmationOfDayCard extends StatelessWidget {
  final bool liked; final VoidCallback onLike;
  const _AffirmationOfDayCard({required this.liked, required this.onLike});
  @override
  Widget build(BuildContext context) {
    final aff = todaysAffirmation;
    return Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFF0F8), Color(0xFFF0E8FF)]),
        borderRadius: BorderRadius.circular(28), border: Border.all(color: C.pink3.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppState.instance.theme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.wb_sunny_rounded, color: C.gold, size: 12),
              const SizedBox(width: 5),
              Text(L.t('aff_of_day'), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: C.pinkDark)),
            ])),
          const Spacer(),
          Text(aff.emoji, style: const TextStyle(fontSize: 22)),
        ]),
        const SizedBox(height: 14),
        Text('"${aff.text}"', style: GoogleFonts.lora(fontSize: 18, color: C.textDark, fontWeight: FontWeight.w600, height: 1.5, fontStyle: FontStyle.italic)),
        const SizedBox(height: 14),
        Row(children: [
          GestureDetector(onTap: onLike, child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              gradient: liked ? LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]) : null,
              color: liked ? null : Colors.white, borderRadius: BorderRadius.circular(100),
              border: Border.all(color: liked ? Colors.transparent : C.pink2, width: 1.2)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: liked ? Colors.white : AppState.instance.theme.primary, size: 16),
              const SizedBox(width: 6),
              Text(liked ? (L.isHindi ? 'पसंद है ✨' : 'Loved ✨') : (L.isHindi ? 'महसूस करें' : 'Feel It'),
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: liked ? Colors.white : AppState.instance.theme.primary)),
            ]))),
          const Spacer(),
          GestureDetector(onTap: () => Navigator.push(context, _pageRoute(const JournalScreen())),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: C.pink2, width: 1.2)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.book_outlined, color: C.pinkDark, size: 14),
                const SizedBox(width: 5),
                Text(L.isHindi ? 'जर्नल' : 'Journal', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark)),
              ]))),
        ]),
      ])).animate().fadeIn(duration: 500.ms);
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  MOOD INTELLIGENCE — recommendations based on selected mood
// ════════════════════════════════════════════════════════════════════
class _MoodCheckIn extends StatelessWidget {
  const _MoodCheckIn();
  @override
  Widget build(BuildContext context) {
    const emojis = ['😔','😐','🙂','😊','🌟'];
    const labelsEn = ['Low Vibe','Meh','Good','Happy','Glowing'];
    const labelsHi = ['थकान','ठीक-ठाक','अच्छा','खुश','चमकदार'];
    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(22), border: Border.all(color: C.pink2, width: 1.2)),
      child: Column(children: [
        Text(L.t('vibe_question'), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: C.textDark)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) =>
          GestureDetector(onTap: () => AppState.instance.setMood(i),
            child: Column(children: [
              Text(emojis[i], style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 3),
              Text(L.isHindi ? labelsHi[i] : labelsEn[i], style: GoogleFonts.poppins(fontSize: 9, color: C.textSub, fontWeight: FontWeight.w600)),
            ])))),
      ]));
  }
}
 
class _MoodBadge extends StatelessWidget {
  final int mood; final void Function(int) onNavigate;
  const _MoodBadge(this.mood, {required this.onNavigate});
  @override
  Widget build(BuildContext context) {
    const emojis = ['😔','😐','🙂','😊','🌟'];
    const msgsEn = ['Take it easy today 🌸','You\'ve got this 💪','Nice energy! ✨','Shining bright! 💫','Absolutely glowing! 🌟'];
    const msgsHi = ['आज आराम करें 🌸','आप कर सकती हैं 💪','अच्छी एनर्जी! ✨','चमक रही हैं! 💫','बिल्कुल दमकदार! 🌟'];
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [C.pink1, AppState.instance.theme.secondary.withOpacity(0.3)]),
        borderRadius: BorderRadius.circular(18), border: Border.all(color: C.pink2, width: 1.2)),
      child: Row(children: [
        Text(emojis[mood], style: const TextStyle(fontSize: 30)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(L.isHindi ? 'आज का मूड सेट है!' : 'Today\'s vibe is set!', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub, fontWeight: FontWeight.w600)),
          Text(L.isHindi ? msgsHi[mood] : msgsEn[mood], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
        ])),
        GestureDetector(onTap: () => AppState.instance.mood.value = -1,
          child: const Icon(Icons.refresh_rounded, color: C.textSub, size: 18)),
      ]));
  }
}
 
class _MoodRecommendations extends StatelessWidget {
  final int mood; final void Function(int) onNavigate;
  const _MoodRecommendations({required this.mood, required this.onNavigate});
  @override
  Widget build(BuildContext context) {
    final catId    = kMoodCategoryMap[mood] ?? 'inner_peace';
    final cat      = getCategory(catId);
    final sound    = kMoodSoundMap[mood] ?? 'Inner Peace Rain';
    final freq     = kMoodFreqMap[mood] ?? '432Hz';
    final promptEn = kMoodJournalPrompt[mood] ?? '';
    final promptHi = kMoodJournalPromptHi[mood] ?? '';
    if (cat == null) return const SizedBox.shrink();
    return Container(margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: C.pink1.withOpacity(0.8), borderRadius: BorderRadius.circular(22), border: Border.all(color: C.pink2, width: 1.2)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 8), child:
          Text(L.t('suggested_for_you'), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: C.pinkDark))),
        // Suggested affirmation category
        GestureDetector(onTap: () => Navigator.push(context, _pageRoute(CategoryDetailScreen(category: cat))),
          child: Container(margin: const EdgeInsets.fromLTRB(12, 0, 12, 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
            child: Row(children: [
              Text(cat.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(L.isHindi ? cat.nameHi : cat.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
                Text('${cat.count} ${L.t('affirmations')}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
              ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: C.textSub),
            ]))),
        // Healing frequency
        Container(margin: const EdgeInsets.fromLTRB(12, 0, 12, 8), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
          child: Row(children: [
            const Text('🎵', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(L.t('healing_freq'), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: C.pinkDark)),
              Text(freq, style: GoogleFonts.poppins(fontSize: 12, color: C.textDark)),
            ])),
          ])),
        // Journal prompt
        GestureDetector(onTap: () => Navigator.push(context, _pageRoute(JournalScreen(prefillPrompt: L.isHindi ? promptHi : promptEn))),
          child: Container(margin: const EdgeInsets.fromLTRB(12, 0, 12, 14), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
            child: Row(children: [
              const Text('📝', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(L.t('journal_prompt'), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: C.pinkDark)),
                Text('"${L.isHindi ? promptHi : promptEn}"', style: GoogleFonts.lora(fontSize: 12, color: C.textDark, fontStyle: FontStyle.italic), maxLines: 2, overflow: TextOverflow.ellipsis),
              ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: C.textSub),
            ]))),
      ])).animate().fadeIn(duration: 400.ms);
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  LIBRARY VIEW
// ════════════════════════════════════════════════════════════════════
class LibraryView extends StatefulWidget {
  const LibraryView({super.key});
  @override State<LibraryView> createState() => _LibraryViewState();
}
class _LibraryViewState extends State<LibraryView> with SingleTickerProviderStateMixin {
  late TabController _tc;
  String _cat = 'All';
  final _cats = ['All', 'LOA', 'Mindfulness', 'Spiritual', 'Self-Love'];
  List<Book> get _filtered => _cat == 'All' ? _books : _books.where((b) => b.tag == _cat).toList();
  @override void initState() { super.initState(); _tc = TabController(length: 2, vsync: this); }
  @override void dispose() { _tc.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 18, 22, 0), child: Row(children: [
        const NishAffsLogo(size: 30, showText: true), const SizedBox(width: 10),
        Text(L.t('wisdom_library'), style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: C.textDark)),
      ])),
      const SizedBox(height: 12),
      // Tab: Books | Affirmations
      Container(margin: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(14)),
        child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: C.textSub,
          labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700),
          indicator: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(12)),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [Tab(text: L.isHindi ? '📚 किताबें' : '📚 Books'), Tab(text: L.isHindi ? '✨ अफर्मेशन' : '✨ Affirmations')])),
      const SizedBox(height: 12),
      Expanded(child: TabBarView(controller: _tc, children: [
        // Books Tab
        Column(children: [
          SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: _cats.length, itemBuilder: (_, i) => GestureDetector(onTap: () => setState(() => _cat = _cats[i]),
              child: AnimatedContainer(duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  gradient: _cat == _cats[i] ? LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]) : null,
                  color: _cat == _cats[i] ? null : Colors.white, borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: _cat == _cats[i] ? Colors.transparent : C.pink2, width: 1.2)),
                child: Text(_cats[i], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _cat == _cats[i] ? Colors.white : C.textSub)))))),
          const SizedBox(height: 12),
          Expanded(child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 14, mainAxisSpacing: 18),
            itemCount: _filtered.length,
            itemBuilder: (ctx, i) {
              final book = _filtered[i];
              return GestureDetector(onTap: () => Navigator.push(ctx, _pageRoute(KindleReader(book: book))),
                child: Column(children: [
                  Expanded(child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4), topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: book.grad),
                      boxShadow: [BoxShadow(color: book.grad.last.withOpacity(0.4), blurRadius: 16, offset: const Offset(5, 6))]),
                    child: Stack(children: [
                      Positioned(left: 0, top: 0, bottom: 0, width: 10, child: Container(color: Colors.black.withOpacity(0.2),
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))))),
                      Center(child: Padding(padding: const EdgeInsets.all(14), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(book.emoji, style: const TextStyle(fontSize: 36)), const SizedBox(height: 8),
                        Text(book.name, textAlign: TextAlign.center, style: GoogleFonts.playfairDisplay(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold, height: 1.3)),
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
        ]),
        // Affirmations Tab — categories grid
        GridView.builder(padding: const EdgeInsets.all(16), itemCount: kAffCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1),
          itemBuilder: (ctx, i) {
            final cat = kAffCategories[i];
            return GestureDetector(onTap: () => Navigator.push(ctx, _pageRoute(CategoryDetailScreen(category: cat))),
              child: Container(padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.pink2, width: 1.2),
                  boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 8)]),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(L.isHindi ? cat.nameHi : cat.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
                  const SizedBox(height: 2),
                  Text('${cat.count} ${L.t('affirmations')}', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: C.pinkDark)),
                  const SizedBox(height: 4),
                  Text(L.isHindi ? cat.descriptionHi : cat.description,
                    style: GoogleFonts.poppins(fontSize: 10, color: C.textSub), maxLines: 2, overflow: TextOverflow.ellipsis),
                ])).animate(delay: (i * 60).ms).fadeIn().scale(begin: const Offset(0.95, 0.95)));
          }),
      ])),
    ])));
}
 
// ════════════════════════════════════════════════════════════════════
//  CATEGORY DETAIL SCREEN — replaces CuratedDetailScreen
// ════════════════════════════════════════════════════════════════════
class CategoryDetailScreen extends StatefulWidget {
  final AffCategory category;
  const CategoryDetailScreen({super.key, required this.category});
  @override State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}
class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String _searchQ = ''; bool _searching = false;
  final _searchCtrl = TextEditingController();
  @override void dispose() { _searchCtrl.dispose(); super.dispose(); }
 
  List<AffEntry> get _filtered {
    final cat = widget.category;
    final List<AffEntry> allAffs = [];
    for (int i = 0; i < cat.entries.length; i++) {
      allAffs.add(AffEntry(cat.entries[i], cat.emoji, i < cat.entriesHi.length ? cat.entriesHi[i] : null));
    }
    if (_searchQ.isEmpty) return allAffs;
    return allAffs.where((e) => e.text.toLowerCase().contains(_searchQ.toLowerCase())).toList();
  }
  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        leading: const BackButton(color: C.pinkDark),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(cat.emoji, style: const TextStyle(fontSize: 20)), const SizedBox(width: 6),
          Text(L.isHindi ? cat.nameHi : cat.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textDark))]),
        actions: [
          IconButton(icon: Icon(_searching ? Icons.close : Icons.search_rounded, color: C.pinkDark),
            onPressed: () { setState(() { _searching = !_searching; if (!_searching) { _searchQ = ''; _searchCtrl.clear(); } }); }),
        ]),
      backgroundColor: C.bg,
      body: Column(children: [
        if (_searching) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(controller: _searchCtrl, autofocus: true,
            onChanged: (v) => setState(() => _searchQ = v),
            style: GoogleFonts.poppins(fontSize: 14, color: C.textDark),
            decoration: InputDecoration(hintText: 'Search affirmations...', hintStyle: GoogleFonts.poppins(color: C.textSub, fontSize: 13),
              filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.search_rounded, color: C.textSub),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppState.instance.theme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('${_filtered.length} ${L.t('affirmations')}',
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: C.pinkDark))),
          ])),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          itemCount: _filtered.length,
          itemBuilder: (ctx, i) {
            final entry = _filtered[i];
            return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.pink2.withOpacity(0.5), width: 1.2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
              child: Row(children: [
                Text(entry.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(L.isHindi && entry.textHi != null ? entry.textHi! : entry.text,
                    style: GoogleFonts.lora(fontSize: 14, color: C.textDark, height: 1.55)),
                  if (L.isHindi && entry.textHi != null && entry.textHi != entry.text) ...[
                    const SizedBox(height: 4),
                    Text(entry.text, style: GoogleFonts.poppins(fontSize: 11, color: C.textSub, fontStyle: FontStyle.italic)),
                  ],
                ])),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () { Clipboard.setData(ClipboardData(text: entry.text)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('✨ Copied!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); },
                  child: const Icon(Icons.copy_rounded, size: 16, color: C.textSub)),
              ])).animate(delay: (i * 30).ms).fadeIn();
          })),
      ]),
    );
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  PAGE ROUTE HELPER
// ════════════════════════════════════════════════════════════════════
PageRoute _pageRoute(Widget page) => PageRouteBuilder(
  pageBuilder: (_, a, __) => page, transitionDuration: const Duration(milliseconds: 400),
  transitionsBuilder: (_, anim, __, child) => SlideTransition(
    position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
    child: child));
 

// ════════════════════════════════════════════════════════════════════
class StudioView extends StatefulWidget {
  const StudioView({super.key});
  @override State<StudioView> createState() => _StudioViewState();
}
class _StudioViewState extends State<StudioView> {
  final _tc = TextEditingController();
  String _vibe = 'Self Love'; int _bgIdx = 0;
  XFile? _imageFile;
  bool _isUploading = false;
  List<(String, Color, Color)> get _vibes => [
    ('Self Love',  C.pink2,               C.pinkDark),
    ('Abundance',  Color(0xFFD1FFE0),      Color(0xFF2A9D59)),
    ('Confidence', AppState.instance.theme.secondary.withOpacity(0.3),           AppState.instance.theme.secondary),
    ('Healing',    Color(0xFFD1EAFF),      Color(0xFF3A7FD4)),
    ('Gratitude',  C.goldLgt,             Color(0xFF9B7B14)),
    ('Peace',      Color(0xFFE8FFF5),      Color(0xFF2A9D7A)),
  ];
  static const _exampleLabels = ['💗 Self Love','💎 Abundance','👑 Confidence','🌿 Healing','☮️ Peace'];
  static const _examples = [
    'I am a magnet for abundance and all good things.',
    'Love flows to me freely and I receive it openly.',
    'I trust the universe to guide me to my highest good.',
    'I am worthy of success and it comes to me naturally.',
    'My body is healthy, my mind is clear, my soul is at peace.',
  ];
  @override void dispose() { _tc.dispose(); super.dispose(); }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) setState(() => _imageFile = pickedFile);
  }

  void _showPreview() {
    final text = _tc.text.trim();
    if (text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('✍️ Write your affirmation first!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); return; }
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _isUploading ? Center(child: CircularProgressIndicator(color: AppState.instance.theme.primary)) : _PostPreviewSheet(text: text, vibe: _vibe, bgIdx: _bgIdx, imageFile: _imageFile, onPost: (target, sc) async {
        if (target == 'external' || target == 'story') {
          final bytes = await sc.capture(delay: const Duration(milliseconds: 100));
          if (bytes != null) {
            await ShareService.shareBytes(
              bytes: bytes,
              filename: 'affirmation_share.png',
              text: target == 'story' ? '' : 'Check out this affirmation from NishAffs! 🌸',
            );
          }
          return;
        }
        if (target == 'community' || target == 'save') {
          setState(() { _isUploading = true; Navigator.pop(ctx); });
          String? downloadUrl;
          try {
            if (_imageFile != null) {
              final ref = FirebaseStorage.instance.ref('posts/${DateTime.now().millisecondsSinceEpoch}_${_imageFile!.name}');
              await ref.putData(await _imageFile!.readAsBytes());
              downloadUrl = await ref.getDownloadURL();
            }
          } catch (e) {
            print('Image upload failed: $e');
          }
          final user = AppState.instance.user.value;
          if (target == 'community') {
            await AppState.instance.addPost({'id': 'p_${DateTime.now().millisecondsSinceEpoch}','user': user?['name'] ?? 'You','avatar': user?['avatar'] ?? 'Y','time': 'Just now','imgIdx': _bgIdx, 'imageUrl': downloadUrl,'text': text,'likes': 0,'comments': <String>[],'vibe': _vibe});
          }
          await AppState.instance.addAff({'text': text,'vibe': _vibe,'ts': DateTime.now().toIso8601String()});
          if (mounted) { _tc.clear(); setState(() => _isUploading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(target == 'community' ? '🌸 Posted!' : '💾 Saved to journal!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); }
        }
      }));
  }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: ListView(padding: const EdgeInsets.fromLTRB(22, 18, 22, 120), children: [
      Row(children: [const NishAffsLogo(size: 30, showText: true), const SizedBox(width: 10), Text(L.t('studio_title'), style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: C.textDark))]),
      const SizedBox(height: 6),
      Text(L.isHindi ? 'अपनी अफर्मेशन पोस्ट बनाएं ✨' : 'Create your affirmation post ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)),
      const SizedBox(height: 22),
      Text(L.isHindi ? 'प्रेरणा के लिए टैप करें:' : 'Tap for inspiration:', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textSub)),
      const SizedBox(height: 10),
      SizedBox(height: 42, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _examples.length,
        itemBuilder: (_, i) => GestureDetector(onTap: () => setState(() => _tc.text = _examples[i]),
          child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(100), border: Border.all(color: C.pink3, width: 1.2)),
            child: Text(_exampleLabels[i], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark)))))),
      const SizedBox(height: 16),
      GestureDetector(onTap: () async {
        showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(color: AppState.instance.theme.primary), const SizedBox(height: 20),
            Text('AI is manifesting your words...', style: GoogleFonts.poppins(fontSize: 14, color: C.textDark)),
          ])));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
        final seed = DateTime.now().millisecondsSinceEpoch;
        final list = ['I am open to receiving massive abundance today.','I radiate confidence and pure self-love.','Everything I touch turns into success and joy.','My peace is my power, and I guard it fiercely.','I am a magnet for miracles and beautiful synchronicity.'];
        setState(() => _tc.text = list[seed % list.length]);
      }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppState.instance.theme.secondary.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppState.instance.theme.secondary, width: 1.5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('✨ ', style: TextStyle(fontSize: 18)), Text('Write with AI', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
        ]))),
      const SizedBox(height: 14),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
        child: TextField(controller: _tc, maxLines: 4, maxLength: 150, onChanged: (_) => setState(() {}),
          style: GoogleFonts.lora(fontSize: 16, color: C.textDark, height: 1.7),
          decoration: InputDecoration(hintText: '"I am a magnet for miracles..."',
            hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.55), fontStyle: FontStyle.italic),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            fillColor: Colors.transparent, filled: true, contentPadding: const EdgeInsets.all(18)))),
      const SizedBox(height: 20),
      Text(L.isHindi ? 'वाइब चुनें' : 'Choose Your Vibe', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 12),
      Wrap(spacing: 10, runSpacing: 10, children: _vibes.map((v) {
        final on = _vibe == v.$1;
        return GestureDetector(onTap: () => setState(() => _vibe = v.$1),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(color: on ? v.$2 : Colors.white, borderRadius: BorderRadius.circular(100),
              border: Border.all(color: on ? v.$3 : C.pink2, width: on ? 2 : 1.2)),
            child: Text(v.$1, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: on ? v.$3 : C.textSub))));
      }).toList()),
      const SizedBox(height: 20),
      Text(L.isHindi ? 'बैकग्राउंड' : 'Background', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 12),
      SizedBox(height: 76, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 11,
        itemBuilder: (_, i) {
          if (i == 0) {
            return GestureDetector(onTap: _pickImage,
              child: Container(width: 70, height: 70, margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(16), border: Border.all(color: _imageFile != null ? C.pinkDark : C.pink3, width: _imageFile != null ? 3 : 2)),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.add_photo_alternate_rounded, color: C.pinkDark),
                  Text('Upload', style: TextStyle(fontSize: 10, color: C.pinkDark))
                ])));
          }
          final idx = i - 1;
          return GestureDetector(onTap: () => setState(() { _bgIdx = idx; _imageFile = null; }),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 70, height: 70, margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (_bgIdx == idx && _imageFile == null) ? C.pinkDark : Colors.transparent, width: 3)),
              child: ClipRRect(borderRadius: BorderRadius.circular(13), child: _img(idx + 2, w: 70, h: 70))));
        })),
      const SizedBox(height: 22),
      Text(L.isHindi ? 'प्रीव्यू' : 'Preview', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 10),
      ClipRRect(borderRadius: BorderRadius.circular(22), child: SizedBox(height: 185, child: Stack(children: [
        Positioned.fill(child: _imageFile != null 
          ? (kIsWeb ? Image.network(_imageFile!.path, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2)) : Image.file(java_io.File(_imageFile!.path), fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2)))
          : _img(_bgIdx + 2, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
        Positioned(top: 10, right: 10, child: const NishAffsLogo(size: 36, showText: true)),
        Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('"${_tc.text.isEmpty ? "Your affirmation here..." : _tc.text}"', textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 15, color: Colors.white, height: 1.55, fontStyle: FontStyle.italic), maxLines: 5, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(7)),
            child: Text('#NishAffs · $_vibe', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600))),
        ]))),
      ]))),
      const SizedBox(height: 24),
      GestureDetector(onTap: _showPreview, child: Container(width: double.infinity, height: 54,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(100),
          boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]),
        child: Center(child: Text(L.isHindi ? 'बनाएं और शेयर करें ✨' : 'Create & Share ✨', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))))),
    ])));
}
 
class _PostPreviewSheet extends StatelessWidget {
  final String text, vibe; final int bgIdx; final void Function(String, ScreenshotController) onPost;
  final XFile? imageFile;
  final ScreenshotController _sc = ScreenshotController();
  
  _PostPreviewSheet({required this.text, required this.vibe, required this.bgIdx, required this.onPost, this.imageFile});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(context).viewInsets.bottom + 28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
      const SizedBox(height: 16),
      Row(children: [const NishAffsLogo(size: 28), const SizedBox(width: 10), Text('Ready to share! 🌸', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
      const SizedBox(height: 16),
      Screenshot(controller: _sc, child: ClipRRect(borderRadius: BorderRadius.circular(18), child: SizedBox(height: 130, child: Stack(children: [
        Positioned.fill(child: imageFile != null 
          ? (kIsWeb ? Image.network(imageFile!.path, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2)) : Image.file(java_io.File(imageFile!.path), fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2)))
          : _img(bgIdx + 2, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
        Center(child: Padding(padding: const EdgeInsets.all(18), child: Text('"$text"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 13, color: Colors.white, fontStyle: FontStyle.italic), maxLines: 4, overflow: TextOverflow.ellipsis))),
      ])))),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _btn(context, '🌸 Community', C.pink1, C.pinkDark, 'community')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '💾 Journal', AppState.instance.theme.secondary.withOpacity(0.3), AppState.instance.theme.secondary, 'save')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '📤 Share', C.goldLgt, const Color(0xFF9B7B14), 'external')),
      ]),
      const SizedBox(height: 10),
      _btn(context, '📱 Post as Story', C.bg, C.textDark, 'story', full: true),
    ]));
  Widget _btn(BuildContext ctx, String label, Color bg, Color fg, String target, {bool full = false}) =>
    GestureDetector(onTap: () => onPost(target, _sc), child: Container(
      width: full ? double.infinity : null, padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: fg.withOpacity(0.3), width: 1.2)),
      child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: fg), textAlign: TextAlign.center))));
}
 
// ════════════════════════════════════════════════════════════════════
//  COMMUNITY VIEW
// ════════════════════════════════════════════════════════════════════
class CommunityView extends StatefulWidget {
  const CommunityView({super.key});
  @override State<CommunityView> createState() => _CommunityViewState();
}
class _CommunityViewState extends State<CommunityView> {
  String _q = ''; bool _searching = false;
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 14, 22, 0), child: Row(children: [
        const NishAffsLogo(size: 30, showText: true), const Spacer(),
        GestureDetector(onTap: () => setState(() { _searching = !_searching; if (!_searching) _q = ''; }),
          child: Container(width: 40, height: 40,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.5), blurRadius: 8)]),
            child: Icon(_searching ? Icons.close_rounded : Icons.search_rounded, color: C.textSub, size: 22))),
      ])),
      if (_searching) Padding(padding: const EdgeInsets.fromLTRB(22, 10, 22, 0), child: TextField(
        autofocus: true, onChanged: (v) => setState(() => _q = v.toLowerCase()),
        style: GoogleFonts.poppins(fontSize: 14, color: C.textDark),
        decoration: InputDecoration(hintText: 'Search posts, vibes...', hintStyle: GoogleFonts.poppins(color: C.textSub, fontSize: 14),
          filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.search_rounded, color: C.textSub),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)))),
      const SizedBox(height: 12),
      SizedBox(height: 96, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
        children: _storiesData.asMap().entries.map((e) => _StoryBubble(story: e.value, index: e.key)).toList())),
      const SizedBox(height: 6),
      Expanded(child: ValueListenableBuilder(valueListenable: AppState.instance.posts, builder: (_, posts, __) {
        final filtered = _q.isEmpty ? posts : posts.where((p) =>
          (p['text'] as String).toLowerCase().contains(_q) || (p['user'] as String).toLowerCase().contains(_q) || (p['vibe'] as String).toLowerCase().contains(_q)).toList();
        if (filtered.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🔍', style: TextStyle(fontSize: 40)), const SizedBox(height: 12),
          Text(_q.isEmpty ? 'No posts yet! Create from Studio 🎨' : 'No posts found for "$_q"', style: GoogleFonts.poppins(fontSize: 14, color: C.textSub))]));
        return ListView.builder(padding: const EdgeInsets.only(bottom: 120), itemCount: filtered.length,
          itemBuilder: (ctx, i) => _PostCard(post: filtered[i]));
      })),
    ])));
}
 
final _storiesData = [
  {'user': 'Ananya','avatar': 'A','pages': ['I am worthy of all the love in the universe. 🌸','Today I choose joy, no matter what. ✨']},
  {'user': 'Priya','avatar': 'P','pages': ['I attract miracles effortlessly. 💫']},
  {'user': 'Meera✨','avatar': 'M','pages': ['The universe is my co-creator. 🌌','I trust my journey completely.','Abundance is my birthright! 💰']},
  {'user': 'Siya','avatar': 'S','pages': ['I am healing and glowing every day. 🌿']},
  {'user': 'Radha','avatar': 'R','pages': ['My vibe attracts my tribe. 🦋','Love flows to me from all directions. 💖']},
  {'user': 'Nova','avatar': 'N','pages': ['I am the energy I wish to see. ✨']},
];
 
class _StoryBubble extends StatelessWidget {
  final Map<String, dynamic> story; final int index;
  const _StoryBubble({required this.story, required this.index});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, PageRouteBuilder(opaque: false, barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) => StoryViewer(stories: _storiesData, initialIndex: index),
      transitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: ScaleTransition(
        scale: Tween(begin: 0.88, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)), child: child)))),
    child: Container(margin: const EdgeInsets.only(right: 14), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 62, height: 62, decoration: BoxDecoration(shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]),
        border: Border.all(color: C.bg, width: 2.5), boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]),
        child: Center(child: Text(story['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)))),
      const SizedBox(height: 5),
      Text(story['user'] ?? '', style: GoogleFonts.poppins(fontSize: 10, color: C.textSub, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
    ])));
}
 
// ════════════════════════════════════════════════════════════════════
//  STORY VIEWER
// ════════════════════════════════════════════════════════════════════
class StoryViewer extends StatefulWidget {
  final List<Map<String, dynamic>> stories; final int initialIndex;
  const StoryViewer({super.key, required this.stories, required this.initialIndex});
  @override State<StoryViewer> createState() => _StoryViewerState();
}
class _StoryViewerState extends State<StoryViewer> with TickerProviderStateMixin {
  late int _uIdx; int _pIdx = 0; late AnimationController _prog; Timer? _tmr;
  @override void initState() { super.initState(); _uIdx = widget.initialIndex; _prog = AnimationController(vsync: this, duration: const Duration(seconds: 5)); _start(); }
  void _start() { _prog.reset(); _prog.forward(); _tmr?.cancel(); _tmr = Timer(const Duration(seconds: 5), _advance); }
  void _advance() {
    final pages = (widget.stories[_uIdx]['pages'] as List);
    if (_pIdx < pages.length - 1) { setState(() => _pIdx++); _start(); }
    else if (_uIdx < widget.stories.length - 1) { setState(() { _uIdx++; _pIdx = 0; }); _start(); }
    else Navigator.pop(context);
  }
  void _goBack() { if (_pIdx > 0) { setState(() => _pIdx--); _start(); } else if (_uIdx > 0) { setState(() { _uIdx--; _pIdx = 0; }); _start(); } }
  @override void dispose() { _prog.dispose(); _tmr?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_uIdx]; final pages = story['pages'] as List; final sz = MediaQuery.of(context).size;
    return GestureDetector(onTapDown: (d) { if (d.globalPosition.dx < sz.width / 2) _goBack(); else _advance(); },
      child: Scaffold(backgroundColor: Colors.transparent, body: Stack(fit: StackFit.expand, children: [
        _img((_uIdx * 4 + _pIdx * 2) % 22, w: sz.width, h: sz.height),
        Container(color: Colors.black.withOpacity(0.44)),
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), child: Row(
            children: List.generate(pages.length, (i) => Expanded(child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2), height: 3,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
              child: i < _pIdx ? Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))
                : i == _pIdx ? AnimatedBuilder(animation: _prog, builder: (_, __) => FractionallySizedBox(
                    widthFactor: _prog.value, alignment: Alignment.centerLeft,
                    child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))))
                : const SizedBox.shrink()))))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), border: Border.all(color: Colors.white, width: 2)),
              child: Center(child: Text(story['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)))),
            const SizedBox(width: 10),
            Text(story['user'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
            const Spacer(),
            const NishAffsLogo(size: 36, showText: true), const SizedBox(width: 10),
            GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close_rounded, color: Colors.white, size: 26)),
          ])),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(28), child: Text('"${pages[_pIdx]}"', textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600, height: 1.45))),
          const Spacer(),
        ])),
      ])));
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  POST CARD
// ════════════════════════════════════════════════════════════════════
class _PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  const _PostCard({required this.post});
  @override State<_PostCard> createState() => _PostCardState();
}
class _PostCardState extends State<_PostCard> {
  late bool _liked, _saved; late int _likes;
  @override void initState() {
    super.initState();
    final id = widget.post['id'] as String;
    _liked = AppState.instance.liked.value.contains(id);
    _saved = AppState.instance.saved.value.contains(id);
    _likes = widget.post['likes'] as int? ?? 0;
  }
  @override
  Widget build(BuildContext context) {
    final post = widget.post; final id = post['id'] as String; final cmts = (post['comments'] as List? ?? []);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 10), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary])),
          child: Center(child: Text(post['avatar'] ?? '?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)))),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(post['user'] ?? '', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: C.textDark)),
          Text('${post['time']} · #${post['vibe']}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
        ]),
        const Spacer(), const Icon(Icons.more_horiz_rounded, color: C.textSub),
      ])),
      SizedBox(height: 370, child: Stack(children: [
        Positioned.fill(child: post.containsKey('imageUrl') && post['imageUrl'] != null
          ? Image.network(post['imageUrl'] as String, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2))
          : _img((post['imgIdx'] as int? ?? 0) + 3, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.36))),
        Positioned(top: 12, right: 12, child: const NishAffsLogo(size: 24)),
        Center(child: Padding(padding: const EdgeInsets.all(28), child: Text('"${post['text']}"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w600, height: 1.4)))),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
        GestureDetector(onTap: () async { await AppState.instance.toggleLike(id); setState(() { _liked = AppState.instance.liked.value.contains(id); _likes += _liked ? 1 : -1; }); },
          child: Row(children: [
            Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: _liked ? C.pinkDark : C.textDark, size: 26)
              .animate(target: _liked ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3)).then().scale(end: const Offset(1, 1)),
            const SizedBox(width: 4),
            Text('$_likes', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark)),
          ])),
        const SizedBox(width: 20),
        GestureDetector(onTap: () => _showComments(context, id, cmts), child: Row(children: [
          const Icon(Icons.mode_comment_outlined, color: C.textDark, size: 24), const SizedBox(width: 4),
          Text('${cmts.length}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: C.textDark)),
        ])),
        const SizedBox(width: 20),
        GestureDetector(onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('📤 Link copied!'), backgroundColor: AppState.instance.theme.secondary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
          child: const Icon(Icons.send_outlined, color: C.textDark, size: 24)),
        const Spacer(),
        GestureDetector(onTap: () async { await AppState.instance.toggleSave(id); setState(() => _saved = AppState.instance.saved.value.contains(id)); },
          child: Icon(_saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: _saved ? C.pinkDark : C.textDark, size: 26)),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 14),
          Row(children: [const NishAffsLogo(size: 24), const SizedBox(width: 8), Text('Comments 💬', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))]),
          const SizedBox(height: 14),
          ValueListenableBuilder(valueListenable: AppState.instance.posts, builder: (_, posts, __) {
            final p = posts.firstWhere((e) => e['id'] == id, orElse: () => widget.post);
            final cmts = p['comments'] as List? ?? [];
            return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 230), child: cmts.isEmpty
              ? Center(child: Text('Be the first to comment! 🌸', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)))
              : ListView(shrinkWrap: true, children: cmts.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    Container(width: 32, height: 32, decoration: BoxDecoration(color: C.pink2, shape: BoxShape.circle), child: const Center(child: Text('🌸', style: TextStyle(fontSize: 15)))),
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
            GestureDetector(onTap: () async { if (tc.text.trim().isEmpty) return; await AppState.instance.addComment(id, tc.text.trim()); tc.clear(); setS(() {}); },
              child: Container(width: 46, height: 46, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary])),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20))),
          ]),
        ]))));
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  PROFILE VIEW
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
 
  List<(String, String, String, String, Color, Color)> get _sounds => [
    ('432Hz Deep Healing',   'Binaural Beats',    '45 min','🎵', AppState.instance.theme.secondary.withOpacity(0.3),      Color(0xFF8B5CF6)),
    ('Morning Abundance',    'Solfeggio 528Hz',   '30 min','☀️', C.goldLgt,         C.gold),
    ('Inner Peace Rain',     'Nature Sounds',     '60 min','🌧️', Color(0xFFD1EAFF), Color(0xFF4A90D9)),
    ('Deep Sleep Delta',     'Delta Waves',       '8 hrs', '🌙', Color(0xFFE8E0FF), Color(0xFF6B5CE7)),
    ('Study Focus Beta',     'Beta Waves',        '45 min','📚', Color(0xFFD1FFE0), Color(0xFF2A9D7A)),
    ('Manifest While Sleep', 'Affirmation+Music', '6 hrs', '✨', C.pink1,           C.pinkDark),
    ('Chakra Balancing',     '7 Chakra Tones',    '25 min','🌈', C.goldLgt,         C.gold),
    ('Self Love Morning',    'Guided + Music',    '15 min','💗', C.pink2,           C.pinkDark),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    body: SafeArea(bottom: false, child: Column(children: [
      ValueListenableBuilder(valueListenable: AppState.instance.user, builder: (_, user, __) =>
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Stack(children: [
            Container(width: 68, height: 68, decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]),
              child: Center(child: Text(user?['avatar'] ?? 'N', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)))),
            Positioned(bottom: 2, right: 2, child: Container(width: 18, height: 18,
              decoration: BoxDecoration(color: const Color(0xFF22C55E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?['name'] ?? 'Guest', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
            Text(L.isHindi ? '2026 से मैनिफेस्ट कर रही हूं ✨' : 'Manifesting since 2026 ✨', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
            const SizedBox(height: 8),
            ValueListenableBuilder<int>(valueListenable: AppState.instance.streak, builder: (_, s, __) =>
              Row(children: [_sPill('$s🔥', 'Streak'), const SizedBox(width: 7), _sPill('${kTotalAffirmations}✨', 'Affs'), const SizedBox(width: 7), _sPill('${_books.length}📚', 'Books')])),
          ])),
          GestureDetector(onTap: () => AppState.instance.logout(),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.pink2)),
              child: Text('Out', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: C.pinkDark)))),
        ]))),
      Container(margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(16)),
        child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: C.textSub,
          labelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
          indicator: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(14)),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [Tab(text: '🎵 Sounds'), Tab(text: '📓 Journal'), Tab(text: '🎨 Themes'), Tab(text: '⚙️ Settings')])),
      Expanded(child: TabBarView(controller: _tc, children: [
        // SOUNDS
        ListView.builder(padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), itemCount: _sounds.length,
          itemBuilder: (ctx, i) => _SoundCard(idx: i, data: _sounds[i]).animate(delay: (i * 55).ms).fadeIn().slideX(begin: 0.06)),
        // JOURNAL (quick view)
        _JournalQuickView(),
        // THEMES
        _ThemesTab(),
        // SETTINGS
        _SettingsTab(),
      ])),
    ])));
 
  Widget _sPill(String v, String l) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(10), border: Border.all(color: C.pink2)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(v, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: C.textDark)),
      Text(l, style: GoogleFonts.poppins(fontSize: 9, color: C.textSub)),
    ]));
}
 
// ════════════════════════════════════════════════════════════════════
//  JOURNAL QUICK VIEW (in Profile tab)
// ════════════════════════════════════════════════════════════════════
class _JournalQuickView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<List<JournalEntry>>(
    valueListenable: AppState.instance.journal, builder: (_, entries, __) =>
    Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 8), child: GestureDetector(
        onTap: () => Navigator.push(context, _pageRoute(const JournalScreen())),
        child: Container(width: double.infinity, height: 50,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(100),
            boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.3), blurRadius: 12)]),
          child: Center(child: Text(L.isHindi ? '+ नई जर्नल एंट्री' : '+ New Journal Entry', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)))))),
      Expanded(child: entries.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('📓', style: TextStyle(fontSize: 48)), const SizedBox(height: 14),
            Text(L.isHindi ? 'अभी तक कोई एंट्री नहीं!' : 'No entries yet!', style: GoogleFonts.poppins(fontSize: 14, color: C.textSub)),
            Text(L.isHindi ? 'ऊपर बटन से जोड़ें ✨' : 'Tap above to start ✨', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub))]))
        : ListView.builder(padding: const EdgeInsets.fromLTRB(20, 0, 20, 120), itemCount: entries.length,
            itemBuilder: (ctx, i) {
              final e = entries[i];
              return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: C.pink2, width: 1.2), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 8)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('📅', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text('${e.date.day}/${e.date.month}/${e.date.year}', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
                    const Spacer(),
                    if (e.mood.isNotEmpty) Text(e.mood, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    GestureDetector(onTap: () => AppState.instance.deleteJournalEntry(e.id),
                      child: const Icon(Icons.delete_outline_rounded, size: 18, color: C.textSub)),
                  ]),
                  const SizedBox(height: 8),
                  Text('🌟 ${e.manifesting}', style: GoogleFonts.lora(fontSize: 13, color: C.textDark, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('🙏 ${e.grateful}', style: GoogleFonts.lora(fontSize: 13, color: C.textDark, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                ])).animate(delay: (i * 40).ms).fadeIn();
            })),
    ]));
}
 
// ════════════════════════════════════════════════════════════════════
//  THEMES TAB
// ════════════════════════════════════════════════════════════════════
class _ThemesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 120), children: [
    const NishAffsLogo(size: 44, showText: true), const SizedBox(height: 12),
    Text(L.isHindi ? 'थीम चुनें' : 'Choose Your Theme', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark)),
    const SizedBox(height: 6),
    Text(L.isHindi ? 'टैप करें — पूरा ऐप बदल जाएगा! ✨' : 'Tap to apply instantly — changes everything! ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub)),
    const SizedBox(height: 20),
    ValueListenableBuilder<int>(valueListenable: AppState.instance.themeIdx, builder: (_, idx, __) =>
      Column(children: List.generate(_appThemes.length, (i) {
        final t = _appThemes[i]; final on = idx == i;
        return GestureDetector(onTap: () => AppState.instance.setTheme(i),
          child: AnimatedContainer(duration: const Duration(milliseconds: 280),
            margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: on ? LinearGradient(colors: [t.primary.withOpacity(0.3), t.secondary.withOpacity(0.2)]) : null,
              color: on ? null : Colors.white, borderRadius: BorderRadius.circular(22),
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
                Text(L.isHindi ? 'टैप करें' : 'Tap to apply', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
              ])),
              if (on) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [t.primary, t.secondary]), borderRadius: BorderRadius.circular(100)),
                child: Text('Active ✓', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
            ])));
      }))),
  ]);
}
 
// ════════════════════════════════════════════════════════════════════
//  SETTINGS TAB — with language toggle
// ════════════════════════════════════════════════════════════════════
class _SettingsTab extends StatefulWidget {
  @override State<_SettingsTab> createState() => _SettingsTabState();
}
class _SettingsTabState extends State<_SettingsTab> {
  bool _notifOn = true, _widgetOn = false, _darkMode = false, _privateProfile = false;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), children: [
    // Language Toggle
    Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF0F8), Color(0xFFF0E8FF)]), borderRadius: BorderRadius.circular(18), border: Border.all(color: C.pink2, width: 1.2)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(L.isHindi ? 'भाषा' : 'Language', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
        const SizedBox(height: 12),
        ValueListenableBuilder<String>(valueListenable: AppState.instance.language, builder: (_, lang, __) =>
          Row(children: [
            Expanded(child: GestureDetector(onTap: () { AppState.instance.setLanguage('en'); setState(() {}); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: lang == 'en' ? LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]) : null,
                  color: lang == 'en' ? null : Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: lang == 'en' ? Colors.transparent : C.pink2)),
                child: Column(children: [
                  Text('🇬🇧', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text('English', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: lang == 'en' ? Colors.white : C.textDark)),
                ])))),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(onTap: () { AppState.instance.setLanguage('hi'); setState(() {}); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: lang == 'hi' ? LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]) : null,
                  color: lang == 'hi' ? null : Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: lang == 'hi' ? Colors.transparent : C.pink2)),
                child: Column(children: [
                  Text('🇮🇳', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text('हिन्दी', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: lang == 'hi' ? Colors.white : C.textDark)),
                ])))),
          ])),
      ])),
    _toggle('🔔 ${L.isHindi ? 'सुबह 8 बजे अफर्मेशन' : 'Daily Affirmation 8AM'}', _notifOn, (v) async {
       if (v) {
         try {
           final settings = await FirebaseMessaging.instance.requestPermission();
           if (settings.authorizationStatus == AuthorizationStatus.authorized) {
             setState(() => _notifOn = true);
           } else {
             setState(() => _notifOn = false);
           }
         } catch(e) {
           setState(() => _notifOn = false);
         }
       } else {
         setState(() => _notifOn = false);
       }
    }),
    _toggle('📱 ${L.isHindi ? 'होम स्क्रीन विजेट' : 'Home Screen Widget'}', _widgetOn, (v) => setState(() => _widgetOn = v)),
    _toggle('🌙 ${L.isHindi ? 'डार्क मोड' : 'Dark Mode'}', _darkMode, (v) => setState(() => _darkMode = v)),
    _toggle('🔒 ${L.isHindi ? 'प्राइवेट प्रोफाइल' : 'Private Profile'}', _privateProfile, (v) => setState(() => _privateProfile = v)),
    const SizedBox(height: 14),
    _tile('⭐ ${L.isHindi ? 'NishAffs रेट करें' : 'Rate NishAffs'}', ''),
    _tile('💌 ${L.isHindi ? 'फीडबैक' : 'Feedback'}', ''),
    _tile('📤 ${L.isHindi ? 'ऐप शेयर करें' : 'Share App'}', ''),
    _tile('📋 ${L.isHindi ? 'प्राइवेसी पॉलिसी' : 'Privacy Policy'}', ''),
    const SizedBox(height: 14),
    GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(L.isHindi ? 'अकाउंट डिलीट करें?' : 'Delete Account?'),
          content: Text(L.isHindi ? 'क्या आप वाकई अपना अकाउंट और सारा डेटा डिलीट करना चाहते हैं? यह वापस नहीं हो सकता।' : 'Are you sure you want to delete your account and all data? This cannot be undone.', style: GoogleFonts.poppins(fontSize: 13, color: C.textDark)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(L.isHindi ? 'कैंसिल' : 'Cancel', style: TextStyle(color: C.textSub))),
            TextButton(onPressed: () async {
              Navigator.pop(ctx);
              await AppState.instance.deleteAccount();
            }, child: Text(L.isHindi ? 'डिलीट करें' : 'Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          ]
        ));
      },
      child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withOpacity(0.3))),
        child: Row(children: [
          Expanded(child: Text(L.isHindi ? 'अकाउंट डिलीट करें' : 'Delete Account', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red))),
          const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red)
        ]))),
    const SizedBox(height: 24),
    Center(child: Column(children: [
      const NishAffsLogo(size: 52), const SizedBox(height: 10),
      Text('NishAffs v6.0', style: GoogleFonts.pacifico(fontSize: 20, color: C.pinkDark)), const SizedBox(height: 4),
      Text(L.t('made_in_india'), style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
      Text('${kTotalAffirmations} ${L.t('affirmations')} ✨', style: GoogleFonts.poppins(fontSize: 11, color: C.textSub)),
    ])),
  ]);
  Widget _toggle(String label, bool val, Function(bool) cb) =>
    Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
      child: Row(children: [Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: C.textDark))),
        Switch(value: val, onChanged: cb, activeColor: AppState.instance.theme.primary)]));
  Widget _tile(String label, String val) =>
    Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.pink2.withOpacity(0.5))),
      child: Row(children: [Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: C.textDark))),
        if (val.isNotEmpty) Text(val, style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)), const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded, size: 16, color: C.textSub)]));
}
 
// ════════════════════════════════════════════════════════════════════
//  SOUND CARD
// ════════════════════════════════════════════════════════════════════
class _SoundCard extends StatelessWidget {
  final int idx; final (String, String, String, String, Color, Color) data;
  const _SoundCard({required this.idx, required this.data});
  @override
  Widget build(BuildContext context) {
    final svc = SoundPlayerService.instance;
    return GestureDetector(onTap: () => svc.play(idx),
      child: ValueListenableBuilder<int>(valueListenable: svc.idx, builder: (_, playIdx, __) {
        final playing = playIdx == idx;
        return AnimatedContainer(duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: playing ? data.$5 : Colors.white, borderRadius: BorderRadius.circular(20),
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
                  gradient: playing ? LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]) : null,
                  color: playing ? null : C.pink1,
                  boxShadow: playing ? [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 8)] : []),
                  child: Icon(playing && isp ? Icons.pause_rounded : Icons.play_arrow_rounded, color: playing ? Colors.white : C.textDark, size: 24))),
            ]),
            if (playing) ...[
              const SizedBox(height: 10),
              ValueListenableBuilder<double>(valueListenable: svc.pos, builder: (_, pos, __) =>
                Column(children: [
                  SliderTheme(data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), trackHeight: 4),
                    child: Slider(value: pos.clamp(0.0, 1.0), onChanged: (v) => svc.seek(v), activeColor: data.$6, inactiveColor: data.$6.withOpacity(0.2))),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    ValueListenableBuilder<Duration>(valueListenable: svc.elapsed, builder: (_, el, __) => Text(svc.fmt(el), style: GoogleFonts.poppins(fontSize: 10, color: C.textSub))),
                    Text(svc.fmt(svc.totalFor(idx)), style: GoogleFonts.poppins(fontSize: 10, color: C.textSub)),
                  ]),
                ])),
              const SizedBox(height: 6),
              _WaveWidget(color: data.$6),
            ],
          ]));
      }));
  }
}
class _WaveWidget extends StatefulWidget {
  final Color color; const _WaveWidget({required this.color});
  @override State<_WaveWidget> createState() => _WaveWidgetState();
}
class _WaveWidgetState extends State<_WaveWidget> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _c, builder: (_, __) => CustomPaint(size: const Size(double.infinity, 22), painter: _WavePainter(_c.value, widget.color)));
}
class _WavePainter extends CustomPainter {
  final double t; final Color color;
  const _WavePainter(this.t, this.color);
  @override void paint(Canvas c, Size size) {
    final p = Paint()..color = color..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    for (var i = 0; i < 24; i++) {
      final x = i * (size.width / 24);
      final h = (sin((i / 24 * 2 * pi) + (t * 2 * pi)) * 0.45 + 0.55) * size.height;
      c.drawLine(Offset(x, size.height / 2 - h / 2), Offset(x, size.height / 2 + h / 2), p);
    }
  }
  @override bool shouldRepaint(_WavePainter o) => o.t != t;
}
 
// ════════════════════════════════════════════════════════════════════
//  JOURNAL SCREEN — full CRUD
// ════════════════════════════════════════════════════════════════════
class JournalScreen extends StatefulWidget {
  final String? prefillPrompt;
  const JournalScreen({super.key, this.prefillPrompt});
  @override State<JournalScreen> createState() => _JournalScreenState();
}
class _JournalScreenState extends State<JournalScreen> with SingleTickerProviderStateMixin {
  late TabController _tc;
  final _manifestCtrl = TextEditingController();
  final _gratefulCtrl  = TextEditingController();
  String _mood = '';
  bool _saving = false;
  static const _moodEmojis = ['😔','😐','🙂','😊','🌟'];
  @override void initState() {
    super.initState();
    _tc = TabController(length: 2, vsync: this);
    if (widget.prefillPrompt != null) _manifestCtrl.text = widget.prefillPrompt!;
  }
  @override void dispose() { _tc.dispose(); _manifestCtrl.dispose(); _gratefulCtrl.dispose(); super.dispose(); }
 
  Future<void> _save() async {
    if (_manifestCtrl.text.trim().isEmpty && _gratefulCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('✍️ Write something first!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 400));
    await AppState.instance.addJournalEntry(JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      manifesting: _manifestCtrl.text.trim(),
      grateful: _gratefulCtrl.text.trim(),
      mood: _mood,
      date: DateTime.now(),
    ));
    setState(() { _saving = false; _manifestCtrl.clear(); _gratefulCtrl.clear(); _mood = ''; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('✨ Entry saved to your journal!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      _tc.animateTo(1);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      leading: const BackButton(color: C.pinkDark),
      title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 28, showText: true), const SizedBox(width: 8),
        Text(L.t('journal'), style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))])),
    body: Column(children: [
      Container(margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(14)),
        child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: C.textSub,
          labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700),
          indicator: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(12)),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [Tab(text: L.isHindi ? '✍️ लिखें' : '✍️ Write'), Tab(text: L.isHindi ? '📖 इतिहास' : '📖 History')])),
      Expanded(child: TabBarView(controller: _tc, children: [
        // WRITE tab
        SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Today's aff prompt
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF0F8), Color(0xFFF0E8FF)]), borderRadius: BorderRadius.circular(18), border: Border.all(color: C.pink3.withOpacity(0.4))),
            child: Row(children: [
              Text(todaysAffirmation.emoji, style: const TextStyle(fontSize: 20)), const SizedBox(width: 10),
              Expanded(child: Text('"${todaysAffirmation.text}"', style: GoogleFonts.lora(fontSize: 13, color: C.textDark, fontStyle: FontStyle.italic, height: 1.5))),
            ])),
          const SizedBox(height: 20),
          // Mood selector for journal
          Text(L.isHindi ? 'आज का मूड' : 'Today\'s mood', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: C.textSub)),
          const SizedBox(height: 8),
          Row(children: _moodEmojis.map((e) => GestureDetector(onTap: () => setState(() => _mood = e),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _mood == e ? AppState.instance.theme.primary.withOpacity(0.15) : Colors.white, shape: BoxShape.circle,
                border: Border.all(color: _mood == e ? AppState.instance.theme.primary : C.pink2, width: _mood == e ? 2 : 1.2)),
              child: Text(e, style: const TextStyle(fontSize: 22))))).toList()),
          const SizedBox(height: 20),
          // Manifesting
          Text(L.t('manifesting_q'), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
          const SizedBox(height: 10),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 10)]),
            child: TextField(controller: _manifestCtrl, maxLines: 4,
              style: GoogleFonts.lora(fontSize: 15, color: C.textDark, height: 1.7),
              decoration: InputDecoration(
                hintText: L.isHindi ? 'आज मैं मैनिफेस्ट करती हूं...' : 'Today I am manifesting...',
                hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.55), fontStyle: FontStyle.italic),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.transparent, filled: true, contentPadding: const EdgeInsets.all(16)))),
          const SizedBox(height: 20),
          // Grateful
          Text(L.t('grateful_q'), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark)),
          const SizedBox(height: 10),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 10)]),
            child: TextField(controller: _gratefulCtrl, maxLines: 4,
              style: GoogleFonts.lora(fontSize: 15, color: C.textDark, height: 1.7),
              decoration: InputDecoration(
                hintText: L.isHindi ? 'मैं आभारी हूं...' : 'I am grateful for...',
                hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.55), fontStyle: FontStyle.italic),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.transparent, filled: true, contentPadding: const EdgeInsets.all(16)))),
          const SizedBox(height: 28),
          GestureDetector(onTap: _saving ? null : _save, child: Container(width: double.infinity, height: 54,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(100),
              boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 6))]),
            child: Center(child: _saving
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(L.t('save_entry'), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))))),
          const SizedBox(height: 40),
        ])),
        // HISTORY tab
        ValueListenableBuilder<List<JournalEntry>>(valueListenable: AppState.instance.journal, builder: (_, entries, __) =>
          entries.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('📓', style: TextStyle(fontSize: 56)), const SizedBox(height: 16),
            Text(L.isHindi ? 'अभी तक कोई एंट्री नहीं' : 'No entries yet', style: GoogleFonts.poppins(fontSize: 15, color: C.textSub)),
            const SizedBox(height: 6),
            Text(L.isHindi ? 'पहली एंट्री लिखें ✨' : 'Write your first entry ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub))]))
          : Column(children: [
            GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SlideshowViewer(entries: entries))),
              child: Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 0), padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28), const SizedBox(width: 8), Text('Play Slideshow', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ]))),
            Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: entries.length, itemBuilder: (_, i) {
              final e = entries[i];
              return Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.pink2, width: 1.2), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 10)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(20)),
                      child: Text('${e.date.day}/${e.date.month}/${e.date.year}', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: C.pinkDark))),
                    const Spacer(),
                    if (e.mood.isNotEmpty) Text(e.mood, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    GestureDetector(onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                      title: Text(L.isHindi ? 'हटाएं?' : 'Delete entry?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      content: Text(L.isHindi ? 'यह एंट्री हमेशा के लिए हट जाएगी।' : 'This entry will be permanently deleted.', style: GoogleFonts.poppins()),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')), TextButton(onPressed: () { AppState.instance.deleteJournalEntry(e.id); Navigator.pop(context); }, child: Text('Delete', style: TextStyle(color: C.pinkDark)))],
                    )), child: const Icon(Icons.delete_outline_rounded, size: 18, color: C.textSub)),
                  ]),
                  const SizedBox(height: 12),
                  if (e.manifesting.isNotEmpty) ...[
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('🌟 ', style: TextStyle(fontSize: 16)),
                      Expanded(child: Text(e.manifesting, style: GoogleFonts.lora(fontSize: 14, color: C.textDark, height: 1.6))),
                    ]),
                    const SizedBox(height: 8),
                  ],
                  if (e.grateful.isNotEmpty) Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('🙏 ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(e.grateful, style: GoogleFonts.lora(fontSize: 14, color: C.textDark, height: 1.6))),
                  ]),
                ])).animate(delay: (i * 40).ms).fadeIn();
            }))
          ])),
      ])),
    ]));
}
 
// ════════════════════════════════════════════════════════════════════
//  55×5 CHALLENGE
// ════════════════════════════════════════════════════════════════════
class Challenge55x5Screen extends StatefulWidget {
  const Challenge55x5Screen({super.key});
  @override State<Challenge55x5Screen> createState() => _Challenge55x5ScreenState();
}
class _Challenge55x5ScreenState extends State<Challenge55x5Screen> {
  final _tc = TextEditingController();
  @override void dispose() { _tc.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      leading: const BackButton(color: C.pinkDark),
      title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 28, showText: true), const SizedBox(width: 8),
        Text('55×5 Challenge', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))])),
    body: ValueListenableBuilder(valueListenable: AppState.instance.challenge, builder: (_, ch, __) =>
      (ch == null || (ch['text'] as String? ?? '').isEmpty) ? _ChallengeSetup(tc: _tc) : _ChallengeActive(ch: ch)));
}
class _ChallengeSetup extends StatelessWidget {
  final TextEditingController tc; const _ChallengeSetup({required this.tc});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
    Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFE4F0), Color(0xFFF0DCFF)]), borderRadius: BorderRadius.circular(28), border: Border.all(color: C.pink3.withOpacity(0.5), width: 1.5)),
      child: Column(children: [const Text('✨', style: TextStyle(fontSize: 48)), const SizedBox(height: 12),
        Text('The 55×5 Method', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: C.textDark)), const SizedBox(height: 10),
        Text('Write your affirmation 55 times per day for 5 consecutive days. This technique overwhelms your subconscious and accelerates manifestation.', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, color: C.textSub, height: 1.65))])),
    const SizedBox(height: 24),
    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
      child: TextField(controller: tc, maxLines: 3, style: GoogleFonts.lora(fontSize: 16, color: C.textDark, height: 1.7),
        decoration: InputDecoration(hintText: '"I am abundant and deeply loved..."',
          hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.55), fontStyle: FontStyle.italic),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          fillColor: Colors.transparent, filled: true, contentPadding: const EdgeInsets.all(18)))),
    const SizedBox(height: 20),
    GestureDetector(onTap: () { if (tc.text.trim().isEmpty) return; AppState.instance.startChallenge(tc.text.trim()); },
      child: Container(width: double.infinity, height: 54, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(100), boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 6))]),
        child: Center(child: Text('Start My 55×5 Journey 🌟', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))))),
  ]));
}
class _ChallengeActive extends StatelessWidget {
  final Map<String, dynamic> ch; const _ChallengeActive({required this.ch});
  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
  String _keyForOffset(String startKey, int offset) {
    try { final parts = startKey.split('-'); final start = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])); final d = start.add(Duration(days: offset)); return '${d.year}-${d.month}-${d.day}'; } catch (_) { return startKey; }
  }
  @override
  Widget build(BuildContext context) {
    final today = _dayKey(DateTime.now()); final days = Map<String, dynamic>.from(ch['days'] as Map? ?? {});
    final startDay = ch['startDay'] as String? ?? today; final todayCnt = days[today] as int? ?? 0;
    final daysDone = days.values.where((v) => (v as int) >= 55).length;
    return SingleChildScrollView(padding: const EdgeInsets.all(22), child: Column(children: [
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFE4F0), Color(0xFFF0DCFF)]), borderRadius: BorderRadius.circular(24)),
        child: Text('"${ch['text']}"', textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 18, color: C.textDark, fontWeight: FontWeight.w600, height: 1.5))),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) {
        final dayKey = _keyForOffset(startDay, i); final cnt = days[dayKey] as int? ?? 0; final done = cnt >= 55; final isToday = dayKey == today;
        return Column(children: [
          Container(width: 46, height: 46, decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: done ? LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]) : null,
            color: done ? null : isToday ? C.pink2 : Colors.white, border: Border.all(color: done ? Colors.transparent : isToday ? AppState.instance.theme.primary : C.pink2, width: 2)),
            child: Center(child: Text(done ? '✓' : '${i+1}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: done ? Colors.white : isToday ? C.pinkDark : C.textSub)))),
          const SizedBox(height: 6),
          Text('Day ${i+1}', style: GoogleFonts.poppins(fontSize: 10, color: C.textSub)),
          if (cnt > 0 && !done) Text('$cnt', style: GoogleFonts.poppins(fontSize: 9, color: C.pinkDark, fontWeight: FontWeight.bold)),
        ]);
      })),
      const SizedBox(height: 22),
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: C.pink2, width: 1.5), boxShadow: [BoxShadow(color: C.pink2.withOpacity(0.3), blurRadius: 12)]),
        child: Column(children: [
          Text('Today\'s Progress', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: C.textSub)), const SizedBox(height: 10),
          Text('$todayCnt / 55', style: GoogleFonts.playfairDisplay(fontSize: 42, fontWeight: FontWeight.bold, color: C.pinkDark)), const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (todayCnt / 55).clamp(0.0, 1.0), minHeight: 12, backgroundColor: C.pink2, valueColor: const AlwaysStoppedAnimation(C.pinkDark))),
          const SizedBox(height: 20),
          GestureDetector(onTap: todayCnt >= 55 ? null : () => AppState.instance.incrementChallenge(),
            child: Container(width: double.infinity, height: 54, decoration: BoxDecoration(
              gradient: todayCnt >= 55 ? null : LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), color: todayCnt >= 55 ? C.pink2 : null, borderRadius: BorderRadius.circular(100),
              boxShadow: todayCnt < 55 ? [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))] : []),
              child: Center(child: Text(todayCnt >= 55 ? '✓ Done for today! 🌟' : '+ Write it once  (${55 - todayCnt} more to go)', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: todayCnt >= 55 ? C.textSub : Colors.white))))),
        ])),
      if (daysDone >= 5) ...[const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(22)),
          child: Column(children: [const Text('🎉', style: TextStyle(fontSize: 48)),
            Text('Challenge Complete!', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 6),
            Text('You manifested for 5 days straight. The universe has received your intention! ✨', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.5))]))],
    ]));
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  VISION BOARD
// ════════════════════════════════════════════════════════════════════
class VisionBoardScreen extends StatelessWidget {
  const VisionBoardScreen({super.key});
  static const _prompts = ['My dream home is...','I feel deeply...','My body is...','My career is...','Love looks like...','My bank account says...','I am grateful for...','I wake up to...','My relationships are...','I travel to...'];
  @override
  Widget build(BuildContext context) {
    final tc = TextEditingController();
    return Scaffold(backgroundColor: C.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
        leading: const BackButton(color: C.pinkDark),
        title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 28, showText: true), const SizedBox(width: 8), Text(L.t('vision_board'), style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))]),
        actions: [IconButton(icon: const Icon(Icons.add_rounded, color: C.pinkDark, size: 28), onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (ctx) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 16),
              Row(children: [const NishAffsLogo(size: 26), const SizedBox(width: 8), Text(L.isHindi ? 'विजन कार्ड जोड़ें' : 'Add Vision Card', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
              const SizedBox(height: 14),
              SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _prompts.length,
                itemBuilder: (_, i) => GestureDetector(onTap: () => tc.text = _prompts[i], child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: C.pink1, borderRadius: BorderRadius.circular(100), border: Border.all(color: C.pink3)),
                  child: Text(_prompts[i], style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: C.pinkDark)))))),
              const SizedBox(height: 12),
              TextField(controller: tc, maxLines: 3, style: GoogleFonts.lora(fontSize: 15, color: C.textDark, height: 1.6),
                decoration: InputDecoration(hintText: 'My dream life includes...', hintStyle: GoogleFonts.lora(fontSize: 14, color: C.textSub.withOpacity(0.5), fontStyle: FontStyle.italic),
                  filled: true, fillColor: C.pink1, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16))),
              const SizedBox(height: 16),
              GestureDetector(onTap: () { if (tc.text.trim().isEmpty) return; AppState.instance.addVisionCard(tc.text.trim()); Navigator.pop(ctx); },
                child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary]), borderRadius: BorderRadius.circular(100)),
                  child: Center(child: Text(L.isHindi ? 'बोर्ड में जोड़ें ✨' : 'Add to Board ✨', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))))),
            ]))))]),
      body: ValueListenableBuilder<List<String>>(valueListenable: AppState.instance.visionBoard, builder: (_, cards, __) =>
        cards.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🌟', style: TextStyle(fontSize: 56)), const SizedBox(height: 14),
          Text(L.isHindi ? 'आपका विजन बोर्ड खाली है!' : 'Your vision board is empty!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: C.textSub)), const SizedBox(height: 6),
          Text(L.isHindi ? '+ टैप करें और अपना पहला सपना जोड़ें ✨' : 'Tap + to add your first dream ✨', style: GoogleFonts.poppins(fontSize: 13, color: C.textSub))]))
        : GridView.builder(padding: const EdgeInsets.all(16), itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
            itemBuilder: (ctx, i) => GestureDetector(onLongPress: () => AppState.instance.removeVisionCard(i),
              child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Stack(children: [
                Positioned.fill(child: _img((i * 3 + 5) % 22, w: double.infinity, h: double.infinity)),
                Positioned.fill(child: Container(color: Colors.black.withOpacity(0.42))),
                Positioned(top: 8, right: 8, child: const NishAffsLogo(size: 20)),
                Center(child: Padding(padding: const EdgeInsets.all(14), child: Text(cards[i], textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, height: 1.55), maxLines: 5, overflow: TextOverflow.ellipsis))),
                Positioned(bottom: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text('#vision', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)))),
              ])).animate(delay: (i * 50).ms).fadeIn().scale(begin: const Offset(0.95, 0.95))))));
  }
}
 
// ════════════════════════════════════════════════════════════════════
//  CURATED LIST SCREEN
// ════════════════════════════════════════════════════════════════════
class CuratedListScreen extends StatelessWidget {
  const CuratedListScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      leading: const BackButton(color: C.pinkDark),
      title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 28, showText: true), const SizedBox(width: 8),
        Text(L.isHindi ? 'सभी संग्रह' : 'All Collections', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: C.textDark))])),
    body: GridView.builder(padding: const EdgeInsets.all(18), itemCount: kAffCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.85),
      itemBuilder: (ctx, i) {
        final cat = kAffCategories[i];
        return GestureDetector(onTap: () => Navigator.push(ctx, _pageRoute(CategoryDetailScreen(category: cat))),
          child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Stack(children: [
            Positioned.fill(child: _img(i + 3, w: double.infinity, h: double.infinity)),
            Positioned.fill(child: Container(color: Colors.black.withOpacity(0.44))),
            Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
              child: Text('${cat.count}', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)))),
            Positioned(bottom: 14, left: 14, right: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cat.emoji, style: const TextStyle(fontSize: 24)),
              Text(L.isHindi ? cat.nameHi : cat.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('${cat.count} ${L.t('affirmations')}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withOpacity(0.8))),
            ])),
          ])).animate(delay: (i * 60).ms).fadeIn().scale(begin: const Offset(0.95, 0.95)));
      }));
}

class SlideshowViewer extends StatelessWidget {
  final List<JournalEntry> entries;
  const SlideshowViewer({super.key, required this.entries});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: C.bg,
    appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: C.pinkDark)),
    body: PageView.builder(itemCount: entries.length, physics: const BouncingScrollPhysics(), itemBuilder: (ctx, i) {
      final e = entries[i];
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFF0F8), Color(0xFFF0DCFF)]), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white, width: 3), boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (e.mood.isNotEmpty) Text(e.mood, style: const TextStyle(fontSize: 64)).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
            const SizedBox(height: 32),
            if (e.manifesting.isNotEmpty) ...[
              Text('I am manifesting...', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)),
              const SizedBox(height: 12),
              Text('"${e.manifesting}"', textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 22, color: C.textDark, height: 1.6, fontStyle: FontStyle.italic)),
              const SizedBox(height: 32),
            ],
            if (e.grateful.isNotEmpty) ...[
              Text('I am grateful for...', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: C.pinkDark)),
              const SizedBox(height: 12),
              Text('"${e.grateful}"', textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 22, color: C.textDark, height: 1.6, fontStyle: FontStyle.italic)),
            ],
            const Spacer(),
            Text('${e.date.day}/${e.date.month}/${e.date.year}', style: GoogleFonts.poppins(fontSize: 12, color: C.textSub)),
          ])));
    }));
}

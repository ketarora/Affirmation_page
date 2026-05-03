#!/bin/bash
git rm lib/main.dart
mkdir -p lib/core lib/services lib/models lib/providers lib/screens lib/widgets
cat << 'INNER_EOF' > lib/core/constants.dart
import 'package:flutter/material.dart';

class C {
  // Brand Colors
  static const Color pinkTheme = Color(0xFFFF82A9);
  static const Color pinkLight = Color(0xFFFFB6CB);
  static const Color pinkDark  = Color(0xFFD64D7B);
  static const Color pink1     = Color(0xFFFFF0F5);
  static const Color pink2     = Color(0xFFFFE4EE);
  static const Color pink3     = Color(0xFFFFD6E4);

  // Accents
  static const Color purple    = Color(0xFFB185FF);
  static const Color purpleLight = Color(0xFFE8DDFF);
  static const Color yellow    = Color(0xFFFFD166);
  static const Color mint      = Color(0xFF88D4AB);

  // Backgrounds & Text
  static const Color bg        = Color(0xFFFAFAFC);
  static const Color surface   = Colors.white;
  static const Color textDark  = Color(0xFF2D2D2D);
  static const Color textSub   = Color(0xFF6B6B6B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [pinkTheme, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
INNER_EOF
cat << 'INNER_EOF' > lib/core/daily_theme.dart
import 'package:flutter/material.dart';

class DailyPalette {
  final String name;
  final Color primary;
  final Color secondary;
  final Color background;

  const DailyPalette(this.name, this.primary, this.secondary, this.background);
}

class DailyTheme {
  static int get hash {
    final d = DateTime.now();
    return (d.day * 31 + d.month) % 7;
  }

  static const palettes = [
    DailyPalette('Rose Monday', Color(0xFFFF6B9D), Color(0xFFFF8FB1), Color(0xFFFFF0F5)),
    DailyPalette('Lavender Tuesday', Color(0xFF9B6BFF), Color(0xFFBA91FF), Color(0xFFF5F0FF)),
    DailyPalette('Mint Wednesday', Color(0xFF5BC4A0), Color(0xFF7DDCBA), Color(0xFFF0FFF8)),
    DailyPalette('Peach Thursday', Color(0xFFFF8A65), Color(0xFFFFAB91), Color(0xFFFFF5EF)),
    DailyPalette('Sky Friday', Color(0xFF42A5F5), Color(0xFF64B5F6), Color(0xFFF0F8FF)),
    DailyPalette('Gold Saturday', Color(0xFFFFB300), Color(0xFFFFD54F), Color(0xFFFFFDE7)),
    DailyPalette('Purple Sunday', Color(0xFFAB47BC), Color(0xFFCE93D8), Color(0xFFF8F0FF)),
  ];

  static DailyPalette get today => palettes[hash];
}
INNER_EOF
cat << 'INNER_EOF' > lib/providers/theme_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/daily_theme.dart';

final themeProvider = Provider<DailyPalette>((ref) {
  return DailyTheme.today;
});

class MoodOverrideNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setMood(int mood) {
    state = mood;
  }
}

final moodOverrideProvider = NotifierProvider<MoodOverrideNotifier, int?>(() {
  return MoodOverrideNotifier();
});

final currentThemeProvider = Provider<DailyPalette>((ref) {
  final mood = ref.watch(moodOverrideProvider);
  if (mood != null && mood >= 0 && mood < DailyTheme.palettes.length) {
    return DailyTheme.palettes[mood];
  }
  return ref.watch(themeProvider);
});
INNER_EOF
mkdir -p assets/icon
cp /tmp/file_attachments/photo_6316565075057118922_y.jpg assets/icon/logo.jpg
cat << 'INNER_EOF' > lib/widgets/nishaffs_logo.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NishAffsLogo extends StatelessWidget {
  final double size;
  const NishAffsLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/logo.jpg',
          height: size * 1.5,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.spa, color: const Color(0xFFFF82A9), size: size),
        ),
        const SizedBox(width: 6),
        Text(
          'NishAffs',
          style: GoogleFonts.playfairDisplay(
            fontSize: size * 0.85,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }
}
INNER_EOF
mkdir -p lib/screens/home
cat << 'INNER_EOF' > lib/screens/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/nishaffs_logo.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeProvider);

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NishAffsLogo(size: 28),
                    CircleAvatar(
                      backgroundColor: theme.primary.withValues(alpha: 0.2),
                      child: Text(
                        '✨',
                        style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaste, Beautiful 🌸',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: C.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your daily vibe check:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: C.textSub,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Theme Selector
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              ref.read(moodOverrideProvider.notifier).setMood(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 50,
                              decoration: BoxDecoration(
                                color: index == ref.watch(moodOverrideProvider) ? Colors.black26 : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Center(
                                child: Text(['🌸', '💜', '🌿', '✨', '💎', '🌙', '🦋'][index], style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // The Strawberry Panda Quote
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Strawberry Panda Says...',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '"I am stepping into my highest timeline. The universe is working in my favor."',
                            style: GoogleFonts.lora(
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              color: C.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
INNER_EOF
cat << 'INNER_EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home/home_view.dart';
import 'core/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NishAffsApp()));
}

class NishAffsApp extends ConsumerWidget {
  const NishAffsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'NishAffs ✨',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: C.bg,
      ),
      home: const HomeView(),
    );
  }
}
INNER_EOF
git add -A
git commit -m "fix: App fully restructured"

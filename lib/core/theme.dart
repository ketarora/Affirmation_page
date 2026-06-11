import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final String name, emoji;
  final Color primary, secondary, bg, card;
  const AppTheme(this.name, this.emoji, this.primary, this.secondary, this.bg, this.card);
}

const kAppThemes = [
  AppTheme('Pink Blossom',   '🌸', Color(0xFFFF82A9), Color(0xFFAC7BED), Color(0xFFFCF4F8), Color(0xFFFFF0F5)),
  AppTheme('Lavender Dream', '💜', Color(0xFFB39DDB), Color(0xFF7C4DFF), Color(0xFFF8F0FF), Color(0xFFEDE7F6)),
  AppTheme('Mint Fresh',     '🌿', Color(0xFF66BB6A), Color(0xFF26A69A), Color(0xFFF0FFF4), Color(0xFFE8F5E9)),
  AppTheme('Golden Hour',    '✨', Color(0xFFFFB74D), Color(0xFFFF8A65), Color(0xFFFFF8E1), Color(0xFFFFF3E0)),
  AppTheme('Rose Night',     '🌹', Color(0xFFE91E63), Color(0xFF880E4F), Color(0xFFFFF0F5), Color(0xFFFCE4EC)),
];

class ThemeIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int val) => state = val;
}

final themeIndexProvider = NotifierProvider<ThemeIndexNotifier, int>(ThemeIndexNotifier.new);

final appThemeProvider = Provider<ThemeData>((ref) {
  final idx = ref.watch(themeIndexProvider);
  final t = kAppThemes[idx];

  return ThemeData(
    scaffoldBackgroundColor: t.bg,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: t.primary),
    useMaterial3: true,
  );
});

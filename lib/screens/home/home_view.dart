import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class MoodOverrideNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void set(int? val) => state = val;
}
final moodOverrideProvider = NotifierProvider<MoodOverrideNotifier, int?>(MoodOverrideNotifier.new);

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final mood = ref.watch(moodOverrideProvider);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NishAffs', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: primary)),
                    CircleAvatar(
                      backgroundColor: primary.withValues(alpha: 0.2),
                      child: Text('✨', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
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
                    Text('Namaste, Beautiful 🌸', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('How\'s your vibe today?', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              ref.read(moodOverrideProvider.notifier).set(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 50,
                              decoration: BoxDecoration(
                                color: index == mood ? Colors.black26 : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Center(
                                child: Text(['🌸', '💜', '🌿', '✨', '💎'][index], style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Theme Selector
                    Text('Select Theme:', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: kAppThemes.length,
                        itemBuilder: (context, index) {
                          final t = kAppThemes[index];
                          return GestureDetector(
                            onTap: () {
                              ref.read(themeIndexProvider.notifier).set(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: t.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: t.primary),
                              ),
                              child: Center(
                                child: Text(t.name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: t.primary)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Affirmation of the Day', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: primary)),
                          const SizedBox(height: 16),
                          Text('"I am stepping into my highest timeline. The universe is working in my favor."', style: GoogleFonts.lora(fontSize: 24, fontStyle: FontStyle.italic)),
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

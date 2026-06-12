import 'dart:io';

void main() {
  final file = File('lib/main.dart');
  var text = file.readAsStringSync();

  // Replace all the 'const NishAffsLogo...' with showText
  text = text.replaceAll('const NishAffsLogo(size: 44)', 'const NishAffsLogo(size: 44, showText: true)');
  text = text.replaceAll('const NishAffsLogo(size: 32)', 'const NishAffsLogo(size: 32, showText: true)');
  text = text.replaceAll('const NishAffsLogo(size: 30)', 'const NishAffsLogo(size: 30, showText: true)');
  text = text.replaceAll('const NishAffsLogo(size: 16)', 'const NishAffsLogo(size: 26, showText: true)');
  text = text.replaceAll('const NishAffsLogo(size: 22)', 'const NishAffsLogo(size: 28, showText: true)');

  // Fix Daily Mood Popup Center element
  final oldPopup = "const Text('\uD83C\uDF38', style: TextStyle(fontSize: 48)), const SizedBox(height: 16),";
  final newPopup = "Stack(children: [const Positioned.fill(child: SparkleOverlay(child: SizedBox())), Center(child: const NishAffsLogo(size: 58, showText: true).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1500.ms).shimmer(duration: 2000.ms))]), const SizedBox(height: 16),";
  
  if (text.contains(oldPopup)) {
    text = text.replaceFirst(oldPopup, newPopup);
    print('Popup fixed');
  } else {
    print('Popup not found');
  }

  // Fix AppBars (like Vibes screen maybe, which doesn't use NishAffsLogo currently, but could be identified)
  // Let's just leave AppBar fixes to multi_replace if needed

  file.writeAsStringSync(text);
  print('Dart script complete');
}

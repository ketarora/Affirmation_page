import re
import io

def main():
    with io.open('lib/main.dart', 'r', encoding='utf-8') as f:
        text = f.read()

    # 1. Imports
    if "import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';" not in text:
        text = text.replace("import 'data/affirmations_data.dart';", "import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';\nimport 'data/affirmations_data.dart';")

    # 2. Colors and Dynamic Themes
    text = re.sub(r'const\s+LinearGradient\(\s*colors:\s*\[C\.pinkTheme,\s*C\.purple\]\)',
                  r'LinearGradient(colors: [AppState.instance.theme.primary, AppState.instance.theme.secondary])', text)
    text = re.sub(r'const\s+BoxShadow\(\s*color:\s*C\.pinkTheme\.withOpacity\(',
                  r'BoxShadow(color: AppState.instance.theme.primary.withOpacity(', text)
    text = text.replace('  static const _colors = [C.pinkTheme, C.purple, C.gold, Colors.white, Color(0xFFFFB3CA), Color(0xFFE9D5FF)];',
                        '  static List<Color> get _colors => [AppState.instance.theme.primary, AppState.instance.theme.secondary, C.gold, Colors.white, Color(0xFFFFB3CA), Color(0xFFE9D5FF)];')

    text = text.replace('C.pinkTheme', 'AppState.instance.theme.primary')
    text = text.replace('C.purple', 'AppState.instance.theme.secondary')

    # 3. Logos
    text = text.replace('const NishAffsLogo(size: 44)', 'const NishAffsLogo(size: 44, showText: true)')
    text = text.replace('const NishAffsLogo(size: 32)', 'const NishAffsLogo(size: 32, showText: true)')
    text = text.replace('const NishAffsLogo(size: 30)', 'const NishAffsLogo(size: 30, showText: true)')
    text = text.replace('const NishAffsLogo(size: 16)', 'const NishAffsLogo(size: 26, showText: true)')
    text = text.replace('const NishAffsLogo(size: 22)', 'const NishAffsLogo(size: 36, showText: true)')

    # Login screen logo & typography center
    login_old = "NishAffsLogo(size: 48, showText: true).animate().fadeIn(duration: 600.ms),\n      const SizedBox(height: 10),\n      Text(_isLogin ? 'Welcome back, beautiful soul \U0001F338' : 'Start your magic journey \u2728',\n        style: GoogleFonts.poppins(fontSize: 15, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w500)).animate(delay: 200.ms).fadeIn(),"
    login_new = "Center(child: Container(decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppState.instance.theme.primary.withOpacity(0.35), blurRadius: 40, spreadRadius: 10)]), child: const NishAffsLogo(size: 64, showText: true).animate().fadeIn(duration: 600.ms))),\n      const SizedBox(height: 16),\n      Center(child: Text(_isLogin ? 'Welcome back, beautiful soul \U0001F338' : 'Start your magic journey \u2728', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)).animate(delay: 200.ms).fadeIn()),"
    text = text.replace(login_old, login_new)

    # Vibes AppBar
    vibes_appbar_old = "title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 24), const SizedBox(width: 8),"
    vibes_appbar_new = "title: Row(mainAxisSize: MainAxisSize.min, children: [const NishAffsLogo(size: 28, showText: true), const SizedBox(width: 8),"
    text = text.replace(vibes_appbar_old, vibes_appbar_new)

    # Daily Mood Popup
    mood_old = "const Text('\U0001F338', style: TextStyle(fontSize: 48)), const SizedBox(height: 16),"
    mood_new = "Stack(children: [const Positioned.fill(child: SparkleOverlay(child: SizedBox())), Center(child: const NishAffsLogo(size: 58, showText: true).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2500.ms).shimmer(duration: 2000.ms))]), const SizedBox(height: 16),"
    text = text.replace(mood_old, mood_new)

    # 4. _books data replace
    books_old = '''class BookPage {
  final String chapter, title, body;
  const BookPage(this.chapter, this.title, this.body);
}
class Book {
  final String name, author, emoji, tag;
  final List<Color> grad;
  final List<BookPage> pages;
  const Book({required this.name, required this.author, required this.emoji,
    required this.tag, required this.grad, required this.pages});
}'''
    books_new = '''class Book {
  final String name, author, emoji, tag, file;
  final List<Color> grad;
  const Book({required this.name, required this.author, required this.emoji,
    required this.tag, required this.grad, required this.file});
}'''
    text = text.replace(books_old, books_new)

    # _books payload
    match_books = re.search(r'const _books = \[.*?\];', text, re.DOTALL)
    if match_books:
        new_books_array = '''const _books = [
  Book(name: 'Dance Your Way to God', author: 'Osho', emoji: '\U0001F483', tag: 'Joy', grad: [Color(0xFFE9D5FF), Color(0xFFFFD1DF)], file: 'Dance Your Way to God.pdf'),
  Book(name: 'From Bondage to Freedom', author: 'Osho', emoji: '\U0001F54A\uFE0F', tag: 'Freedom', grad: [Color(0xFFFFD1DF), Color(0xFFFFF0F5)], file: 'from bondage to freedom.pdf'),
  Book(name: 'From Misery to Enlightenment', author: 'Osho', emoji: '\U0001FABB', tag: 'Awakening', grad: [Color(0xFFAC7BED), Color(0xFFE9D5FF)], file: 'From Misery to Enlightenment.pdf'),
  Book(name: 'Let Go!', author: 'Osho', emoji: '\U0001F343', tag: 'Surrender', grad: [Color(0xFFFFB3CA), Color(0xFFFFD1DF)], file: 'Let Go.pdf'),
  Book(name: 'Nothing to Lose But Your Head', author: 'Osho', emoji: '\U0001F98B', tag: 'Zen', grad: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], file: 'Nothing to Lose but your head.pdf'),
];'''
        text = text.replace(match_books.group(0), new_books_array)

    # 5. KindleReader swap to SfPdfViewer
    kr_match = re.search(r'class KindleReader extends StatefulWidget \{.*?Widget _pageContent.*?\}\n\}', text, re.DOTALL)
    if kr_match:
        new_kindle_reader = '''class KindleReader extends StatelessWidget {
  final Book book;
  const KindleReader({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.book,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: BackButton(color: AppState.instance.theme.primary),
        title: Text(book.name, style: GoogleFonts.poppins(color: C.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SfPdfViewer.asset('assets/books/${book.file}', canShowScrollHead: false, canShowScrollStatus: false),
    );
  }
}'''
        text = text.replace(kr_match.group(0), new_kindle_reader)

    with io.open('lib/main.dart', 'w', encoding='utf-8') as f:
        f.write(text)

    print("Success: mass update completed.")

if __name__ == '__main__':
    main()

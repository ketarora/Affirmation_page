import io

def main():
    with io.open('lib/main.dart', 'r', encoding='utf-8') as f:
        text = f.read()

    # 1. Fix PDF mappings
    text = text.replace("file: 'from bondage to freedom.pdf'", "file: 'From Bondage to Freedom.pdf'")
    text = text.replace("file: 'Let Go.pdf'", "file: 'Let Go!.pdf'")
    text = text.replace("file: 'Nothing to Lose but your head.pdf'", "file: 'Nothing to Lose But Your Head.pdf'")

    # 2. Add lightMode / textColor parameter to NishAffsLogo
    old_logo_def = '''class NishAffsLogo extends StatelessWidget {
  final double size; final bool showText;
  const NishAffsLogo({super.key, this.size = 28, this.showText = false});'''
    new_logo_def = '''class NishAffsLogo extends StatelessWidget {
  final double size; final bool showText; final Color? textColor;
  const NishAffsLogo({super.key, this.size = 28, this.showText = false, this.textColor});'''
    text = text.replace(old_logo_def, new_logo_def)

    old_logo_text = "Text('ishAffs', style: GoogleFonts.playfairDisplay(fontSize: size * 0.7, fontWeight: FontWeight.bold, color: C.textDark))"
    new_logo_text = "Text('ishAffs', style: GoogleFonts.playfairDisplay(fontSize: size * 0.7, fontWeight: FontWeight.bold, color: textColor ?? C.textDark))"
    text = text.replace(old_logo_text, new_logo_text)

    # 3. Use textColor in LoginScreen
    old_login_logo = "child: const NishAffsLogo(size: 64, showText: true).animate().fadeIn(duration: 600.ms)"
    new_login_logo = "child: const NishAffsLogo(size: 64, showText: true, textColor: Colors.white).animate().fadeIn(duration: 600.ms)"
    text = text.replace(old_login_logo, new_login_logo)

    with io.open('lib/main.dart', 'w', encoding='utf-8') as f:
        f.write(text)

    print('Fixed PDFs and Logo Text Visibility')

if __name__ == '__main__':
    main()

import io

def main():
    with io.open('lib/main.dart', 'r', encoding='utf-8') as f:
        text = f.read()

    # 1. Provide the 'textColor' named parameter in NishAffsLogo that the user added via UI builder
    old_logo_def = '''class NishAffsLogo extends StatelessWidget {
  final double size; final bool showText;
  const NishAffsLogo({super.key, this.size = 36, this.showText = false});'''
    new_logo_def = '''class NishAffsLogo extends StatelessWidget {
  final double size; final bool showText; final Color? textColor;
  const NishAffsLogo({super.key, this.size = 36, this.showText = false, this.textColor});'''
    
    text = text.replace(old_logo_def, new_logo_def)
    text = text.replace("Text('ishAffs', style: GoogleFonts.playfairDisplay(fontSize: size * 0.7, fontWeight: FontWeight.bold, color: C.textDark))",
                        "Text('ishAffs', style: GoogleFonts.playfairDisplay(fontSize: size * 0.7, fontWeight: FontWeight.bold, color: textColor ?? C.textDark))")

    # 2. Fix the static compilation evaluation error from line 186 (const BoxDecoration)
    text = text.replace('decoration: const BoxDecoration(gradient: LinearGradient', 'decoration: BoxDecoration(gradient: LinearGradient')

    with io.open('lib/main.dart', 'w', encoding='utf-8') as f:
        f.write(text)

    print('Patched successfully.')

if __name__ == '__main__':
    main()

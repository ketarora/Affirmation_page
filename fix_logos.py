import io
import sys

def main():
    with io.open('lib/main.dart', 'r', encoding='utf-8') as f:
        text = f.read()

    # Replace all occurrences of const NishAffsLogo... without showText
    text = text.replace('const NishAffsLogo(size: 44)', 'const NishAffsLogo(size: 44, showText: true)')
    text = text.replace('const NishAffsLogo(size: 32)', 'const NishAffsLogo(size: 32, showText: true)')
    text = text.replace('const NishAffsLogo(size: 30)', 'const NishAffsLogo(size: 30, showText: true)')
    
    text = text.replace('const NishAffsLogo(size: 16)', 'const NishAffsLogo(size: 26, showText: true)')
    text = text.replace('const NishAffsLogo(size: 22)', 'const NishAffsLogo(size: 36, showText: true)')

    # Fix popup
    old_popup = "const Text('\U0001F338', style: TextStyle(fontSize: 48)), const SizedBox(height: 16),"
    new_popup = "Stack(children: [const Positioned.fill(child: SparkleOverlay(child: SizedBox())), Center(child: const NishAffsLogo(size: 58, showText: true).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1500.ms).shimmer(duration: 2000.ms))]), const SizedBox(height: 16),"
    
    if old_popup in text:
        text = text.replace(old_popup, new_popup)
        with io.open('lib/main.dart', 'w', encoding='utf-8') as f:
            f.write(text)
        print("Success: wrote logo fixes to main.dart")
    else:
        print("Error: Old popup text not found in main.dart")

if __name__ == '__main__':
    main()

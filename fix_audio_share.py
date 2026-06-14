import io

def main():
    with io.open('lib/main.dart', 'r', encoding='utf-8') as f:
        text = f.read()

    # 1. Modify _PostPreviewSheet to use ScreenshotController
    old_preview_sheet = '''class _PostPreviewSheet extends StatelessWidget {
  final String text, vibe; final int bgIdx; final void Function(String) onPost;
  final XFile? imageFile;
  const _PostPreviewSheet({required this.text, required this.vibe, required this.bgIdx, required this.onPost, this.imageFile});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(context).viewInsets.bottom + 28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
      const SizedBox(height: 16),
      Row(children: [const NishAffsLogo(size: 28), const SizedBox(width: 10), Text('Ready to share! \U0001F338', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
      const SizedBox(height: 16),
      ClipRRect(borderRadius: BorderRadius.circular(18), child: SizedBox(height: 130, child: Stack(children: [
        Positioned.fill(child: imageFile != null 
          ? Image.network(imageFile!.path, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2)) 
          : _img(bgIdx + 2, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
        Center(child: Padding(padding: const EdgeInsets.all(18), child: Text('"$text"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 13, color: Colors.white, fontStyle: FontStyle.italic), maxLines: 4, overflow: TextOverflow.ellipsis))),
      ]))),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _btn(context, '\U0001F338 Community', C.pink1, C.pinkDark, 'community')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '\U0001F4BE Journal', AppState.instance.theme.secondaryLgt, AppState.instance.theme.secondary, 'save')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '\U0001F4E4 Share', C.goldLgt, const Color(0xFF9B7B14), 'external')),
      ]),
      const SizedBox(height: 10),
      _btn(context, '\U0001F4F1 Post as Story', C.bg, C.textDark, 'story', full: true),
    ]));
  Widget _btn(BuildContext ctx, String label, Color bg, Color fg, String target, {bool full = false}) =>
    GestureDetector(onTap: () => onPost(target), child: Container(
      width: full ? double.infinity : null, padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: fg.withOpacity(0.3), width: 1.2)),
      child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: fg), textAlign: TextAlign.center))));
}'''
    
    new_preview_sheet = '''class _PostPreviewSheet extends StatelessWidget {
  final String text, vibe; final int bgIdx; final void Function(String, ScreenshotController) onPost;
  final XFile? imageFile;
  final ScreenshotController _sc = ScreenshotController();
  
  _PostPreviewSheet({required this.text, required this.vibe, required this.bgIdx, required this.onPost, this.imageFile});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(context).viewInsets.bottom + 28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 44, height: 5, decoration: BoxDecoration(color: C.pink2, borderRadius: BorderRadius.circular(3))),
      const SizedBox(height: 16),
      Row(children: [const NishAffsLogo(size: 28), const SizedBox(width: 10), Text('Ready to share! \U0001F338', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: C.textDark))]),
      const SizedBox(height: 16),
      Screenshot(controller: _sc, child: ClipRRect(borderRadius: BorderRadius.circular(18), child: SizedBox(height: 130, child: Stack(children: [
        Positioned.fill(child: imageFile != null 
          ? Image.network(imageFile!.path, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: C.pink2)) 
          : _img(bgIdx + 2, w: double.infinity, h: double.infinity)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.38))),
        Center(child: Padding(padding: const EdgeInsets.all(18), child: Text('"$text"', textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 13, color: Colors.white, fontStyle: FontStyle.italic), maxLines: 4, overflow: TextOverflow.ellipsis))),
      ])))),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _btn(context, '\U0001F338 Community', C.pink1, C.pinkDark, 'community')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '\U0001F4BE Journal', AppState.instance.theme.secondaryLgt, AppState.instance.theme.secondary, 'save')),
        const SizedBox(width: 10),
        Expanded(child: _btn(context, '\U0001F4E4 Share', C.goldLgt, const Color(0xFF9B7B14), 'external')),
      ]),
      const SizedBox(height: 10),
      _btn(context, '\U0001F4F1 Post as Story', C.bg, C.textDark, 'story', full: true),
    ]));
  Widget _btn(BuildContext ctx, String label, Color bg, Color fg, String target, {bool full = false}) =>
    GestureDetector(onTap: () => onPost(target, _sc), child: Container(
      width: full ? double.infinity : null, padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: fg.withOpacity(0.3), width: 1.2)),
      child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: fg), textAlign: TextAlign.center))));
}'''

    text = text.replace(old_preview_sheet, new_preview_sheet)

    # 2. Modify _showPreview behavior
    old_show_preview = '''    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _isUploading ? const Center(child: CircularProgressIndicator(color: AppState.instance.theme.primary)) : _PostPreviewSheet(text: text, vibe: _vibe, bgIdx: _bgIdx, onPost: (target) async {
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
            content: Text(target == 'community' ? '\U0001F338 Posted!' : '\U0001F4BE Saved to journal!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); }
        }
      }));'''

    new_show_preview = '''    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _isUploading ? Center(child: CircularProgressIndicator(color: AppState.instance.theme.primary)) : _PostPreviewSheet(text: text, vibe: _vibe, bgIdx: _bgIdx, imageFile: _imageFile, onPost: (target, sc) async {
        if (target == 'external' || target == 'story') {
          final bytes = await sc.capture(delay: const Duration(milliseconds: 10));
          if (bytes != null) {
            final directory = await path_provider.getApplicationDocumentsDirectory();
            final tempPath = '${directory.path}/affirmation_share.png';
            final file = java_io.File(tempPath);
            await file.writeAsBytes(bytes);
            await Share.shareXFiles([XFile(tempPath)], text: target == 'story' ? '' : 'Check out this affirmation from NishAffs! \U0001F338');
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
            content: Text(target == 'community' ? '\U0001F338 Posted!' : '\U0001F4BE Saved to journal!'), backgroundColor: C.pinkDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); }
        }
      }));'''
    
    text = text.replace(old_show_preview, new_show_preview)
    
    # 3. Import path_provider and file correctly
    if "import 'dart:io' as java_io;" not in text:
        text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'dart:io' as java_io;\nimport 'package:path_provider/path_provider.dart' as path_provider;")

    # 4. Audio Play fix to use https URL
    old_audio = '''    try {
      // 1. Try Firebase Storage
      final url = await FirebaseStorage.instance
          .ref('audio/${_filenames[i % _filenames.length]}')
          .getDownloadURL();
      await _player.setUrl(url);
    } catch (e) {
      print('Firebase Audio Failed (falling back to mock timer): $e');
      // If Firebase isn't set up yet, fallback to local asset or mock
      _mockPlay(i);
      return;
    }'''
    new_audio = '''    try {
      final url = 'https://actions.google.com/sounds/v1/water/rain_on_roof.ogg';
      await _player.setUrl(url);
    } catch (e) {
      print('Audio Failed: $e');
      _mockPlay(i);
      return;
    }'''
    text = text.replace(old_audio, new_audio)

    with io.open('lib/main.dart', 'w', encoding='utf-8') as f:
        f.write(text)

    # 5. Fix share package import (it's already added at top earlier? Actually `fix_all.py` didn't add screenshot package import.)
    text = text.replace("import 'package:share_plus/share_plus.dart';", "import 'package:share_plus/share_plus.dart';\nimport 'package:screenshot/screenshot.dart';")
    # if share_plus doesn't exist:
    if "import 'package:share_plus/share_plus.dart';" not in text:
        text = text.replace("import 'dart:io' as java_io;", "import 'dart:io' as java_io;\nimport 'package:share_plus/share_plus.dart';\nimport 'package:screenshot/screenshot.dart';")

    with io.open('lib/main.dart', 'w', encoding='utf-8') as f:
        f.write(text)

    print("Success: audio and share fixes generated.")

if __name__ == '__main__':
    main()

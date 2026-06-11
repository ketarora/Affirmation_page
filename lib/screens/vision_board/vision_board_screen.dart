import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/vision_board_service.dart';

class VisionBoardScreen extends StatelessWidget {
  const VisionBoardScreen({super.key});

  static const _prompts = [
    'My dream home is...', 'I feel deeply...', 'My body is...', 'My career is...',
    'Love looks like...', 'My bank account says...', 'I am grateful for...',
    'I wake up to...', 'My relationships are...', 'I travel to...'
  ];

  @override
  Widget build(BuildContext context) {
    final vbs = VisionBoardService.instance;
    final tc = TextEditingController();

    void showAddSheet() => showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.pink.shade100, borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.spa, color: Colors.pink), const SizedBox(width: 8),
            Text('Add Vision Card', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold))
          ]),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () async { Navigator.pop(ctx); await vbs.addImageFromGallery(); },
            child: Container(width: double.infinity, height: 50,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(100)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.photo_library_rounded, color: Colors.white, size: 20), const SizedBox(width: 8),
                Text('📸 Add from Gallery', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))
              ]))),
          const SizedBox(height: 10),
          Text('— or write a dream —', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 10),
          SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _prompts.length,
            itemBuilder: (_, i) => GestureDetector(onTap: () => tc.text = _prompts[i],
              child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(100), border: Border.all(color: Colors.pink.shade200)),
                child: Text(_prompts[i], style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.pink.shade700)))))),
          const SizedBox(height: 12),
          TextField(controller: tc, maxLines: 3, style: GoogleFonts.lora(fontSize: 15, height: 1.6),
            decoration: InputDecoration(hintText: 'My dream life includes...', hintStyle: GoogleFonts.lora(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
              filled: true, fillColor: Colors.pink.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16))),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              if (tc.text.trim().isEmpty) return;
              await vbs.addTextCard(tc.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Container(width: double.infinity, height: 50,
              decoration: BoxDecoration(color: Colors.pink.shade100, borderRadius: BorderRadius.circular(100)),
              child: Center(child: Text('Add Text Card ✨', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.pink.shade700))))),
        ])));

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
        leading: const BackButton(color: Colors.pink),
        title: Text('Vision Board', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.add_rounded, color: Colors.pink, size: 28), onPressed: showAddSheet)]),
      body: ValueListenableBuilder<List<VisionBoardItem>>(
        valueListenable: vbs.visionItems,
        builder: (_, items, __) => items.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🌟', style: TextStyle(fontSize: 56)), const SizedBox(height: 14),
              Text('Your vision board is empty!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              Text('Tap + to add photos or dreams ✨', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey))
            ]))
          : GridView.builder(
              padding: const EdgeInsets.all(16), itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
              itemBuilder: (ctx, i) {
                final item = items[i];
                return GestureDetector(
                  onLongPress: () => vbs.deleteItem(item.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: item.type == 'image'
                        ? Image.file(File(item.content), fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)))
                        : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFFFFE4EE), Color(0xFFE8DDFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            ),
                            child: Center(child: Text(item.content, textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w600))),
                          ),
                  ),
                );
              })));
  }
}

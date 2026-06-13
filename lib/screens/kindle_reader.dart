// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/screens/kindle_reader.dart                              ║
// ║  Network PDF reader — loading, error, page persistence       ║
// ╚══════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart'; // To use Book model
// ── Reader screen ─────────────────────────────────────────────────
class KindleReader extends StatefulWidget {
  final Book book;
  const KindleReader({super.key, required this.book});

  @override
  State<KindleReader> createState() => _KindleReaderState();
}

class _KindleReaderState extends State<KindleReader> {
  final _controller   = SfPdfViewerController();
  final _pageNotifier = ValueNotifier<int>(1);
  int   _totalPages   = 0;
  bool  _isLoading    = true;
  bool  _hasError     = false;
  String? _errorMsg;

  // ── Persist page per book ──────────────────────────────────────
  String get _prefKey => 'pdf_page_${widget.book.name.replaceAll(' ', '_')}';

  Future<void> _loadSavedPage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefKey) ?? 1;
    if (saved > 1) {
      // Small delay to let PDF render first
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) _controller.jumpToPage(saved);
    }
  }

  Future<void> _savePage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, page);
  }

  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Theme colors — replace C.* with your actual color tokens
    const bg      = Color(0xFFFFF9F5);
    const primary = Color(0xFFFF82A9);
    const textDark = Color(0xFF2D1B4E);
    const textSub  = Color(0xFF9B8EAA);
    const gold     = Color(0xFFE6B861);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation      : 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon    : const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize      : MainAxisSize.min,
          children          : [
            Text(
              widget.book.name,
              style: GoogleFonts.poppins(
                  color: textDark, fontWeight: FontWeight.w700, fontSize: 13.5),
              maxLines : 1,
              overflow : TextOverflow.ellipsis,
            ),
            Text(
              'by ${widget.book.author}',
              style: GoogleFonts.poppins(color: textSub, fontSize: 11),
            ),
          ],
        ),
        actions: [
          // Page indicator
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child  : ValueListenableBuilder<int>(
                valueListenable: _pageNotifier,
                builder        : (_, page, __) => Container(
                  padding   : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color       : primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$page / $_totalPages',
                    style: GoogleFonts.poppins(
                        color: primary, fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(children: [

        // ── PDF Viewer ─────────────────────────────────────────────
        if (!_hasError)
          SfPdfViewer.asset(
            'assets/books/${widget.book.file}',
            controller        : _controller,
            canShowScrollHead : false,
            canShowScrollStatus: false,
            canShowPaginationDialog: false,
            // Horizontal swipe = book-feel
            pageLayoutMode    : PdfPageLayoutMode.single,
            scrollDirection   : PdfScrollDirection.horizontal,
            onDocumentLoaded  : (details) {
              setState(() {
                _isLoading  = false;
                _totalPages = details.document.pages.count;
              });
              _loadSavedPage();
            },
            onDocumentLoadFailed: (details) {
              setState(() {
                _hasError = true;
                _isLoading = false;
                _errorMsg  = details.description;
              });
            },
            onPageChanged: (details) {
              _pageNotifier.value = details.newPageNumber;
              _savePage(details.newPageNumber);
            },
          ),

        // ── Loading state ──────────────────────────────────────────
        if (_isLoading && !_hasError)
          Container(
            color: bg,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children    : [
                  Text(widget.book.emoji,
                      style: const TextStyle(fontSize: 52)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child       : LinearProgressIndicator(
                        backgroundColor: primary.withOpacity(0.12),
                        valueColor     : const AlwaysStoppedAnimation(primary),
                        minHeight      : 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Opening book...',
                    style: GoogleFonts.poppins(fontSize: 13, color: textSub),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.book.name,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: textSub.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ),

        // ── Error state ────────────────────────────────────────────
        if (_hasError)
          Container(
            color  : bg,
            padding: const EdgeInsets.all(32),
            child  : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children    : [
                  Text(widget.book.emoji,
                      style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    widget.book.name,
                    textAlign: TextAlign.center,
                    style    : GoogleFonts.playfairDisplay(
                        fontSize  : 18,
                        fontWeight: FontWeight.bold,
                        color     : textDark),
                  ),
                  const SizedBox(height: 4),
                  Text('by ${widget.book.author}',
                      style: GoogleFonts.poppins(fontSize: 13, color: textSub)),
                  const SizedBox(height: 24),

                  // Error info box
                  Container(
                    padding   : const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color       : gold.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border      : Border.all(color: gold.withOpacity(0.35)),
                    ),
                    child: Column(children: [
                      const Icon(Icons.cloud_off_outlined, color: gold, size: 24),
                      const SizedBox(height: 10),
                      Text(
                        'Could not load this book.\nThe PDF may be unavailable or\nyour connection may be offline.',
                        textAlign: TextAlign.center,
                        style    : GoogleFonts.poppins(
                            fontSize: 12.5, color: textDark, height: 1.6),
                      ),
                      if (_errorMsg != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMsg!,
                          textAlign: TextAlign.center,
                          style    : GoogleFonts.poppins(
                              fontSize: 10.5, color: textSub),
                        ),
                      ],
                    ]),
                  ),

                  const SizedBox(height: 20),

                  // Retry button
                  GestureDetector(
                    onTap: () => setState(() {
                      _hasError  = false;
                      _isLoading = true;
                    }),
                    child: Container(
                      padding   : const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      decoration: BoxDecoration(
                        gradient    : const LinearGradient(
                          colors: [Color(0xFFFF82A9), Color(0xFFAC7BED)]),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow   : [
                          BoxShadow(
                            color     : primary.withOpacity(0.30),
                            blurRadius: 14, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Text(
                        'Try Again',
                        style: GoogleFonts.poppins(
                            fontSize  : 14,
                            fontWeight: FontWeight.w700,
                            color     : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ]),
    );
  }
}

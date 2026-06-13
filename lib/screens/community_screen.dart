// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/screens/community_screen.dart                           ║
// ║  Firestore-backed feed — like, comment, report, delete       ║
// ╚══════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';
import '../services/community_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _postCtrl = TextEditingController();
  bool _isPosting = false;

  final _auth = FirebaseAuth.instance;

  // ── Theme constants ──────────────────────────────────────────────
  static const _bg      = Color(0xFFFFF9F5);
  static const _primary = Color(0xFFFF82A9);
  static const _purple  = Color(0xFFAC7BED);
  static const _textDk  = Color(0xFF2D1B4E);
  static const _textSub = Color(0xFF9B8EAA);

  @override
  void dispose() {
    _postCtrl.dispose();
    super.dispose();
  }

  // ── Post action ──────────────────────────────────────────────────
  Future<void> _submitPost() async {
    final text = _postCtrl.text.trim();
    if (text.isEmpty) return;

    if (_auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to post.')),
      );
      return;
    }

    setState(() => _isPosting = true);
    FocusScope.of(context).unfocus();

    try {
      await CommunityService.createPost(
        text       : text,
        authorName : _auth.currentUser!.displayName ?? 'Anonymous Soul',
        authorEmail: _auth.currentUser!.email ?? '',
      );
      _postCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Affirmation shared! 🌸')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  // ── Format helpers ───────────────────────────────────────────────
  String _getInitials(String name) {
    if (name.isEmpty) return 'A';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  int min(int a, int b) => a < b ? a : b;

  // ── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor : _bg,
        elevation       : 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize      : MainAxisSize.min,
          children          : [
            Text('Soul Tribe',
              style: GoogleFonts.playfairDisplay(
                color     : _textDk,
                fontWeight: FontWeight.bold,
                fontSize  : 22,
              )),
            Text('Connect, uplift, and share the light.',
              style: GoogleFonts.poppins(color: _textSub, fontSize: 11)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Compose Area ─────────────────────────────────────────
          Container(
            padding   : const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: _textDk.withOpacity(0.04),
                  blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius         : 20,
                  backgroundColor: _primary.withOpacity(0.15),
                  child          : Text(
                    _getInitials(_auth.currentUser?.displayName ?? 'A'),
                    style: GoogleFonts.poppins(
                      color: _primary, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),

                // Text field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller : _postCtrl,
                        maxLines   : 3,
                        minLines   : 1,
                        style      : GoogleFonts.poppins(fontSize: 13.5, color: _textDk),
                        decoration : InputDecoration(
                          hintText  : "Share what's on your mind today...",
                          hintStyle : GoogleFonts.poppins(color: _textSub, fontSize: 13.5),
                          border    : InputBorder.none,
                          isDense   : true,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Post button
                      _isPosting
                          ? const SizedBox(
                              width : 20,
                              height: 20,
                              child : CircularProgressIndicator(
                                  strokeWidth: 2, color: _primary))
                          : ElevatedButton(
                              onPressed: _submitPost,
                              style    : ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                elevation      : 0,
                                shape          : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                padding        : const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                minimumSize    : const Size(0, 36),
                              ),
                              child: Text('Post',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600, fontSize: 13)),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Feed Stream ──────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<CommunityPost>>(
              stream: CommunityService.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load feed.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: _textSub)),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primary),
                  );
                }

                final posts = snapshot.data!;

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children    : [
                        const Text('🌸', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text('No posts yet.',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, color: _textDk)),
                        const SizedBox(height: 4),
                        Text('Be the first to share some light!',
                            style: GoogleFonts.poppins(color: _textSub, fontSize: 13)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding    : const EdgeInsets.all(16),
                  itemCount  : posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder     : (_, index) => _PostCard(post: posts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Separated Post Card Widget ────────────────────────────────────
class _PostCard extends StatelessWidget {
  final CommunityPost post;
  const _PostCard({required this.post});

  static const _primary = Color(0xFFFF82A9);
  static const _textDk  = Color(0xFF2D1B4E);
  static const _textSub = Color(0xFF9B8EAA);

  String _getInitials(String name) {
    if (name.isEmpty) return 'A';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase(); // simplified min(2, len)
  }

  void _handleLike(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to like posts.')),
      );
      return;
    }
    CommunityService.toggleLike(post.id, user.uid);
  }

  void _showOptions(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isMe = user?.uid == post.authorId;

    showModalBottomSheet(
      context: context,
      shape  : const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children    : [
            if (isMe || user?.email == 'admin@nishaffs.com')
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title  : const Text('Delete Post', style: TextStyle(color: Colors.red)),
                onTap  : () {
                  Navigator.pop(ctx);
                  CommunityService.deletePost(post.id);
                },
              ),
            ListTile(
              leading: const Icon(Icons.flag_outline, color: _textSub),
              title  : const Text('Report Post', style: TextStyle(color: _textSub)),
              onTap  : () {
                Navigator.pop(ctx);
                CommunityService.reportPost(post.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post reported for review. Thank you.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meUId = FirebaseAuth.instance.currentUser?.uid;
    final isLiked = meUId != null && post.likes.contains(meUId);

    return Container(
      padding   : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow   : [
          BoxShadow(
              color: _textDk.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (Author + Time + Menu) ──────────────────────
          Row(
            children: [
              CircleAvatar(
                radius         : 18,
                backgroundColor: _primary.withOpacity(0.1),
                child          : Text(
                  _getInitials(post.authorName),
                  style: GoogleFonts.poppins(
                      color: _primary, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: GoogleFonts.poppins(
                          color: _textDk, fontWeight: FontWeight.w600, fontSize: 13.5),
                    ),
                    Text(
                      timeago.format(post.createdAt),
                      style: GoogleFonts.poppins(color: _textSub, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon     : const Icon(Icons.more_horiz, color: _textSub, size: 20),
                onPressed: () => _showOptions(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Content ────────────────────────────────────────────
          Text(
            post.text,
            style: GoogleFonts.poppins(
                color: _textDk, fontSize: 14, height: 1.5, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 16),

          // ── Footer (Likes + Comments) ──────────────────────────
          Divider(color: _textSub.withOpacity(0.1), height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              // Like
              InkWell(
                onTap: () => _handleLike(context),
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(children: [
                    Icon(
                      isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isLiked ? _primary : _textSub.withOpacity(0.5),
                      size : 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.likes.length.toString(),
                      style: GoogleFonts.poppins(
                        color     : isLiked ? _primary : _textSub,
                        fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                        fontSize  : 12,
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 16),

              // Comment (Mocked UI for now)
              InkWell(
                onTap: () {
                  // TODO: Navigate to specific thread screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comments coming soon!')),
                  );
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(children: [
                    Icon(Icons.chat_bubble_outline_rounded,
                        color: _textSub.withOpacity(0.5), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      post.commentCount.toString(),
                      style: GoogleFonts.poppins(color: _textSub, fontSize: 12),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

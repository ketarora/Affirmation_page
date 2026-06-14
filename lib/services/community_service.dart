// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/community_service.dart  (FIXED v2)             ║
// ╚══════════════════════════════════════════════════════════════╝

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

// ── Models ──────────────────────────────────────────────────────

class CommunityPost {
  final String id;
  final String userId;       // ← use userId throughout (was causing authorId bug)
  final String userName;     // ← use userName throughout (was causing authorName bug)
  final String? userPhotoUrl;
  final String text;
  final String? imageUrl;
  final List<String> likes;
  final int commentCount;
  final DateTime createdAt;
  final bool isDeleted;

  const CommunityPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.text,
    this.imageUrl,
    required this.likes,
    required this.commentCount,
    required this.createdAt,
    this.isDeleted = false,
  });

  bool get isLikedByMe =>
      likes.contains(FirebaseAuth.instance.currentUser?.uid);
  int get likeCount => likes.length;

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CommunityPost(
      id           : doc.id,
      userId       : d['userId']       ?? '',
      userName     : d['userName']     ?? 'Soul',
      userPhotoUrl : d['userPhotoUrl'],
      text         : d['text']         ?? '',
      imageUrl     : d['imageUrl'],
      likes        : List<String>.from(d['likes'] ?? []),
      commentCount : (d['commentCount'] ?? 0) as int,
      createdAt    : (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDeleted    : d['isDeleted'] ?? false,
    );
  }
}

class CommunityComment {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String text;
  final DateTime createdAt;

  const CommunityComment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.text,
    required this.createdAt,
  });

  factory CommunityComment.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CommunityComment(
      id          : doc.id,
      userId      : d['userId']    ?? '',
      userName    : d['userName']  ?? 'Soul',
      userPhotoUrl: d['userPhotoUrl'],
      text        : d['text']      ?? '',
      createdAt   : (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

// ── Service ─────────────────────────────────────────────────────

class CommunityService {
  static final _db      = FirebaseFirestore.instance;
  static final _auth    = FirebaseAuth.instance;
  static final _storage = FirebaseStorage.instance;

  static User? get _user => _auth.currentUser;

  // ── ✅ ALIAS — community_screen.dart calls getPosts(), not postsStream() ──
  static Stream<List<CommunityPost>> getPosts({String? category}) {
    return postsStream(category: category);
  }

  // ── Real-time posts stream ─────────────────────────────────────
  static Stream<List<CommunityPost>> postsStream({String? category}) {
    var query = _db
        .collection('community_posts')
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(50);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snap) =>
        snap.docs.map((d) => CommunityPost.fromFirestore(d)).toList());
  }

  // ── Create post ────────────────────────────────────────────────
  // ✅ FIXED: removed authorName/authorEmail params — user is taken from _auth
  static Future<void> createPost({
    required String text,
    Uint8List?      imageBytes,
    String?         imageName,
    String          category = 'General',
  }) async {
    if (_user == null) throw Exception('Not logged in');
    if (text.trim().isEmpty) throw Exception('Post cannot be empty');

    String? imageUrl;
    if (imageBytes != null && imageName != null) {
      final ext  = imageName.split('.').last;
      final path = 'community_images/${_user!.uid}/${DateTime.now().millisecondsSinceEpoch}.$ext';
      final ref  = _storage.ref(path);
      await ref.putData(imageBytes,
          SettableMetadata(contentType: 'image/$ext'));
      imageUrl = await ref.getDownloadURL();
    }

    await _db.collection('community_posts').add({
      'userId'      : _user!.uid,
      'userName'    : _user!.displayName ?? 'Soul',
      'userPhotoUrl': _user!.photoURL,
      'text'        : text.trim(),
      'imageUrl'    : imageUrl,
      'category'    : category,
      'likes'       : <String>[],
      'commentCount': 0,
      'isDeleted'   : false,
      'isPinned'    : false,
      'reportCount' : 0,
      'createdAt'   : FieldValue.serverTimestamp(),
    });
  }

  // ── ✅ FIXED toggleLike — was called with 2 args, only needs postId ──
  static Future<void> toggleLike(String postId) async {
    if (_user == null) throw Exception('Not logged in');
    final uid = _user!.uid;
    final ref = _db.collection('community_posts').doc(postId);

    await _db.runTransaction((tx) async {
      final snap  = await tx.get(ref);
      if (!snap.exists) return;
      final likes = List<String>.from(snap['likes'] ?? []);
      likes.contains(uid) ? likes.remove(uid) : likes.add(uid);
      tx.update(ref, {'likes': likes});
    });
  }

  // ── Comments stream ────────────────────────────────────────────
  static Stream<List<CommunityComment>> commentsStream(String postId) {
    return _db
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => CommunityComment.fromFirestore(d)).toList());
  }

  // ── Add comment ────────────────────────────────────────────────
  static Future<void> addComment(String postId, String text) async {
    if (_user == null) throw Exception('Not logged in');
    if (text.trim().isEmpty) return;

    final batch = _db.batch();
    final commentRef = _db
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .doc();
    batch.set(commentRef, {
      'userId'      : _user!.uid,
      'userName'    : _user!.displayName ?? 'Soul',
      'userPhotoUrl': _user!.photoURL,
      'text'        : text.trim(),
      'createdAt'   : FieldValue.serverTimestamp(),
    });

    final postRef = _db.collection('community_posts').doc(postId);
    batch.update(postRef, {'commentCount': FieldValue.increment(1)});
    await batch.commit();
  }

  // ── Delete post (soft) ─────────────────────────────────────────
  static Future<void> deletePost(String postId) async {
    if (_user == null) throw Exception('Not logged in');
    final doc = await _db.collection('community_posts').doc(postId).get();
    if (doc['userId'] != _user!.uid) {
      throw Exception('Cannot delete another user\'s post');
    }
    await _db.collection('community_posts').doc(postId).update({
      'isDeleted': true,
      'text'     : '[This post has been removed]',
      'imageUrl' : null,
    });
  }

  // ── ✅ FIXED reportPost — reason is now optional with default ──
  static Future<void> reportPost(String postId,
      [String reason = 'Inappropriate content']) async {
    if (_user == null) throw Exception('Not logged in');
    await _db
        .collection('community_posts')
        .doc(postId)
        .collection('reports')
        .doc(_user!.uid)
        .set({
      'userId'    : _user!.uid,
      'reason'    : reason,
      'reportedAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('community_posts').doc(postId).update({
      'reportCount': FieldValue.increment(1),
    });
  }
}    

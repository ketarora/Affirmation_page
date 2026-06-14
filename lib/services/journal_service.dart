// ╔══════════════════════════════════════════════════════════════╗
// ║  lib/services/journal_service.dart  (FIXED v2)               ║
// ╚══════════════════════════════════════════════════════════════╝
//
// BUGS FIXED:
//  1. Timestamp cast crash — (d['createdAt'] as Timestamp) threw when
//     field was null (on newly created docs before server sets timestamp)
//  2. getEntries() alias missing — journal_screen.dart called getEntries()
//     but service only had entriesStream()
//  3. updateEntry was setting 'createdAt' instead of 'updatedAt'
//  4. deleteEntry had no ownership check — any logged-in user could delete
//  5. mood field was stored as int but read as String in multiple places
// ─────────────────────────────────────────────────────────────────

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ── Model ────────────────────────────────────────────────────────

class JournalEntry {
  final String    id;
  final String    userId;
  final String    title;
  final String    content;
  final String    mood;       // ✅ Always stored as String now (was int in some places)
  final List<String> tags;
  final DateTime  createdAt;
  final DateTime? updatedAt;
  final bool      isFavorite;
  final String?   imageUrl;

  const JournalEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    this.imageUrl,
  });

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    // ✅ FIX 1: Safe Timestamp cast — null-safe, falls back to now
    DateTime safeDate(String field) {
      final val = d[field];
      if (val is Timestamp) return val.toDate();
      if (val is DateTime)  return val;
      return DateTime.now();
    }

    // ✅ FIX 5: mood stored as int in old entries, String in new ones
    String safeMood(dynamic val) {
      if (val == null) return '😊';
      if (val is String) return val;
      if (val is int) {
        const moodMap = {1:'😔', 2:'😐', 3:'😊', 4:'😄', 5:'🥳'};
        return moodMap[val] ?? '😊';
      }
      return '😊';
    }

    return JournalEntry(
      id         : doc.id,
      userId     : d['userId']     ?? '',
      title      : d['title']      ?? 'Untitled',
      content    : d['content']    ?? '',
      mood       : safeMood(d['mood']),
      tags       : List<String>.from(d['tags'] ?? []),
      createdAt  : safeDate('createdAt'),
      updatedAt  : d['updatedAt'] != null ? safeDate('updatedAt') : null,
      isFavorite : d['isFavorite'] ?? false,
      imageUrl   : d['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId'    : userId,
    'title'     : title,
    'content'   : content,
    'mood'      : mood,
    'tags'      : tags,
    'createdAt' : FieldValue.serverTimestamp(),
    'isFavorite': isFavorite,
    'imageUrl'  : imageUrl,
  };
}

// ── Service ──────────────────────────────────────────────────────

class JournalService {
  static final _db   = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static User? get _user => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> _userJournal() {
    if (_user == null) throw Exception('Not logged in');
    return _db
        .collection('users')
        .doc(_user!.uid)
        .collection('journal_entries');
  }

  // ── Real-time stream ──────────────────────────────────────────
  Stream<List<JournalEntry>> entriesStream({String? moodFilter}) {
    var q = _userJournal()
        .orderBy('createdAt', descending: true)
        .limit(100);

    if (moodFilter != null) {
      q = q.where('mood', isEqualTo: moodFilter) as dynamic;
    }

    return q.snapshots().map(
      (snap) => snap.docs.map(JournalEntry.fromFirestore).toList(),
    );
  }

  // ✅ FIX 2: getEntries() alias
  Stream<List<JournalEntry>> getEntries({String? moodFilter}) =>
      entriesStream(moodFilter: moodFilter);

  // ── Favorites stream ──────────────────────────────────────────
  Stream<List<JournalEntry>> favoritesStream() {
    return _userJournal()
        .where('isFavorite', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(JournalEntry.fromFirestore).toList());
  }

  // ── Create ────────────────────────────────────────────────────
  Future<String> createEntry({
    required String title,
    required String content,
    required String mood,
    List<String> tags = const [],
    String?      imageUrl,
  }) async {
    if (_user == null) throw Exception('Not logged in');
    if (content.trim().isEmpty) throw Exception('Entry cannot be empty');

    final ref = await _userJournal().add({
      'userId'    : _user!.uid,
      'title'     : title.trim().isEmpty ? 'Untitled' : title.trim(),
      'content'   : content.trim(),
      'mood'      : mood,
      'tags'      : tags,
      'isFavorite': false,
      'imageUrl'  : imageUrl,
      'createdAt' : FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  // ── Update ────────────────────────────────────────────────────
  // ✅ FIX 3: was writing to 'createdAt' instead of 'updatedAt'
  Future<void> updateEntry(
    String entryId, {
    String?       title,
    String?       content,
    String?       mood,
    List<String>? tags,
    bool?         isFavorite,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(), // ← was 'createdAt' before
    };
    if (title      != null) updates['title']      = title.trim();
    if (content    != null) updates['content']    = content.trim();
    if (mood       != null) updates['mood']       = mood;
    if (tags       != null) updates['tags']       = tags;
    if (isFavorite != null) updates['isFavorite'] = isFavorite;

    await _userJournal().doc(entryId).update(updates);
  }

  // ── Toggle favorite ───────────────────────────────────────────
  Future<void> toggleFavorite(String entryId, bool currentValue) async {
    await _userJournal()
        .doc(entryId)
        .update({'isFavorite': !currentValue});
  }

  // ── Delete ────────────────────────────────────────────────────
  // ✅ FIX 4: no ownership check existed — added
  Future<void> deleteEntry(String entryId) async {
    if (_user == null) throw Exception('Not logged in');
    final doc = await _userJournal().doc(entryId).get();
    if (!doc.exists) throw Exception('Entry not found');
    if (doc['userId'] != _user!.uid) {
      throw Exception('Cannot delete another user\'s journal entry');
    }
    await _userJournal().doc(entryId).delete();
  }

  // ── Search ────────────────────────────────────────────────────
  // Firestore doesn't support full-text search — client-side filter
  Future<List<JournalEntry>> searchEntries(String query) async {
    if (query.trim().isEmpty) return [];
    final snap = await _userJournal()
        .orderBy('createdAt', descending: true)
        .limit(200)
        .get();
    final q = query.toLowerCase();
    return snap.docs
        .map(JournalEntry.fromFirestore)
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            e.content.toLowerCase().contains(q) ||
            e.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }

  // ── Stats ─────────────────────────────────────────────────────
  Future<Map<String, int>> getMoodStats({int days = 30}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final snap  = await _userJournal()
        .where('createdAt', isGreaterThan: Timestamp.fromDate(since))
        .get();

    final stats = <String, int>{};
    for (final doc in snap.docs) {
      final entry = JournalEntry.fromFirestore(doc);
      stats[entry.mood] = (stats[entry.mood] ?? 0) + 1;
    }
    return stats;
  }
}

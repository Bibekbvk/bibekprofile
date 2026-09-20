import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/content/data/mock_content_repository.dart';
import '../../features/content/domain/models/journal_post.dart';
import '../../features/content/domain/models/study_note.dart';
import '../constants/app_constants.dart';

/// Supabase backend service layer handling data synchronization and contact inquiries.
/// Includes graceful fallback to mock repositories when unconfigured or offline.
class SupabaseService {
  static SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Indicates if Supabase credentials have been configured and initialized.
  static bool get isConfigured {
    if (_client == null) return false;
    final url = AppConstants.supabaseUrl;
    return !url.contains('your-supabase-project') && url.startsWith('http');
  }

  /// Initialize Supabase with project credentials if provided.
  static Future<void> initialize() async {
    if (!AppConstants.supabaseUrl.contains('your-supabase-project')) {
      try {
        await Supabase.initialize(
          url: AppConstants.supabaseUrl,
          // ignore: deprecated_member_use
          anonKey: AppConstants.supabaseAnonKey,
        );
        debugPrint('Supabase successfully initialized.');
      } catch (e) {
        debugPrint('Supabase initialization failed or skipped: $e');
      }
    }
  }

  /// Fetches published journal posts with optional category filtering.
  static Future<List<JournalPost>> fetchPosts({String? category}) async {
    final effectiveCategory = category ?? 'All';

    if (!isConfigured) {
      debugPrint('Supabase not configured: Serving posts from mock repository.');
      return MockContentRepository.getPostsByCategory(effectiveCategory);
    }

    try {
      var filterQuery = _client!
          .from('posts')
          .select()
          .eq('is_published', true);

      if (effectiveCategory != 'All') {
        filterQuery = filterQuery.eq('category', effectiveCategory);
      }

      final response =
          await filterQuery.order('created_at', ascending: false);
      final data = response as List<dynamic>;

      if (data.isEmpty) {
        return MockContentRepository.getPostsByCategory(effectiveCategory);
      }

      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return JournalPost(
          id: map['id']?.toString() ?? '',
          title: map['title'] ?? '',
          slug: map['slug'] ?? '',
          category: map['category'] ?? 'Tech',
          date: map['created_at'] != null
              ? map['created_at'].toString().substring(0, 10)
              : 'Recent',
          readTime: map['read_time'] ?? '7 min read',
          excerpt: map['excerpt'] ?? '',
          contentMarkdown: map['content'] ?? '',
          tags: (map['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          isFeatured: map['is_featured'] ?? false,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching posts from Supabase: $e. Falling back to local data.');
      return MockContentRepository.getPostsByCategory(effectiveCategory);
    }
  }

  /// Fetches technical study notes with optional category filtering.
  static Future<List<StudyNote>> fetchStudyNotes({String? category}) async {
    final effectiveCategory = category ?? 'All';

    if (!isConfigured) {
      return MockContentRepository.getStudyNotesByCategory(effectiveCategory);
    }

    try {
      var filterQuery = _client!
          .from('study_notes')
          .select();

      if (effectiveCategory != 'All') {
        filterQuery = filterQuery.eq('category', effectiveCategory);
      }

      final response =
          await filterQuery.order('created_at', ascending: false);
      final data = response as List<dynamic>;

      if (data.isEmpty) {
        return MockContentRepository.getStudyNotesByCategory(effectiveCategory);
      }

      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return StudyNote(
          id: map['id']?.toString() ?? '',
          topic: map['title'] ?? '',
          description: map['description'] ?? '',
          fileUrl: map['file_url'] ?? '',
          category: map['category'] ?? 'Tech',
          date: map['created_at'] != null
              ? map['created_at'].toString().substring(0, 10)
              : 'Recent',
          format: map['format'] ?? 'Reference Guide',
          keyTakeaways: (map['key_takeaways'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching study notes from Supabase: $e');
      return MockContentRepository.getStudyNotesByCategory(effectiveCategory);
    }
  }

  /// Submits a visitor inquiry into the contact_messages table.
  /// Falls back to local simulation when Supabase credentials are not yet configured.
  static Future<bool> submitContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    final payload = {
      'name': name.trim(),
      'email': email.trim(),
      'message': message.trim(),
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };

    if (!isConfigured) {
      // Simulate network round-trip for testing & demonstration
      debugPrint('Supabase not configured: Simulating message submission payload: $payload');
      await Future.delayed(const Duration(milliseconds: 700));
      return true;
    }

    try {
      await _client!.from('contact_messages').insert(payload);
      debugPrint('Successfully submitted contact message to Supabase.');
      return true;
    } catch (e) {
      debugPrint('Error submitting contact message to Supabase: $e');
      return false;
    }
  }
}

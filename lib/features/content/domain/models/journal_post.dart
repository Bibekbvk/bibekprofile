/// Domain model representing a Health IT & Statistics news-style journal article.
class JournalPost {
  final String id;
  final String title;
  final String slug;
  final String category; // Biostatistics, Clinical Informatics, Health Systems, Epidemiological AI
  final String date;
  final String readTime;
  final String excerpt;
  final String contentMarkdown;
  final List<String> tags;
  final bool isFeatured;
  final String? newsImageUrl;
  final String? statisticsHeadline;
  final String? sampleMetric;

  const JournalPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    required this.date,
    required this.readTime,
    required this.excerpt,
    required this.contentMarkdown,
    this.tags = const [],
    this.isFeatured = false,
    this.newsImageUrl,
    this.statisticsHeadline,
    this.sampleMetric,
  });

  JournalPost copyWith({
    String? id,
    String? title,
    String? slug,
    String? category,
    String? date,
    String? readTime,
    String? excerpt,
    String? contentMarkdown,
    List<String>? tags,
    bool? isFeatured,
    String? newsImageUrl,
    String? statisticsHeadline,
    String? sampleMetric,
  }) {
    return JournalPost(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      date: date ?? this.date,
      readTime: readTime ?? this.readTime,
      excerpt: excerpt ?? this.excerpt,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      newsImageUrl: newsImageUrl ?? this.newsImageUrl,
      statisticsHeadline: statisticsHeadline ?? this.statisticsHeadline,
      sampleMetric: sampleMetric ?? this.sampleMetric,
    );
  }
}

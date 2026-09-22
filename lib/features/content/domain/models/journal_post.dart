/// Domain model representing a Health IT & Statistics news-style journal article.
class JournalPost {
  final String id;
  final String title;
  final String? titleNepali;
  final String slug;
  final String category; // AI & Technology, Biostatistics, Clinical Informatics, etc.
  final String date;
  final String readTime;
  final String excerpt;
  final String? excerptNepali;
  final String contentMarkdown;
  final String? contentMarkdownNepali;
  final List<String> tags;
  final bool isFeatured;
  final String? newsImageUrl;
  final String? statisticsHeadline;
  final String? sampleMetric;

  const JournalPost({
    required this.id,
    required this.title,
    this.titleNepali,
    required this.slug,
    required this.category,
    required this.date,
    required this.readTime,
    required this.excerpt,
    this.excerptNepali,
    required this.contentMarkdown,
    this.contentMarkdownNepali,
    this.tags = const [],
    this.isFeatured = false,
    this.newsImageUrl,
    this.statisticsHeadline,
    this.sampleMetric,
  });

  String displayTitle(bool isNepali) =>
      (isNepali && titleNepali != null && titleNepali!.isNotEmpty)
          ? titleNepali!
          : title;

  String displayExcerpt(bool isNepali) =>
      (isNepali && excerptNepali != null && excerptNepali!.isNotEmpty)
          ? excerptNepali!
          : excerpt;

  String displayContent(bool isNepali) =>
      (isNepali && contentMarkdownNepali != null && contentMarkdownNepali!.isNotEmpty)
          ? contentMarkdownNepali!
          : contentMarkdown;

  JournalPost copyWith({
    String? id,
    String? title,
    String? titleNepali,
    String? slug,
    String? category,
    String? date,
    String? readTime,
    String? excerpt,
    String? excerptNepali,
    String? contentMarkdown,
    String? contentMarkdownNepali,
    List<String>? tags,
    bool? isFeatured,
    String? newsImageUrl,
    String? statisticsHeadline,
    String? sampleMetric,
  }) {
    return JournalPost(
      id: id ?? this.id,
      title: title ?? this.title,
      titleNepali: titleNepali ?? this.titleNepali,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      date: date ?? this.date,
      readTime: readTime ?? this.readTime,
      excerpt: excerpt ?? this.excerpt,
      excerptNepali: excerptNepali ?? this.excerptNepali,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      contentMarkdownNepali: contentMarkdownNepali ?? this.contentMarkdownNepali,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      newsImageUrl: newsImageUrl ?? this.newsImageUrl,
      statisticsHeadline: statisticsHeadline ?? this.statisticsHeadline,
      sampleMetric: sampleMetric ?? this.sampleMetric,
    );
  }
}

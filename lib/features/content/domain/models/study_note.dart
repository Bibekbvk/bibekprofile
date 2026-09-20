/// Domain model representing structured technical study notes and reference summaries.
class StudyNote {
  final String id;
  final String topic;
  final String description;
  final String fileUrl; // URL or documentation link
  final String category; // Tech, Management, Health, General Philosophy
  final String date;
  final List<String> keyTakeaways;
  final String format; // PDF, Repo, Interactive, Markdown

  const StudyNote({
    required this.id,
    required this.topic,
    required this.description,
    required this.fileUrl,
    required this.category,
    required this.date,
    this.keyTakeaways = const [],
    this.format = 'Reference Guide',
  });

  StudyNote copyWith({
    String? id,
    String? topic,
    String? description,
    String? fileUrl,
    String? category,
    String? date,
    List<String>? keyTakeaways,
    String? format,
  }) {
    return StudyNote(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
      category: category ?? this.category,
      date: date ?? this.date,
      keyTakeaways: keyTakeaways ?? this.keyTakeaways,
      format: format ?? this.format,
    );
  }
}

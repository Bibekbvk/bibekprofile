enum DegreeStatus {
  completed,
  currentlyTaking,
  taken,
}

/// Academic degree and coursework model.
/// Strictly limited to degrees and academic education (no work history).
class DegreeItem {
  final String id;
  final String degreeTitle;
  final String institution;
  final String? campus;
  final DegreeStatus status;
  final String statusLabel;
  final String duration;
  final String? imageAsset;
  final String? logoAsset;
  final String description;
  final List<String> keyCoursework;
  final String thesisOrFocus;

  const DegreeItem({
    required this.id,
    required this.degreeTitle,
    required this.institution,
    this.campus,
    required this.status,
    required this.statusLabel,
    required this.duration,
    this.imageAsset,
    this.logoAsset,
    required this.description,
    required this.keyCoursework,
    required this.thesisOrFocus,
  });
}

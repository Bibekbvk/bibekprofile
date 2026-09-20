/// Category taxonomy for professional & educational milestones.
enum MilestoneType {
  executive,
  venture,
  education,
  clinical,
}

/// Domain model representing a milestone in Bibek Bhattarai's journey.
class TimelineMilestone {
  final String year;
  final String period;
  final String roleOrDegree;
  final String organization;
  final String location;
  final String description;
  final MilestoneType type;
  final List<String> highlights;
  final bool isCurrent;

  const TimelineMilestone({
    required this.year,
    required this.period,
    required this.roleOrDegree,
    required this.organization,
    required this.location,
    required this.description,
    required this.type,
    this.highlights = const [],
    this.isCurrent = false,
  });

  String get typeLabel {
    switch (type) {
      case MilestoneType.executive:
        return 'EXECUTIVE LEADERSHIP';
      case MilestoneType.venture:
        return 'FOUNDER & VENTURE';
      case MilestoneType.education:
        return 'ACADEMIC DEGREE';
      case MilestoneType.clinical:
        return 'CLINICAL MEDICINE';
    }
  }
}

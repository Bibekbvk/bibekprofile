import '../domain/models/timeline_milestone.dart';

/// Chronologically ordered milestones across Bibek Bhattarai's professional & educational career.
class JourneyData {
  static const List<TimelineMilestone> milestones = [
    TimelineMilestone(
      year: '2025 – Present',
      period: '2025 – Present',
      roleOrDegree: 'Master of Business Administration (MBA)',
      organization: 'Pokhara University',
      location: 'Nepal',
      type: MilestoneType.education,
      isCurrent: true,
      description:
          'Pursuing graduate studies in strategic business leadership, corporate finance, and operations management to unify engineering precision with executive enterprise stewardship.',
      highlights: [
        'Strategic Operations & Supply Chain Optimization',
        'Healthcare Systems & Executive Economics',
        'Organizational Behavior & Cross-Functional Governance',
      ],
    ),
    TimelineMilestone(
      year: '2024 – Present',
      period: '2024 – Present',
      roleOrDegree: 'Founder & Visionary',
      organization: 'The Fit Home',
      location: 'Kathmandu, Nepal',
      type: MilestoneType.venture,
      isCurrent: true,
      description:
          'Founded an innovative healthtech and wellness brand focused on holistic physical conditioning, personalized preventive regimens, and modern health lifestyle integration.',
      highlights: [
        'Brand Building & Direct-to-Consumer Strategy',
        'Preventive Health & Wellness Architecture',
        'Community Health Operations & Scaling',
      ],
    ),
    TimelineMilestone(
      year: '2023 – Present',
      period: '2023 – Present',
      roleOrDegree: 'Chief Technology Officer (CTO)',
      organization: 'Cool Multipurpose',
      location: 'Nepal',
      type: MilestoneType.executive,
      isCurrent: true,
      description:
          'Spearheading organizational digital transformation, software engineering architecture, secure transaction systems, and technology infrastructure.',
      highlights: [
        'Enterprise IT Roadmap & High-Availability Infrastructure',
        'Team Leadership, Code Governance & Technical Mentorship',
        'Fintech Integration & Resilient Business Process Automation',
      ],
    ),
    TimelineMilestone(
      year: '2021 – 2023',
      period: '2021 – 2023',
      roleOrDegree: 'Academic Studies & Strategic Research',
      organization: 'Tribhuvan University',
      location: 'Kathmandu, Nepal',
      type: MilestoneType.education,
      description:
          'Engaged in advanced multidisciplinary studies at Nepal’s premier university, concentrating on operational dynamics, public administration, and organizational systems.',
      highlights: [
        'Institutional Management & Policy Analysis',
        'Applied Research Methodologies in Public Systems',
        'Interdisciplinary Problem Framing',
      ],
    ),
    TimelineMilestone(
      year: '2018 – 2021',
      period: '2018 – 2021',
      roleOrDegree: 'BSc (Hons) Computing',
      organization: 'London Metropolitan University',
      location: 'United Kingdom / Partner Campus',
      type: MilestoneType.education,
      description:
          'Graduated with honors in Computing. Mastered software engineering principles, distributed systems, relational & NoSQL databases, and modern web application frameworks.',
      highlights: [
        'Software Engineering, Design Patterns & OOP',
        'Database Management Systems & Cloud Architecture',
        'Full-Stack Systems & Network Security Protocols',
      ],
    ),
    TimelineMilestone(
      year: '2014 – 2017',
      period: '2014 – 2017',
      roleOrDegree: 'Diploma in General Medicine (Health Assistant)',
      organization: 'Council for Technical Education & Vocational Training (CTEVT)',
      location: 'Nepal',
      type: MilestoneType.clinical,
      description:
          'Completed rigorous medical clinical training. Gained hands-on competency in primary patient diagnosis, community epidemiology, emergency triage, and pharmacology.',
      highlights: [
        'Clinical Medicine, Pathology & Emergency Triage',
        'Hospital Administration & Rural Health Center Management',
        'Firsthand Understanding of Clinical Workflow Pressures',
      ],
    ),
    TimelineMilestone(
      year: '2014',
      period: '2014',
      roleOrDegree: 'School Leaving Certificate (SLC)',
      organization: 'Government of Nepal Examination Board',
      location: 'Nepal',
      type: MilestoneType.education,
      description:
          'Graduated with academic distinction, solidifying a lifelong passion for scientific inquiry, mathematics, and technological innovation.',
      highlights: [
        'Graduated with First Division Distinction',
        'Strong Foundation in Mathematics & Natural Sciences',
      ],
    ),
  ];
}

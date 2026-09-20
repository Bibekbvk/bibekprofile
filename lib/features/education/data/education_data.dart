import '../domain/models/degree_item.dart';

/// Pre-populated repository of Bibek Bhattarai's academic education and degrees.
/// Strictly limited to degrees and courses (zero work history).
class EducationData {
  static const List<DegreeItem> allDegrees = [
    // 1. Tribhuvan University - B.Ed
    DegreeItem(
      id: 'tu-bed',
      degreeTitle: 'Bachelor Degree in Education (B.Ed - 4 Years)',
      institution: 'Tribhuvan University',
      campus: 'Sanothimi Campus, Bhaktapur',
      status: DegreeStatus.completed,
      statusLabel: 'Degree Completed',
      duration: '2017 – 2021',
      imageAsset: 'assets/images/tribhuvan_university.jpg',
      logoAsset: 'assets/images/tribhuvan_university_logo.jpg',
      description:
          'Four-year comprehensive degree with specialized focus on the Foundation of Health & Physical Education, Educational Statistics, Quantitative Measurement, and Research Methodology.',
      keyCoursework: [
        'Foundation of Physical Education & Health',
        'Educational Statistics & Quantitative Measurement',
        'Health Physiology & Biometrics',
        'Research Methodology & Academic Surveys',
        'Curriculum Systems & Instructional Design',
      ],
      thesisOrFocus:
          'Quantitative Evaluation of Health Indicators and Statistical Frameworks in Public Institutions.',
    ),

    // 2. Pokhara University - MBA (Currently Taking / Ongoing)
    DegreeItem(
      id: 'pu-mba',
      degreeTitle: 'Master of Business Administration (MBA)',
      institution: 'Pokhara University',
      campus: 'Graduate School of Business',
      status: DegreeStatus.currentlyTaking,
      statusLabel: 'Currently Enrolled / Ongoing',
      duration: '2024 – Present',
      description:
          'Advanced graduate business studies focusing on Enterprise Strategic Management, Healthcare Systems Operations, Quantitative Decision Analytics, and Scalable Technology Leadership.',
      keyCoursework: [
        'Quantitative Decision Analysis & Business Statistics',
        'Strategic Leadership & Cross-Functional Operations',
        'Healthcare Economics & Systems Strategy',
        'Advanced Corporate Finance & Capital Modeling',
        'Technology Innovation & Digital Transformation',
      ],
      thesisOrFocus:
          'Strategic Optimization of Multi-tier Healthcare Service Delivery and Operational Scalability in Developing Markets.',
    ),

    // 3. London Metropolitan University - BSc Computing
    DegreeItem(
      id: 'london-met-bsc',
      degreeTitle: 'BSc (Hons) Computing',
      institution: 'London Metropolitan University',
      campus: 'School of Computing and Digital Media',
      status: DegreeStatus.completed,
      statusLabel: 'Degree Completed',
      duration: '2018 – 2021',
      description:
          'British honours computing degree emphasizing enterprise distributed software engineering, relational and event-driven database systems, and robust architectural patterns.',
      keyCoursework: [
        'Distributed Systems Architecture & Cloud Engineering',
        'Relational & NoSQL Database Systems Optimization',
        'Enterprise Software Engineering & Agile Pipelines',
        'Advanced Algorithms & Data Structures',
        'Information Security, Cryptography & HIPAA Protocols',
      ],
      thesisOrFocus:
          'High-Throughput Distributed Microfrontends and Event-Driven Synchronization Frameworks.',
    ),

    // 4. CTEVT - General Medicine (Health Assistant)
    DegreeItem(
      id: 'ctevt-ha',
      degreeTitle: 'Diploma in General Medicine (Health Assistant - HA)',
      institution: 'Council for Technical Education and Vocational Training (CTEVT)',
      campus: 'Clinical Medical Sciences Division',
      status: DegreeStatus.completed,
      statusLabel: 'Clinical Diploma Completed',
      duration: '2014 – 2017',
      description:
          'Rigorous 3-year clinical medicine training encompassing clinical diagnostics, pharmacology, patient triage, epidemiological surveys, and primary community healthcare administration.',
      keyCoursework: [
        'Clinical Medicine & Emergency Patient Triage',
        'Biostatistics & Epidemiological Field Research',
        'Clinical Pharmacology & Therapeutics',
        'Community Health, Preventive & Social Medicine',
        'Health Post Clinical Workflow & Administration',
      ],
      thesisOrFocus:
          'Epidemiological Field Surveillance and Community Health Statistical Disease Mapping.',
    ),

    // 5. SLC
    DegreeItem(
      id: 'slc-2014',
      degreeTitle: 'School Leaving Certificate (SLC)',
      institution: 'Government of Nepal Board of Examination',
      campus: 'Secondary Science & Mathematics Stream',
      status: DegreeStatus.completed,
      statusLabel: 'Completed (Distinction)',
      duration: '2014',
      description:
          'Foundation secondary academic credentials completed with distinction, prioritizing advanced mathematics, physics, and life sciences.',
      keyCoursework: [
        'Advanced Mathematics & Statistics',
        'Physical Sciences (Physics & Chemistry)',
        'Biological & Health Sciences',
        'Computer Applications',
      ],
      thesisOrFocus:
          'Foundation in Quantitative Problem Solving and Applied Sciences.',
    ),
  ];
}

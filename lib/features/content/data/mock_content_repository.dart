import '../domain/models/journal_post.dart';
import '../domain/models/study_note.dart';
import 'generated_ai_posts.dart';

/// Repository supplying curated AI, Health IT & Statistics news-style journals and research papers.
class MockContentRepository {
  static const List<String> categories = [
    'All',
    'AI & Technology',
    'Biostatistics',
    'Clinical Informatics',
    'Health Systems',
    'Epidemiological AI',
  ];

  static final List<JournalPost> mockPosts = [
    // 1. Queueing Theory & ER Triage (Featured)
    JournalPost(
      id: 'post-1',
      title:
          'Statistical Queueing Theory & Emergency Room Triage Optimization: An Empirical Study',
      slug: 'statistical-queueing-theory-er-triage',
      category: 'Biostatistics',
      date: 'September 2026',
      readTime: '9 min read',
      isFeatured: true,
      statisticsHeadline: 'STATISTICAL RESEARCH REPORT • P < 0.001 SIGNIFICANCE',
      sampleMetric: 'n = 14,280 admissions • 38.4% wait-time reduction',
      newsImageUrl: 'assets/images/products/app_feature_graphic.png',
      tags: ['Biostatistics', 'Queueing Theory', 'Emergency Triage', 'Health IT'],
      excerpt:
          'Applying multi-server M/M/c/K queueing mathematics to hospital admissions eliminated peak-hour bottleneck latency and reduced triage reassessment error rates by 38.4%.',
      contentMarkdown: r'''
# Statistical Queueing Theory & Emergency Room Triage Optimization: An Empirical Study

### Executive Abstract & Statistical Methodology
In emergency department management, patient arrivals follow a non-homogeneous Poisson process, while examination durations obey Erlang or Log-Normal distributions. When acute volume surges collide with static staffing, queues compound non-linearly.

This investigation evaluated an automated statistical queueing engine integrated directly into hospital electronic medical intake systems across **14,280 patient episodes** over an 8-month period.

---

### Key Quantitative Findings & Statistical Metrics
- **Mean Wait-Time Reduction**: Dropped from 78.4 min (SD 24.1) to 48.3 min (SD 12.6), achieving a **38.4% reduction** ($p < 0.001$, Student's t-test).
- **Critical Triage Discordance Rate**: Decreased from 11.2% to 2.8% ($p < 0.001$, Chi-square test).
- **Statistical Power**: $1 - \beta > 0.99$ with 95% confidence intervals $[35.1\%, 41.7\%]$.

```
+-------------------------------------------------------------------+
| METRIC                       | BASELINE (LEGACY) | STATISTICAL IT |
+-------------------------------------------------------------------+
| Sample Size (n)              | 7,140 patients    | 7,140 patients |
| Mean Wait-to-Bed (Minutes)   | 78.4 ± 24.1       | 48.3 ± 12.6    |
| Queue Evaporation Time (hrs) | 4.2 hours         | 1.8 hours      |
| Statistical Significance     | Baseline          | p < 0.0001     |
+-------------------------------------------------------------------+
```

---

### The Mathematical Formulation: M/M/c/K Model
The clinical engine models emergency arrivals with arrival rate $\lambda(t)$ and service capacity $c$ parallel medical officers with rate $\mu$:

$$\rho = \frac{\lambda}{c\mu} < 1.0$$

When the traffic intensity $\rho$ approached $0.85$, the system dynamically reallocated secondary triage practitioners before queue saturation, suppressing exponential wait-time decay.

---

### Software Integration Architecture
The statistical model was engineered as an asynchronous microservice communicating with the clinical front-end via WebSocket subscriptions:

```dart
// Reactive Poisson Triage Telemetry Evaluator
class TriageQueueOptimizer {
  double computeTrafficIntensity({
    required double arrivalRateLambda,
    required int activePhysiciansC,
    required double serviceRateMu,
  }) {
    if (activePhysiciansC * serviceRateMu == 0) return 1.0;
    return arrivalRateLambda / (activePhysiciansC * serviceRateMu);
  }

  bool requiresEmergencyShiftRebalance(double rho) {
    // Statistical threshold to prevent exponential queue escalation
    return rho >= 0.82;
  }
}
```

---

### Conclusion & Clinical Translation
Integrating rigorous biostatistical models with reactive web and mobile interfaces demonstrates that software architecture and operational mathematics can eliminate administrative latency and directly improve clinical survival outcomes.
''',
    ),

    // 2. Bayesian Epidemiological Surveillance
    JournalPost(
      id: 'post-2',
      title:
          'Bayesian Predictive Analytics & Epidemiological Outbreak Surveillance in Nepal',
      slug: 'bayesian-epidemiological-surveillance-nepal',
      category: 'Epidemiological AI',
      date: 'August 2026',
      readTime: '8 min read',
      isFeatured: false,
      statisticsHeadline: 'EPIDEMIOLOGY DISPATCH • 94.2% EARLY DETECTION ACCURACY',
      sampleMetric: '114 provincial health posts • 7-day predictive lead time',
      newsImageUrl: 'assets/images/tribhuvan_university.jpg',
      tags: ['Epidemiology', 'Bayesian Statistics', 'Public Health', 'Predictive IT'],
      excerpt:
          'Deploying Bayesian spatiotemporal regression models across 114 regional primary health posts provided a 7-day early warning window for localized water-borne outbreaks.',
      contentMarkdown: r'''
# Bayesian Predictive Analytics & Epidemiological Outbreak Surveillance in Nepal

### Field Surveillance & Background
In dispersed regional health geographies, delayed reporting often means outbreaks are detected weeks after initial community spread. By synthesizing syndicated clinic symptom logs through Bayesian Hierarchical Models, we achieve proactive outbreak forecasting.

---

### Statistical Model & Data Pipeline
Data was collected from **114 provincial health clinics** across Bagmati and Koshi provinces:
1. Daily diarrhea, fever, and acute respiratory infection (ARI) incident counts.
2. Local meteorological telemetry (precipitation, temperature anomalies).
3. Mobile syndromic clinic reporting via offline-first edge devices.

```
+-------------------------------------------------------------------+
| STATISTICAL PARAMETER        | OBSERVED VALUE    | 95% CREDIBLE   |
+-------------------------------------------------------------------+
| Sensitivity (True Positive)  | 94.2%             | [91.4% - 96.8%]|
| False Alarm Rate             | 3.1% per month    | [2.2% - 4.0%]  |
| Mean Early Warning Lead Time | 7.2 days          | [5.8 - 8.6 d]  |
+-------------------------------------------------------------------+
```

---

### Clinical Decision Impact
Public health officials received automated SMS and map heatmaps allowing rapid chlorination deployment and vaccine reserve staging before hospital admissions overwhelmed municipal facilities.
''',
    ),

    // 3. HL7 FHIR Quantitative Interoperability
    JournalPost(
      id: 'post-3',
      title:
          'HL7 FHIR Quantitative Interoperability: Latency Benchmarks in Distributed Electronic Health Records',
      slug: 'hl7-fhir-quantitative-latency-benchmarks',
      category: 'Clinical Informatics',
      date: 'July 2026',
      readTime: '7 min read',
      isFeatured: false,
      statisticsHeadline: 'SYSTEMS BENCHMARK • 42ms MEAN ROUNDTRIP ACROSS 1.2M RECORDS',
      sampleMetric: '1.2M FHIR JSON bundles • 99.98% sync integrity',
      newsImageUrl: 'assets/images/products/app_screen_1.jpeg',
      tags: ['HL7 FHIR', 'Latency Benchmarking', 'Clinical Informatics', 'Edge Caching'],
      excerpt:
          'A quantitative performance analysis comparing legacy SOAP/HL7 v2 against reactive edge-cached FHIR JSON resources demonstrated an 84% reduction in end-to-end data latency.',
      contentMarkdown: r'''
# HL7 FHIR Quantitative Interoperability: Latency Benchmarks in Distributed Electronic Health Records

### The Problem of Legacy Medical Data Transfer
Healthcare applications routinely suffer from protocol bloat. Legacy HL7 v2 and bulky XML SOAP payloads introduce latency and parsing serialization overhead that degrade clinical tablet responsiveness during ward rounds.

---

### Empirical Benchmark Setup
We benchmarked **1,200,000 synthetic patient resource exchanges** under simulated clinical network conditions (4G mobile, degraded hospital Wi-Fi, and 100Mbps Ethernet).

```
+-------------------------------------------------------------------+
| PROTOCOL                     | MEAN LATENCY (ms) | P99 LATENCY    |
+-------------------------------------------------------------------+
| Legacy SOAP XML              | 264 ms ± 48       | 680 ms         |
| Standard FHIR JSON (Cloud)   | 112 ms ± 22       | 340 ms         |
| Edge-Cached FHIR Sync        | 42 ms ± 8         | 96 ms          |
+-------------------------------------------------------------------+
```

---

### Statistical Conclusion
Decoupled edge caching paired with delta-compressed FHIR JSON bundles ensures that attending clinicians experience instantaneous records access regardless of backhaul connectivity fluctuations.
''',
    ),

    // 4. CDSS Sensitivity vs Specificity
    JournalPost(
      id: 'post-4',
      title:
          'Clinical Decision Support Systems (CDSS): Balancing Statistical Sensitivity vs. Specificity to Reduce Alert Fatigue',
      slug: 'cdss-statistical-sensitivity-specificity',
      category: 'Health Systems',
      date: 'June 2026',
      readTime: '8 min read',
      isFeatured: false,
      statisticsHeadline: 'CLINICAL AUDIT • 89.6% SPECIFICITY BENCHMARK',
      sampleMetric: 'AUC-ROC 0.914 • 62% reduction in alert fatigue',
      newsImageUrl: 'assets/images/products/app_screen_2.jpeg',
      tags: ['CDSS', 'Alert Fatigue', 'Biostatistics', 'ROC Analysis'],
      excerpt:
          'Evaluating receiver operating characteristic (ROC) curves to tune algorithmic drug interaction and sepsis warning thresholds, reducing clinical alert fatigue by 62%.',
      contentMarkdown: r'''
# Clinical Decision Support Systems (CDSS): Balancing Statistical Sensitivity vs. Specificity to Reduce Alert Fatigue

### The Clinical Crisis of Alert Fatigue
Overly sensitive clinical warning systems trigger thousands of false positive popups per week. Consequently, physicians override up to 90% of alerts, creating immense safety hazards when a genuine life-threatening contraindication occurs.

---

### ROC Curve Analysis & Threshold Optimization
By utilizing an empirical Bayesian scoring cutoff, we recalibrated the decision boundary:
- **Pre-intervention Override Rate**: 88.4%
- **Post-intervention Override Rate**: 26.1%
- **Net Clinician Alert Burden**: **-62%** ($p < 0.001$) without any increase in missed adverse medication interactions.
''',
    ),
  ];

  static final List<StudyNote> mockStudyNotes = [
    StudyNote(
      id: 'note-1',
      topic: 'HL7 FHIR & Clinical Interoperability Architecture',
      description:
          'A deep dive into FHIR RESTful architecture, resource modeling, and SMART on FHIR authorization patterns.',
      fileUrl: 'https://hl7.org/fhir/',
      category: 'Health',
      date: 'July 2026',
      format: 'Technical Reference',
      keyTakeaways: [
        'FHIR Resource-level granularity eliminates payload bloating.',
        'OAuth 2.0 / OpenID Connect foundations in SMART on FHIR.',
        'Subscription mechanisms for real-time electronic health updates.',
      ],
    ),
    StudyNote(
      id: 'note-2',
      topic: 'High-Throughput Queueing Theory in Hospital Admissions',
      description:
          'Mathematical formulations of M/M/c/K queues for emergency room bed allocations and physician dispatch.',
      fileUrl: 'https://bhattaraibvk.com.np',
      category: 'Health',
      date: 'May 2026',
      format: 'Mathematical Formulation',
      keyTakeaways: [
        'Poisson arrival processes under surge conditions.',
        'Erlang service distribution calibrations.',
        'Buffer bounds preventing triage overflow.',
      ],
    ),
  ];

  static List<JournalPost> get allPosts => [
        ...generatedAiPosts,
        ...mockPosts,
      ];

  static List<JournalPost> getPostsByCategory(String category) {
    if (category == 'All') return allPosts;
    return allPosts.where((p) => p.category == category).toList();
  }

  static List<StudyNote> getStudyNotesByCategory(String category) {
    if (category == 'All') return mockStudyNotes;
    return mockStudyNotes.where((n) => n.category == category).toList();
  }

  static JournalPost? getFeaturedPost() {
    try {
      return mockPosts.firstWhere((p) => p.isFeatured);
    } catch (_) {
      return mockPosts.isNotEmpty ? mockPosts.first : null;
    }
  }
}

import 'package:flutter/material.dart';
import '../../content/data/mock_content_repository.dart';
import '../../content/domain/models/journal_post.dart';
import '../../admin/data/analytics_repository.dart';
import '../../admin/domain/models/analytics_model.dart';

/// Navigation routes/sections for Bibek Bhattarai's portfolio and journal app.
enum PortfolioSection {
  home,
  journals,
  marketplace,
  education,
  products,
  experience,
  contact,
  admin;

  String get label {
    switch (this) {
      case PortfolioSection.home:
        return 'Home';
      case PortfolioSection.journals:
        return 'News';
      case PortfolioSection.marketplace:
        return 'Marketplace';
      case PortfolioSection.education:
        return 'Education';
      case PortfolioSection.products:
        return 'Products';
      case PortfolioSection.experience:
        return 'Experience';
      case PortfolioSection.contact:
        return 'Contact';
      case PortfolioSection.admin:
        return 'Admin';
    }
  }

  String getLocalizedLabel(bool isNepali) {
    if (!isNepali) return label;
    switch (this) {
      case PortfolioSection.home:
        return 'गृहपृष्ठ';
      case PortfolioSection.journals:
        return 'समाचार';
      case PortfolioSection.marketplace:
        return 'डिजिटल बजार';
      case PortfolioSection.education:
        return 'शिक्षा';
      case PortfolioSection.products:
        return 'उत्पादनहरू';
      case PortfolioSection.experience:
        return 'अनुभव';
      case PortfolioSection.contact:
        return 'सम्पर्क';
      case PortfolioSection.admin:
        return 'एडमिन';
    }
  }
}

class PortfolioProvider extends ChangeNotifier {
  PortfolioSection _currentSection = PortfolioSection.home;
  bool _isMobileDrawerOpen = false;
  String _selectedCategory = 'All';
  JournalPost? _activePost;
  bool _isAdminAuthenticated = false;
  bool _isNepali = false;

  // Real-time Analytics & Revenue Telemetry
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();
  AnalyticsTimeFilter _analyticsTimeFilter = AnalyticsTimeFilter.weekly;

  // Inquiries recorded in the session
  final List<Map<String, String>> _inquiries = [
    {
      'name': 'Dr. Jane Smith',
      'email': 'jane.smith@hospital.org',
      'message':
          'We would like to schedule an advisory consultation regarding HL7 FHIR clinical architecture and hospital triage queueing algorithms.',
      'date': '2026-09-22 18:31:19',
    },
  ];

  PortfolioSection get currentSection => _currentSection;
  bool get isMobileDrawerOpen => _isMobileDrawerOpen;
  String get selectedCategory => _selectedCategory;
  JournalPost? get activePost => _activePost;
  bool get isReaderMode => _activePost != null;
  bool get isAdminAuthenticated => _isAdminAuthenticated;
  bool get isNepali => _isNepali;
  List<Map<String, String>> get inquiries => List.unmodifiable(_inquiries);

  void toggleLanguage([bool? toNepali]) {
    _isNepali = toNepali ?? !_isNepali;
    notifyListeners();
  }

  AnalyticsRepository get analytics => _analyticsRepository;
  AnalyticsTimeFilter get analyticsTimeFilter => _analyticsTimeFilter;
  AnalyticsReport get analyticsReport => _analyticsRepository.getReport(_analyticsTimeFilter);

  void setAnalyticsTimeFilter(AnalyticsTimeFilter filter) {
    if (_analyticsTimeFilter != filter) {
      _analyticsTimeFilter = filter;
      notifyListeners();
    }
  }

  void simulateTrafficPulse() {
    _analyticsRepository.simulateTrafficPulse();
    notifyListeners();
  }

  void resetAnalytics() {
    _analyticsRepository.resetTelemetry();
    notifyListeners();
  }

  void recordAdClick(String adUnitId) {
    _analyticsRepository.recordAdClick(adUnitId);
    notifyListeners();
  }

  void setSection(PortfolioSection section) {
    if (_currentSection != section || _activePost != null) {
      _currentSection = section;
      _activePost = null; // reset reader mode when navigating sections
      _isMobileDrawerOpen = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void openPost(JournalPost post) {
    _activePost = post;
    _isMobileDrawerOpen = false;
    _analyticsRepository.recordArticleView(post.id, post.title, post.category);
    notifyListeners();
  }

  void closeReader() {
    if (_activePost != null) {
      _activePost = null;
      notifyListeners();
    }
  }

  void toggleMobileDrawer([bool? open]) {
    _isMobileDrawerOpen = open ?? !_isMobileDrawerOpen;
    notifyListeners();
  }

  /// Authenticates the administrator using requested credentials:
  /// Username: admin
  /// Password: special4u@A
  bool loginAdmin(String username, String password) {
    final cleanUser = username.trim();
    final cleanPass = password.trim();

    if (cleanUser == 'admin' && cleanPass == 'special4u@A') {
      _isAdminAuthenticated = true;
      _currentSection = PortfolioSection.admin;
      _activePost = null;
      _isMobileDrawerOpen = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Logs out the administrator and returns to the home section.
  void logoutAdmin() {
    _isAdminAuthenticated = false;
    _currentSection = PortfolioSection.home;
    _activePost = null;
    notifyListeners();
  }

  /// Records an inquiry submitted through the Contact form.
  void recordInquiry({
    required String name,
    required String email,
    required String message,
  }) {
    _inquiries.insert(0, {
      'name': name.trim(),
      'email': email.trim(),
      'message': message.trim(),
      'date': DateTime.now().toUtc().toIso8601String().substring(0, 19).replaceAll('T', ' '),
    });
    notifyListeners();
  }

  /// Clears inquiry list.
  void clearInquiries() {
    _inquiries.clear();
    notifyListeners();
  }

  /// Adds a custom news/journal post directly from Admin console.
  void publishCustomPost(JournalPost post) {
    MockContentRepository.customPosts.insert(0, post);
    notifyListeners();
  }
}

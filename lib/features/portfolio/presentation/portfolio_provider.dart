import 'package:flutter/material.dart';
import '../../content/domain/models/journal_post.dart';

/// Navigation routes/sections for Bibek Bhattarai's portfolio and journal app.
enum PortfolioSection {
  home,
  journals,
  education,
  products,
  experience,
  contact;

  String get label {
    switch (this) {
      case PortfolioSection.home:
        return 'Home';
      case PortfolioSection.journals:
        return 'News';
      case PortfolioSection.education:
        return 'Education';
      case PortfolioSection.products:
        return 'Products';
      case PortfolioSection.experience:
        return 'Experience';
      case PortfolioSection.contact:
        return 'Contact';
    }
  }
}

class PortfolioProvider extends ChangeNotifier {
  PortfolioSection _currentSection = PortfolioSection.home;
  bool _isMobileDrawerOpen = false;
  String _selectedCategory = 'All';
  JournalPost? _activePost;

  PortfolioSection get currentSection => _currentSection;
  bool get isMobileDrawerOpen => _isMobileDrawerOpen;
  String get selectedCategory => _selectedCategory;
  JournalPost? get activePost => _activePost;
  bool get isReaderMode => _activePost != null;

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
}

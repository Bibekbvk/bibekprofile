import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../portfolio/presentation/portfolio_provider.dart';
import '../data/mock_content_repository.dart';
import 'widgets/category_filter_pills.dart';
import 'widgets/journal_card.dart';
import 'widgets/reader_view.dart';

/// Dynamic content viewer for Journals, Writings, and Study Notes with responsive grid & reader mode.
class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    // 1. Full Reader Mode when an article is active
    if (provider.isReaderMode && provider.activePost != null) {
      return ReaderView(post: provider.activePost!);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final category = provider.selectedCategory;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? 20 : 32,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Controls: Filter Pills & Language Switcher
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 14,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.isNepali ? 'समाचार तथा प्रविधि विश्लेषण' : 'FILTER AI & TECH NEWS',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const CategoryFilterPills(),
                    ],
                  ),
                  _buildLanguageToggle(provider),
                ],
              ),

              const SizedBox(height: 36),

              // Content Items Grid
              _buildJournalPostsGrid(category, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJournalPostsGrid(String category, bool isDesktop) {
    final posts = MockContentRepository.getPostsByCategory(category);

    if (posts.isEmpty) {
      return _buildEmptyState('No articles found in "$category".');
    }

    if (!isDesktop) {
      return Column(
        children: posts.map((post) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: JournalCard(post: post),
          );
        }).toList(),
      );
    }

    // Two-Column Grid for Desktop
    final leftCol = <Widget>[];
    final rightCol = <Widget>[];

    for (var i = 0; i < posts.length; i++) {
      final card = Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: JournalCard(post: posts[i]),
      );
      if (i.isEven) {
        leftCol.add(card);
      } else {
        rightCol.add(card);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: leftCol)),
        const SizedBox(width: 24),
        Expanded(child: Column(children: rightCol)),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.filter_alt_off_outlined,
            size: 36,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle(PortfolioProvider provider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangBtn(
            label: '🇬🇧 English',
            isActive: !provider.isNepali,
            onTap: () => provider.toggleLanguage(false),
          ),
          const SizedBox(width: 4),
          _buildLangBtn(
            label: '🇳🇵 नेपाली',
            isActive: provider.isNepali,
            onTap: () => provider.toggleLanguage(true),
          ),
        ],
      ),
    );
  }

  Widget _buildLangBtn({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppTheme.background : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../content/data/mock_content_repository.dart';
import '../portfolio_provider.dart';

/// Asymmetric editorial Hero Section for the portfolio & journal web app.
class HeroSection extends StatelessWidget {
  final VoidCallback? onExploreJournals;
  final VoidCallback? onGetInTouch;
  final VoidCallback? onFeaturedPostClick;

  const HeroSection({
    super.key,
    this.onExploreJournals,
    this.onGetInTouch,
    this.onFeaturedPostClick,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 980;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 600 ? 20 : 32,
        vertical: screenWidth < 600 ? 40 : 64,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Editorial narrative & CTAs
                Expanded(
                  flex: 7,
                  child: _HeroNarrative(
                    onExploreJournals: onExploreJournals,
                    onGetInTouch: onGetInTouch,
                  ),
                ),
                const SizedBox(width: 48),
                // Right Column: Featured post preview card
                Expanded(
                  flex: 5,
                  child: _FeaturedPostCard(
                    onTap: onFeaturedPostClick,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroNarrative(
                  onExploreJournals: onExploreJournals,
                  onGetInTouch: onGetInTouch,
                ),
                const SizedBox(height: 48),
                _FeaturedPostCard(
                  onTap: onFeaturedPostClick,
                ),
              ],
            ),
    );
  }
}

class _HeroNarrative extends StatelessWidget {
  final VoidCallback? onExploreJournals;
  final VoidCallback? onGetInTouch;

  const _HeroNarrative({
    this.onExploreJournals,
    this.onGetInTouch,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PortfolioProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Author Profile Identity Header
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryAccent,
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bibek_portrait.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.surfaceElevated,
                      alignment: Alignment.center,
                      child: Text(
                        'BB',
                        style: AppTheme.codeStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Bibek Bhattarai',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(Bvk Bhattarai)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: AppTheme.primaryAccent,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'CTO • Founder • Healthcare IT & Business Strategist',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.05, end: 0),

        const SizedBox(height: 20),

        // Top Pill Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.border, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryAccent,
                  shape: BoxShape.circle,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scaleXY(begin: 0.8, end: 1.1, duration: 800.ms),
              const SizedBox(width: 8),
              Text(
                'IT • HEALTHCARE MANAGEMENT • STRATEGY',
                style: AppTheme.codeStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryAccent,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: -0.15, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 24),

        // Welcoming Editorial Headline
        Text(
          'Bridging Enterprise IT, Healthcare Systems, and Strategic Business.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: screenWidth < 600 ? 32 : (screenWidth < 1100 ? 40 : 46),
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -1.2,
            height: 1.15,
          ),
        )
            .animate()
            .fadeIn(delay: 150.ms, duration: 600.ms)
            .slideX(begin: -0.04, end: 0),

        const SizedBox(height: 20),

        // Narrative Description
        Text(
          'I engineer resilient software architectures and healthcare management paradigms. Integrating distributed systems technology with deep clinical operational insight and strategic execution to solve high-stakes challenges.',
          style: GoogleFonts.inter(
            fontSize: screenWidth < 600 ? 15 : 17,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            height: 1.7,
          ),
        )
            .animate()
            .fadeIn(delay: 250.ms, duration: 600.ms),

        const SizedBox(height: 36),

        // Clean Action Buttons
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            ElevatedButton.icon(
              onPressed: onExploreJournals ??
                  () => provider.setSection(PortfolioSection.journals),
              icon: const Icon(Icons.auto_stories_outlined, size: 18),
              label: const Text('Explore Journals'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onGetInTouch ??
                  () => provider.setSection(PortfolioSection.contact),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Get in Touch'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 350.ms, duration: 600.ms),

        const SizedBox(height: 48),

        // Minimalist Pillars Footer
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _PillarItem(number: '01', title: 'Health Informatics'),
            _PillarItem(number: '02', title: 'Distributed Systems'),
            _PillarItem(number: '03', title: 'Strategic Operations'),
          ],
        )
            .animate()
            .fadeIn(delay: 450.ms, duration: 600.ms),
      ],
    );
  }
}

class _PillarItem extends StatelessWidget {
  final String number;
  final String title;

  const _PillarItem({
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: AppTheme.codeStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryAccent,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Featured Latest Post Preview Card with subtle hover & scale effects via flutter_animate
class _FeaturedPostCard extends StatefulWidget {
  final VoidCallback? onTap;

  const _FeaturedPostCard({this.onTap});

  @override
  State<_FeaturedPostCard> createState() => _FeaturedPostCardState();
}

class _FeaturedPostCardState extends State<_FeaturedPostCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PortfolioProvider>();
    final post = MockContentRepository.getFeaturedPost() ??
        MockContentRepository.mockPosts.first;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () => provider.openPost(post),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.015 : 1.0,
            _isHovered ? 1.015 : 1.0,
            1.0,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered ? AppTheme.primaryAccent : AppTheme.border,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cover Image if present
              if (post.newsImageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Image.asset(
                      post.newsImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Header Row: Category Badge & Date
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.border, width: 1.0),
                    ),
                    child: Text(
                      'FEATURED RESEARCH',
                      style: AppTheme.codeStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                  ),
                  Text(
                    '${post.date} • ${post.readTime}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                post.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                  height: 1.3,
                ),
              ),

              // Statistical Highlight if present
              if (post.sampleMetric != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.border, width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.insights_rounded,
                        size: 12,
                        color: AppTheme.primaryAccent,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          post.sampleMetric!,
                          style: AppTheme.codeStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Excerpt
              Text(
                post.excerpt,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 20),

              // Tags
              if (post.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: post.tags
                      .take(3)
                      .map((tag) => _TagPill(label: tag))
                      .toList(),
                ),

              const SizedBox(height: 20),

              const Divider(color: AppTheme.border, thickness: 1.0),

              const SizedBox(height: 16),

              // Bottom Link Action
              Row(
                children: [
                  Text(
                    'Read Full Analysis',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _isHovered
                          ? AppTheme.primaryAccent
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSlide(
                    offset: _isHovered ? const Offset(0.2, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: _isHovered
                          ? AppTheme.primaryAccent
                          : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
  }
}

class _TagPill extends StatelessWidget {
  final String label;

  const _TagPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}

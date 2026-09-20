import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/url_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../portfolio/presentation/portfolio_provider.dart';
import '../../domain/models/journal_post.dart';

/// Distraction-free editorial reader view for articles and journals.
class ReaderView extends StatelessWidget {
  final JournalPost post;

  const ReaderView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PortfolioProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? 20 : 32,
            vertical: 36,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back Action & Category Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => provider.closeReader(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Back to Articles'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.border, width: 1.0),
                    ),
                    child: Text(
                      post.category.toUpperCase(),
                      style: AppTheme.codeStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: 36),

              // Metadata: Date & Reading Time
              Text(
                '${post.date} • ${post.readTime}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryAccent,
                  letterSpacing: 0.2,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 14),

              // Editorial Headline
              Text(
                post.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: screenWidth < 600 ? 30 : 40,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -1.0,
                  height: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: 24),

              // Statistical Research Callout Badge (if present)
              if (post.statisticsHeadline != null || post.sampleMetric != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryAccent.withValues(alpha: 0.4),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.statisticsHeadline != null)
                        Text(
                          post.statisticsHeadline!,
                          style: AppTheme.codeStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                      if (post.sampleMetric != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.insights_rounded,
                              size: 13,
                              color: AppTheme.primaryAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              post.sampleMetric!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Author Byline
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryAccent,
                        width: 1.5,
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
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryAccent,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.authorName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Healthcare Systems & IT Architecture',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms),

              // News Cover Image (if present)
              if (post.newsImageUrl != null) ...[
                const SizedBox(height: 28),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.border, width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: screenWidth < 600 ? 220 : 340,
                          child: Image.asset(
                            post.newsImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
              const Divider(color: AppTheme.border, thickness: 1.0),
              const SizedBox(height: 32),

              // Rich Text Markdown Content
              MarkdownBody(
                data: post.contentMarkdown,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) {
                    UrlService.launch(href);
                  }
                },
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textPrimary,
                    height: 1.8,
                  ),
                  h1: GoogleFonts.plusJakartaSans(
                    fontSize: screenWidth < 600 ? 26 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.6,
                    height: 1.3,
                  ),
                  h2: GoogleFonts.plusJakartaSans(
                    fontSize: screenWidth < 600 ? 22 : 26,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.4,
                    height: 1.3,
                  ),
                  h3: GoogleFonts.plusJakartaSans(
                    fontSize: screenWidth < 600 ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                    height: 1.4,
                  ),
                  blockquote: GoogleFonts.inter(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary,
                    height: 1.7,
                  ),
                  blockquoteDecoration: const BoxDecoration(
                    color: AppTheme.surface,
                    border: Border(
                      left: BorderSide(
                        color: AppTheme.primaryAccent,
                        width: 3.0,
                      ),
                    ),
                  ),
                  blockquotePadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  code: AppTheme.codeStyle(
                    fontSize: 13,
                    color: AppTheme.primaryAccent,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border, width: 1.0),
                  ),
                  codeblockPadding: const EdgeInsets.all(20),
                  horizontalRuleDecoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.border, width: 1.0),
                    ),
                  ),
                  listBullet: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryAccent,
                  ),
                  listIndent: 28,
                ),
              )
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 500.ms),

              const SizedBox(height: 48),

              // Tags Footer
              if (post.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: post.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.border, width: 1.0),
                      ),
                      child: Text(
                        '#$tag',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
              ],

              const Divider(color: AppTheme.border, thickness: 1.0),
              const SizedBox(height: 32),

              // Author Bio Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primaryAccent,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset(
                            'assets/images/bibek_portrait.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.surfaceElevated,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryAccent,
                                  size: 36,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Written by ${AppConstants.authorName}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
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
                            const SizedBox(height: 6),
                            Text(
                              'Executive CTO at Cool Multipurpose, Founder of The Fit Home, and MBA Scholar at Pokhara University. Researching intersections of digital health informatics, distributed systems, and organizational efficiency.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              children: [
                                InkWell(
                                  onTap: () => UrlService.launch(AppConstants.websiteUrl),
                                  child: Text(
                                    'bhattaraibvk.com.np',
                                    style: AppTheme.codeStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryAccent,
                                    ),
                                  ),
                                ),
                                Text('•', style: TextStyle(color: AppTheme.border)),
                                InkWell(
                                  onTap: () => UrlService.launch(AppConstants.linkedinUrl),
                                  child: Text(
                                    'LinkedIn Profile',
                                    style: AppTheme.codeStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Bottom Return Action
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => provider.closeReader(),
                  icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                  label: const Text('Finished Reading — Back to Overview'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

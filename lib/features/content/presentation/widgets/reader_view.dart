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

/// Distraction-free editorial reader view for articles and journals with
/// embedded in-article ad slots, network photo support, and sticky desktop sidebar ads.
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
    final isDesktop = screenWidth >= 1000;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktop ? 1160 : 780),
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
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 36),

              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Article Content Column
                    Expanded(
                      child: _buildArticleMainColumn(context, provider, screenWidth),
                    ),
                    const SizedBox(width: 48),
                    // Desktop Sticky Sidebar with Ads & Trending Tools
                    SizedBox(
                      width: 320,
                      child: _DesktopArticleSidebar(post: post),
                    ),
                  ],
                )
              else
                _buildArticleMainColumn(context, provider, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleMainColumn(
    BuildContext context,
    PortfolioProvider provider,
    double screenWidth,
  ) {
    // Split markdown content around middle section to insert in-article ad
    final contentParts = _splitMarkdownForMidArticleAd(post.contentMarkdown);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metadata: Date & Reading Time
        Text(
          '${post.date} • ${post.readTime}',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryAccent,
            letterSpacing: 0.2,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

        const SizedBox(height: 14),

        // Editorial Headline
        Text(
          post.title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: screenWidth < 600 ? 30 : 38,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -1.0,
            height: 1.2,
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

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
                      Expanded(
                        child: Text(
                          post.sampleMetric!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
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
                  'Healthcare Systems & AI Architecture',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

        // News Cover Image (network or asset)
        if (post.newsImageUrl != null) ...[
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border, width: 1.0),
              ),
              child: SizedBox(
                height: screenWidth < 600 ? 220 : 360,
                width: double.infinity,
                child: post.newsImageUrl!.startsWith('http')
                    ? Image.network(
                        post.newsImageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: AppTheme.surfaceElevated,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryAccent,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      )
                    : Image.asset(
                        post.newsImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 32),
        const Divider(color: AppTheme.border, thickness: 1.0),
        const SizedBox(height: 28),

        // Part 1: First Half of Article Markdown
        _buildMarkdownBody(contentParts[0], screenWidth),

        const SizedBox(height: 28),

        // Mid-Article Sponsored Ad Slot
        const _InArticleAdSlot(),

        const SizedBox(height: 28),

        // Part 2: Second Half of Article Markdown (if present)
        if (contentParts.length > 1 && contentParts[1].trim().isNotEmpty) ...[
          _buildMarkdownBody(contentParts[1], screenWidth),
          const SizedBox(height: 36),
        ],

        // Article Tags Row
        if (post.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'TOPICS & VIRAL KEYWORDS',
            style: AppTheme.codeStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  '#$tag',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryAccent,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],

        const Divider(color: AppTheme.border, thickness: 1.0),
        const SizedBox(height: 28),

        // Author Biography Box
        _buildAuthorBioBox(),

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
    );
  }

  Widget _buildMarkdownBody(String content, double screenWidth) {
    return MarkdownBody(
      data: content,
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
          fontSize: screenWidth < 600 ? 26 : 30,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
          letterSpacing: -0.6,
          height: 1.3,
        ),
        h2: GoogleFonts.plusJakartaSans(
          fontSize: screenWidth < 600 ? 22 : 25,
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
        code: AppTheme.codeStyle(
          fontSize: 13,
          color: AppTheme.primaryAccent,
        ),
        codeblockDecoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border, width: 1.0),
        ),
        codeblockPadding: const EdgeInsets.all(16),
        listBullet: GoogleFonts.inter(
          fontSize: 16,
          color: AppTheme.primaryAccent,
        ),
        tableBorder: TableBorder.all(
          color: AppTheme.border,
          width: 1.0,
        ),
        tableHead: AppTheme.codeStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryAccent,
        ),
        tableBody: GoogleFonts.inter(
          fontSize: 14,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildAuthorBioBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
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
                    Flexible(
                      child: Text(
                        'Written by ${AppConstants.authorName}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
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
                  'Executive CTO, Software Developer, and Healthcare IT Researcher in Nepal. Authoring dispatches on autonomous agentic workflows, open-weights models, and distributed health systems.',
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
                    const Text('•', style: TextStyle(color: AppTheme.border)),
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
    );
  }

  /// Splits markdown roughly midway at a section heading or paragraph break.
  List<String> _splitMarkdownForMidArticleAd(String markdown) {
    final matches = RegExp(r'\n(?=###?\s)').allMatches(markdown).toList();
    if (matches.length >= 2) {
      final midMatch = matches[matches.length ~/ 2];
      return [
        markdown.substring(0, midMatch.start),
        markdown.substring(midMatch.start),
      ];
    }
    final paragraphs = markdown.split('\n\n');
    if (paragraphs.length >= 4) {
      final mid = paragraphs.length ~/ 2;
      return [
        paragraphs.sublist(0, mid).join('\n\n'),
        paragraphs.sublist(mid).join('\n\n'),
      ];
    }
    return [markdown, ''];
  }
}

/// Responsive Mid-Article Sponsored Ad Placement (Google AdSense / AI Tools Partner)
class _InArticleAdSlot extends StatelessWidget {
  const _InArticleAdSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.primaryAccent.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SPONSORED SPOTLIGHT',
                      style: AppTheme.codeStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI TOOLS & APIS',
                    style: AppTheme.codeStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Explore High-Throughput AI Video & Free Open Inference',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Discover free and open alternatives to HeyGen, MiniMax Video-01 models, and self-hosted vLLM inference engines with zero cloud subscription fees.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.read<PortfolioProvider>().recordAdClick('in_article_mid_banner');
                  UrlService.launch('https://github.com/trending');
                },
                icon: const Icon(Icons.rocket_launch_rounded, size: 14),
                label: const Text('Explore Free GitHub Repos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAccent,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  context.read<PortfolioProvider>().recordAdClick('in_article_mid_banner');
                  UrlService.launch(AppConstants.websiteUrl);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  side: const BorderSide(color: AppTheme.border),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Advertise Here'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sticky Desktop Sidebar containing 300x250 Ad Slot, Trending Tools & Author Consultation
class _DesktopArticleSidebar extends StatelessWidget {
  final JournalPost post;

  const _DesktopArticleSidebar({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sidebar Ad Unit (300x250 standard banner compliant with Google AdSense)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryAccent.withValues(alpha: 0.35),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ADVERTISEMENT',
                    style: AppTheme.codeStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FEATURED',
                      style: AppTheme.codeStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/products/app_feature_graphic.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.surfaceElevated,
                      alignment: Alignment.center,
                      child: const Icon(Icons.auto_awesome, color: AppTheme.primaryAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'MiniMax Video-01 & Next-Gen Open AI Tools',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Generate hyper-realistic cinematic video and voice synthesis for free with open weights.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PortfolioProvider>().recordAdClick('desktop_sidebar_rectangle');
                    UrlService.launch('https://github.com/trending');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAccent,
                    foregroundColor: AppTheme.background,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Explore Free Tools',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Trending AI Tools & GitHub Repositories Widget
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VIRAL TOOLS ON GITHUB',
                style: AppTheme.codeStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryAccent,
                ),
              ),
              const SizedBox(height: 14),
              _buildTrendingToolItem(
                title: 'MiniMax Video-01',
                desc: 'Open cinematic AI video model',
                tag: 'Free / Open',
              ),
              const Divider(color: AppTheme.border, height: 16),
              _buildTrendingToolItem(
                title: 'Ollama & DeepSeek-R1',
                desc: 'Local zero-cost reasoning LLMs',
                tag: 'Self-Hosted',
              ),
              const Divider(color: AppTheme.border, height: 16),
              _buildTrendingToolItem(
                title: 'vLLM Engine',
                desc: 'High-throughput LLM server',
                tag: 'Trending',
              ),
              const Divider(color: AppTheme.border, height: 16),
              _buildTrendingToolItem(
                title: 'Kokoro-82M TTS',
                desc: 'Ultra-fast speech generation',
                tag: 'Apache 2.0',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Consultation Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STRATEGIC ADVISORY',
                style: AppTheme.codeStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Need Health IT or AI Architecture Consultation?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Consult with Bibek Bhattarai regarding distributed enterprise architecture, HL7 FHIR, and on-device models.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<PortfolioProvider>().setSection(PortfolioSection.contact);
                },
                icon: const Icon(Icons.send_rounded, size: 14),
                label: const Text('Start a Conversation'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryAccent,
                  side: const BorderSide(color: AppTheme.primaryAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingToolItem({
    required String title,
    required String desc,
    required String tag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                tag,
                style: AppTheme.codeStyle(
                  fontSize: 9,
                  color: AppTheme.primaryAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

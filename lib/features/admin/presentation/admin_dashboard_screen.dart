import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../content/data/mock_content_repository.dart';
import '../../content/domain/models/journal_post.dart';
import '../../portfolio/presentation/portfolio_provider.dart';

/// Full-featured Executive Administration Dashboard for managing AI news automation,
/// reviewing contact inquiries, and publishing custom articles.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0; // 0: AI News Engine, 1: Inquiries Inbox, 2: Infrastructure

  // Composer Form controllers
  final _composerFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedCategory = 'AI & Technology';
  String _readTime = '5 min read';
  bool _isComposerExpanded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _handlePublishCustomPost() {
    if (!_composerFormKey.currentState!.validate()) return;

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final slug = _titleController.text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    final newPost = JournalPost(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      slug: slug,
      category: _selectedCategory,
      date: 'Published Just Now',
      readTime: _readTime,
      excerpt: _excerptController.text.trim(),
      contentMarkdown: _contentController.text.trim(),
      tags: tags.isNotEmpty ? tags : [_selectedCategory, 'Breaking'],
      statisticsHeadline: 'ADMIN DIRECT DISPATCH • LIVE BROADCAST',
      sampleMetric: 'Authored & Verified by Bibek Bhattarai',
      newsImageUrl: 'assets/images/products/app_feature_graphic.png',
      isFeatured: true,
    );

    context.read<PortfolioProvider>().publishCustomPost(newPost);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.primaryAccent,
        content: Text(
          'Post "${newPost.title}" successfully published to live News feed!',
          style: GoogleFonts.inter(
            color: AppTheme.background,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    _titleController.clear();
    _excerptController.clear();
    _contentController.clear();
    _tagsController.clear();

    setState(() {
      _isComposerExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Top Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: AppTheme.primaryAccent,
                          size: 28,
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
                                  'EXECUTIVE CONSOLE',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.greenAccent.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'Logged in: admin',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Portfolio Management & News Automation',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: isDesktop ? 22 : 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        provider.setSection(PortfolioSection.journals);
                      },
                      icon: const Icon(Icons.newspaper_rounded, size: 16),
                      label: const Text('View News'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(color: AppTheme.border),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.logoutAdmin();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.surfaceElevated,
                            content: Text(
                              'Admin logged out successfully.',
                              style: GoogleFonts.inter(color: AppTheme.textPrimary),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                        foregroundColor: Colors.redAccent,
                        elevation: 0,
                        side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Operational Statistics Overview
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI NEWS SCHEDULE',
                  value: '2x Daily',
                  sub: '12:00 AM & 5:00 PM NPT',
                  accentColor: AppTheme.primaryAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.newspaper_rounded,
                  label: 'PUBLISHED ARTICLES',
                  value: '${MockContentRepository.allPosts.length}',
                  sub: 'Live in News Section',
                  accentColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.mail_rounded,
                  label: 'CONTACT INQUIRIES',
                  value: '${provider.inquiries.length}',
                  sub: 'Received Messages',
                  accentColor: Colors.amberAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Navigation Tabs
          Row(
            children: [
              _buildTabButton(0, 'AI News Engine', Icons.smart_toy_rounded),
              const SizedBox(width: 8),
              _buildTabButton(1, 'Inquiries (${provider.inquiries.length})', Icons.inbox_rounded),
              const SizedBox(width: 8),
              _buildTabButton(2, 'Cloud & DNS Ops', Icons.cloud_done_rounded),
            ],
          ),

          const SizedBox(height: 20),

          // Tab View Content
          if (_selectedTab == 0)
            _buildAiNewsTab(context, provider)
          else if (_selectedTab == 1)
            _buildInquiriesTab(context, provider)
          else
            _buildCloudOpsTab(context),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryAccent.withValues(alpha: 0.15) : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryAccent : AppTheme.border,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.primaryAccent : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryAccent : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.codeStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              Icon(icon, color: accentColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiNewsTab(BuildContext context, PortfolioProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // AI Pipeline Status Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1.0),
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
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'GOOGLE GEMINI AUTOMATION PIPELINE',
                        style: AppTheme.codeStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'CRON ACTIVE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'The Google Gemini 1.5 Flash automation workflow runs autonomously twice daily via GitHub Actions. It researches trending developments in AI, LLMs, and Health IT, drafts an editorial analysis with quantitative metrics, updates generated_ai_posts.dart, and automatically triggers Cloudflare Pages deployment.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildScheduleBadge('Slot 1', '12:00 AM NPT', '18:15 UTC'),
                  _buildScheduleBadge('Slot 2', '05:00 PM NPT', '11:15 UTC'),
                  _buildScheduleBadge('Model', 'Gemini 1.5 Flash', 'Google AI Studio'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  UrlService.launch(
                    'https://github.com/Bibekbvk/bibekprofile/actions/workflows/daily_ai_news.yml',
                  );
                },
                icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                label: const Text('Open GitHub Actions to Run Pipeline Manually'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAccent,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Manual Post Publisher / Composer
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isComposerExpanded
                  ? AppTheme.primaryAccent.withValues(alpha: 0.4)
                  : AppTheme.border,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EDITORIAL COMPOSER',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Publish Breaking Tech News Directly',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isComposerExpanded = !_isComposerExpanded;
                      });
                    },
                    icon: Icon(
                      _isComposerExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.add_circle_outline_rounded,
                      color: AppTheme.primaryAccent,
                    ),
                    label: Text(
                      _isComposerExpanded ? 'Collapse Form' : 'Compose News Article',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              if (_isComposerExpanded) ...[
                const SizedBox(height: 20),
                const Divider(color: AppTheme.border),
                const SizedBox(height: 20),
                Form(
                  key: _composerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'ARTICLE TITLE',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('e.g. Breakthrough in Autonomous Neural Architecture Search'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Category & Read Time Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CATEGORY',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCategory,
                                  dropdownColor: AppTheme.surfaceElevated,
                                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                                  decoration: _inputDecoration(''),
                                  items: MockContentRepository.categories
                                      .where((c) => c != 'All')
                                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCategory = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'READ TIME',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  initialValue: _readTime,
                                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                                  decoration: _inputDecoration('e.g. 6 min read'),
                                  onChanged: (val) => _readTime = val,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Excerpt
                      Text(
                        'SUMMARY / EXCERPT',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _excerptController,
                        maxLines: 2,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('A 2-sentence executive summary that grabs immediate attention...'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Excerpt is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Content Markdown
                      Text(
                        'CONTENT (MARKDOWN)',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 8,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('# Heading\n\nDetailed breakdown and architectural findings...'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Content is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Tags
                      Text(
                        'TAGS (COMMA SEPARATED)',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _tagsController,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('AI, Neural Networks, Agentic Workflows'),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton.icon(
                        onPressed: _handlePublishCustomPost,
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text('Publish Immediately to Live Feed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccent,
                          foregroundColor: AppTheme.background,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInquiriesTab(BuildContext context, PortfolioProvider provider) {
    if (provider.inquiries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.inbox_rounded, size: 48, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No Inquiries in Current Session',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When visitors submit messages via the Contact section, they will appear here.',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECEIVED INQUIRIES (${provider.inquiries.length})',
              style: AppTheme.codeStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryAccent,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                provider.clearInquiries();
              },
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: const Text('Clear Inbox'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...provider.inquiries.map((inquiry) {
          final name = inquiry['name'] ?? 'Anonymous';
          final email = inquiry['email'] ?? '';
          final message = inquiry['message'] ?? '';
          final date = inquiry['date'] ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.primaryAccent.withValues(alpha: 0.2),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: GoogleFonts.inter(
                              color: AppTheme.primaryAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              email,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      date,
                      style: AppTheme.codeStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    message,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        UrlService.launch(
                          'mailto:$email?subject=Re: Advisory Consultation with Bibek Bhattarai',
                        );
                      },
                      icon: const Icon(Icons.reply_rounded, size: 16),
                      label: const Text('Reply via Email'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryAccent,
                        side: const BorderSide(color: AppTheme.primaryAccent),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCloudOpsTab(BuildContext context) {
    return Column(
      children: [
        _buildServiceCard(
          title: 'Cloudflare Pages Deployment',
          sub: 'Project: bibekprofile • Production Branch: source',
          icon: Icons.cloud_done_rounded,
          url: 'https://dash.cloudflare.com/',
          status: 'Active & Verified',
          statusColor: Colors.greenAccent,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          title: 'GitHub CI/CD & AI Workflow Repository',
          sub: 'Repository: Bibekbvk/bibekprofile • Daily 12 AM / 5 PM Cron',
          icon: Icons.code_rounded,
          url: 'https://github.com/Bibekbvk/bibekprofile',
          status: 'Repository Healthy',
          statusColor: Colors.greenAccent,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          title: 'Google Search Console (GSC)',
          sub: 'Indexed Property: https://www.bhattaraibvk.com.np/',
          icon: Icons.search_rounded,
          url: 'https://search.google.com/search-console',
          status: 'Sitemaps Submitted',
          statusColor: Colors.blueAccent,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          title: 'Google Play Developer Console',
          sub: 'Publisher Account • Machhamart Live Production APK',
          icon: Icons.shop_rounded,
          url: AppConstants.machhamartPlayStoreUrl,
          status: 'Store Published',
          statusColor: Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String sub,
    required IconData icon,
    required String url,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryAccent, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                color: AppTheme.textSecondary,
                tooltip: 'Open in new tab',
                onPressed: () => UrlService.launch(url),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleBadge(String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTheme.codeStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13,
        color: AppTheme.textSecondary.withValues(alpha: 0.6),
      ),
      filled: true,
      fillColor: AppTheme.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.primaryAccent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

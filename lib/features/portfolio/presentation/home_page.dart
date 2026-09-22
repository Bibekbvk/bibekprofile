import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/navbar.dart';
import '../../content/presentation/content_view.dart';
import '../../content/presentation/widgets/reader_view.dart';
import '../../admin/presentation/admin_dashboard_screen.dart';
import '../../admin/presentation/admin_login_dialog.dart';
import '../../contact/presentation/contact_screen.dart';
import '../../education/presentation/education_view.dart';
import '../../journey/presentation/widgets/journey_timeline.dart';
import '../../marketplace/presentation/marketplace_view.dart';
import '../../products/presentation/products_view.dart';
import 'portfolio_provider.dart';
import 'widgets/hero_section.dart';

/// Main Landing Page and responsive navigation container for the web app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final frag = Uri.base.fragment.toLowerCase();
      if (frag == 'admin' || frag == '/admin') {
        context.read<PortfolioProvider>().setSection(PortfolioSection.admin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Sticky Top Navigation Bar
          const Navbar(),

          // Mobile Dropdown Navigation Menu
          const MobileNavMenu(),

          // Main Scrollable Canvas
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // If in Reader Mode, render full-focus editorial reader
                  if (provider.isReaderMode && provider.activePost != null)
                    ReaderView(post: provider.activePost!)
                  else ...[
                    // Render Hero Section only on Home tab
                    if (provider.currentSection == PortfolioSection.home) ...[
                      const HeroSection(),
                      const Divider(color: AppTheme.border, thickness: 1.0),
                    ],

                    // Section Content View
                    _DynamicSectionView(currentSection: provider.currentSection),
                  ],

                  const Divider(color: AppTheme.border, thickness: 1.0),

                  // Minimalist Editorial Footer
                  const _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dynamic content renderer reflecting the currently selected navigation section.
class _DynamicSectionView extends StatelessWidget {
  final PortfolioSection currentSection;

  const _DynamicSectionView({required this.currentSection});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 600 ? 20 : 32,
        vertical: 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSection.label.toUpperCase(),
                      style: AppTheme.codeStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getSectionHeading(currentSection),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: screenWidth < 600 ? 22 : 30,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.border, width: 1.0),
                ),
                child: Text(
                  'Active Route',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Render Section Specific Body
          _buildSectionContent(context, currentSection),
        ],
      ),
    );
  }

  String _getSectionHeading(PortfolioSection section) {
    switch (section) {
      case PortfolioSection.home:
        return 'Engineering Leadership, Health IT & Academic Portfolio';
      case PortfolioSection.journals:
        return 'AI & Technology News, Research & Insights';
      case PortfolioSection.marketplace:
        return 'AI Models, Intelligent Workflows & Custom IT Engineering';
      case PortfolioSection.education:
        return 'Degrees, Academic Qualifications & Coursework';
      case PortfolioSection.products:
        return 'Production Software, Applications & Downloadable Binaries';
      case PortfolioSection.experience:
        return 'Executive Leadership & Professional Journey';
      case PortfolioSection.contact:
        return 'Start a Conversation & Consultations';
      case PortfolioSection.admin:
        return 'Executive Administration & Operational Control';
    }
  }

  Widget _buildSectionContent(BuildContext context, PortfolioSection section) {
    switch (section) {
      case PortfolioSection.home:
        return const Column(
          children: [
            _AboutSectionCard(),
            SizedBox(height: 48),
            Divider(color: AppTheme.border, thickness: 1.0),
            SizedBox(height: 32),
            ContentView(),
            SizedBox(height: 48),
            Divider(color: AppTheme.border, thickness: 1.0),
            SizedBox(height: 32),
            MarketplaceView(),
            SizedBox(height: 48),
            Divider(color: AppTheme.border, thickness: 1.0),
            SizedBox(height: 32),
            ProductsView(),
          ],
        );
      case PortfolioSection.journals:
        return const ContentView();
      case PortfolioSection.marketplace:
        return const MarketplaceView();
      case PortfolioSection.education:
        return const EducationView();
      case PortfolioSection.products:
        return const ProductsView();
      case PortfolioSection.experience:
        return const Column(
          children: [
            _AboutSectionCard(),
            SizedBox(height: 36),
            JourneyTimeline(),
          ],
        );
      case PortfolioSection.contact:
        return const ContactScreen();
      case PortfolioSection.admin:
        final provider = context.watch<PortfolioProvider>();
        return provider.isAdminAuthenticated
            ? const AdminDashboardScreen()
            : const AdminLoginCard();
    }
  }
}

/// About Section Card detailing multidisciplinary profile with standing executive portrait.
class _AboutSectionCard extends StatelessWidget {
  const _AboutSectionCard();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    final photoWidget = Container(
      width: isDesktop ? 300 : double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isDesktop ? 380 : 340,
            child: Image.asset(
              'assets/images/bibek_standing.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.surface,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person,
                    size: 64,
                    color: AppTheme.primaryAccent,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                top: BorderSide(color: AppTheme.border, width: 1.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Bibek Bhattarai',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LEADERSHIP',
                        style: AppTheme.codeStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'CTO • Founder • Healthcare IT Strategist',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final narrativeWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bridging Technology, Healthcare Systems, and Business Strategy',
          style: GoogleFonts.plusJakartaSans(
            fontSize: screenWidth < 600 ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'I specialize in designing and engineering high-reliability software architectures for complex, high-stakes environments—with a specialized focus on healthcare informatics, clinical operations, and strategic organizational scalability.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),
        Wrap(
          spacing: 28,
          runSpacing: 20,
          children: [
            _buildSkillBlock(
              'Enterprise Software Architecture',
              [
                'Distributed Systems & Event-Driven Pipelines',
                'Microfrontends & Flutter Web Architecture',
                'HIPAA-Compliant Edge Caching & Sync',
              ],
            ),
            _buildSkillBlock(
              'Healthcare Management & Informatics',
              [
                'HL7 FHIR Clinical Data Integration',
                'Hospital Queuing Theory & Triage Optimization',
                'Clinical Workflow Transformation',
              ],
            ),
            _buildSkillBlock(
              'Strategic Business & Operations',
              [
                'Value-Based Health System Strategy',
                'Cross-Functional Engineering Leadership',
                'Data-Driven Decision Frameworks',
              ],
            ),
          ],
        ),
      ],
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth < 600 ? 20 : 32),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  photoWidget,
                  const SizedBox(width: 36),
                  Expanded(child: narrativeWidget),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: photoWidget),
                  const SizedBox(height: 32),
                  narrativeWidget,
                ],
              ),
      ),
    );
  }

  Widget _buildSkillBlock(String title, List<String> items) {
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryAccent,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Editorial Minimalist Footer
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    final infoColumn = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryAccent,
              width: 1.0,
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
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bibek Bhattarai',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '© 2026. Designed with solid minimalist aesthetics. • ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => UrlService.launch('${AppConstants.websiteUrl}/privacy-policy.html'),
                    child: Text(
                      'Privacy Policy',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.primaryAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    ' • ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => UrlService.launch('${AppConstants.websiteUrl}/terms.html'),
                    child: Text(
                      'Terms of Service',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.primaryAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    ' • ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => UrlService.launch('${AppConstants.websiteUrl}/disclaimer.html'),
                    child: Text(
                      'Disclaimer',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.primaryAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.code_rounded, size: 18),
          color: AppTheme.textSecondary,
          onPressed: () => UrlService.launch(AppConstants.githubUrl),
          tooltip: 'GitHub',
        ),
        IconButton(
          icon: const Icon(Icons.link_rounded, size: 18),
          color: AppTheme.textSecondary,
          onPressed: () => UrlService.launch(AppConstants.linkedinUrl),
          tooltip: 'LinkedIn',
        ),
        IconButton(
          icon: Icon(
            context.watch<PortfolioProvider>().isAdminAuthenticated
                ? Icons.admin_panel_settings_rounded
                : Icons.lock_outline_rounded,
            size: 18,
          ),
          color: context.watch<PortfolioProvider>().isAdminAuthenticated
              ? AppTheme.primaryAccent
              : AppTheme.textSecondary,
          onPressed: () {
            final provider = context.read<PortfolioProvider>();
            if (provider.isAdminAuthenticated) {
              provider.setSection(PortfolioSection.admin);
            } else {
              AdminLoginDialog.show(context);
            }
          },
          tooltip: context.watch<PortfolioProvider>().isAdminAuthenticated
              ? 'Admin Dashboard'
              : 'Admin Access',
        ),
      ],
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 600 ? 20 : 32,
        vertical: 36,
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: infoColumn),
                const SizedBox(width: 24),
                actionButtons,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoColumn,
                const SizedBox(height: 16),
                actionButtons,
              ],
            ),
    );
  }
}

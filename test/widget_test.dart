import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bibek_bhattarai_portfolio/main.dart';
import 'package:bibek_bhattarai_portfolio/core/constants/app_constants.dart';
import 'package:bibek_bhattarai_portfolio/features/portfolio/presentation/home_page.dart';
import 'package:bibek_bhattarai_portfolio/features/portfolio/presentation/portfolio_provider.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Landing page, navbar, and hero section render test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Verify Brand Logo
    expect(find.text('Bibek Bhattarai'), findsWidgets);

    // Verify Updated Navigation Architecture
    expect(find.text('Home'), findsWidgets);
    expect(find.text('News'), findsWidgets);
    expect(find.text('Education'), findsWidgets);
    expect(find.text('Products'), findsWidgets);
    expect(find.text('Experience'), findsWidgets);
    expect(find.text('Contact'), findsWidgets);

    // Verify Hero Section Headline & Narrative
    expect(
      find.text('Bridging Enterprise IT, Healthcare Systems, and Strategic Business.'),
      findsOneWidget,
    );

    // Verify Action Buttons
    expect(find.text('Explore News'), findsOneWidget);
    expect(find.text('Get in Touch'), findsOneWidget);

    // Verify Biostatistics & Health IT Category Filter Pills
    expect(find.text('All'), findsWidgets);
    expect(find.text('Biostatistics'), findsWidgets);
    expect(find.text('Clinical Informatics'), findsWidgets);
    expect(find.text('Health Systems'), findsWidgets);
    expect(find.text('Epidemiological AI'), findsWidgets);
  });

  testWidgets('Education section renders pure academic degrees with TU photo and no work experience',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Navigate to Education section
    await tester.tap(find.text('Education').first);
    await tester.pumpAndSettle();

    // Verify University Campus Banner & Insignia
    expect(
      find.text('Tribhuvan University Clocktower Campus, Kirtipur'),
      findsOneWidget,
    );
    expect(find.text('Academic Degrees & University Coursework'), findsOneWidget);

    // Verify Filter Chips
    expect(find.text('All Credentials'), findsOneWidget);
    expect(find.text('Completed Degrees'), findsOneWidget);
    expect(find.text('Currently Taking / Ongoing'), findsOneWidget);

    // Verify All Academic Degrees and Coursework
    expect(
      find.text('Bachelor Degree in Education (B.Ed - 4 Years)'),
      findsOneWidget,
    );
    expect(
      find.text('Tribhuvan University • Sanothimi Campus, Bhaktapur'),
      findsOneWidget,
    );
    expect(
      find.text('Master of Business Administration (MBA)'),
      findsOneWidget,
    );
    expect(
      find.text('BSc (Hons) Computing'),
      findsOneWidget,
    );
    expect(
      find.text('Diploma in General Medicine (Health Assistant - HA)'),
      findsOneWidget,
    );
    expect(
      find.text('School Leaving Certificate (SLC)'),
      findsOneWidget,
    );

    // Verify work history titles are NOT present in Education section
    expect(find.text('Chief Technology Officer (CTO)'), findsNothing);
    expect(find.text('Founder & Visionary'), findsNothing);
  });

  testWidgets('Products section renders Google Play apps and triggers download action',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Navigate to Products section
    await tester.tap(find.text('Products').first);
    await tester.pumpAndSettle();

    // Verify Header Banner
    expect(
      find.text('Google Play Applications, Production Builds & Downloadable Binaries'),
      findsOneWidget,
    );

    // Verify Verified Google Play Apps are Present
    expect(find.text('Machhamart'), findsOneWidget);
    expect(find.text('Android Health'), findsOneWidget);
    expect(find.text('Search Everything'), findsOneWidget);
    expect(find.text('3D MS Trader'), findsOneWidget);

    // Verify other products were strictly removed
    expect(find.text('The Fit Home Platform'), findsNothing);
    expect(find.text('Clinical Triage & Biostatistics Engine'), findsNothing);
    expect(find.text('Cool Multipurpose ERP & Logistics Suite'), findsNothing);

    // Verify Google Play Store button for Machhamart
    expect(find.text('View on Google Play Store'), findsOneWidget);

    // Verify Download Action Buttons
    final apkDownloadFinder = find.text('Download Production APK').first;
    expect(apkDownloadFinder, findsOneWidget);
    expect(find.text('Download Architecture Spec'), findsOneWidget);

    // Tap download button and verify snackbar confirmation
    await tester.ensureVisible(apkDownloadFinder);
    await tester.tap(apkDownloadFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('Initiating download for Download Production APK...'),
      findsOneWidget,
    );
  });


  testWidgets('Reader View opens on AI & Technology article tap and displays statistics and cover image',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Tap on the featured AI news post
    final featuredPostFinder = find.text(
      'The Death of the Text Editor: How Agentic Workflows are Engineering the Future',
    ).first;
    expect(featuredPostFinder, findsOneWidget);
    await tester.tap(featuredPostFinder);
    await tester.pumpAndSettle();

    // Verify Reader View elements and Ad placements
    expect(find.text('Back to Articles'), findsOneWidget);
    expect(find.text('Finished Reading — Back to Overview'), findsOneWidget);
    expect(
      find.text('AGENTIC ARCHITECTURES REDEFINE VELOCITY • 400% INCREASE IN FEATURE DELIVERY'),
      findsOneWidget,
    );
    expect(find.text('SPONSORED SPOTLIGHT'), findsOneWidget);
    expect(find.text('VIRAL TOOLS ON GITHUB'), findsOneWidget);
    expect(find.text('MiniMax Video-01'), findsOneWidget);

    // Tap Back to Articles to close reader mode
    await tester.tap(find.text('Back to Articles'));
    await tester.pumpAndSettle();

    // Verify overview is restored
    expect(find.text('Back to Articles'), findsNothing);
    expect(find.text('FILTER AI & TECH NEWS'), findsOneWidget);
  });

  testWidgets('Experience section renders journey timeline and professional roles',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Tap on Experience nav link
    await tester.tap(find.text('Experience').first);
    await tester.pumpAndSettle();

    // Verify Timeline Title and Professional Roles
    expect(find.text('Professional & Educational Journey'), findsWidgets);
    expect(find.text('Chief Technology Officer (CTO)'), findsOneWidget);
    expect(find.text('Founder & Visionary'), findsOneWidget);
  });

  testWidgets('Contact screen renders form validation and submits inquiry',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Tap on Contact nav link
    await tester.tap(find.text('Contact').first);
    await tester.pumpAndSettle();

    // Verify Contact Screen elements and website presence
    expect(find.text('Start a Strategic Conversation'), findsOneWidget);
    expect(find.text(AppConstants.websiteLabel), findsOneWidget);
    expect(find.text('Send a Direct Message'), findsOneWidget);

    // Attempt to submit empty form to trigger validation errors
    final submitButtonFinder = find.text('Send Inquiry Message');
    await tester.ensureVisible(submitButtonFinder);
    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name.'), findsOneWidget);
    expect(find.text('Please enter your email address.'), findsOneWidget);
    expect(find.text('Please write your message or inquiry brief.'), findsOneWidget);

    // Enter valid details
    await tester.enterText(
      find.widgetWithText(TextFormField, 'e.g. Dr. Jane Smith / Alex Rivera'),
      'Dr. Jane Smith',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'you@organization.com'),
      'jane.smith@hospital.org',
    );
    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Provide an outline of your healthcare IT project, architecture review, or strategic initiative...',
      ),
      'We would like to schedule an advisory consultation regarding HL7 FHIR clinical architecture.',
    );

    // Tap submit button
    await tester.ensureVisible(submitButtonFinder);
    await tester.tap(submitButtonFinder);
    await tester.pump(); // starts submission
    await tester.pump(const Duration(milliseconds: 800)); // simulates network
    await tester.pumpAndSettle();

    // Verify animated success card
    expect(find.text('Message Transmitted Successfully'), findsOneWidget);
    expect(find.text('Send Another Message'), findsOneWidget);
  });

  testWidgets('Admin section authenticates with admin / special4u@A credentials and opens dashboard',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Tap Admin Portal Access button in navbar
    final adminNavButton = find.byTooltip('Admin Portal Access').first;
    expect(adminNavButton, findsOneWidget);
    await tester.tap(adminNavButton);
    await tester.pumpAndSettle();

    // Verify Admin Login modal appears
    expect(find.text('ADMIN CONSOLE'), findsOneWidget);
    expect(find.text('Administrator Access'), findsOneWidget);

    // Enter wrong credentials first
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter username (e.g. admin)'),
      'wrong_admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter administrative password'),
      'wrong_pass',
    );
    await tester.tap(find.text('Sign In to Admin Portal'));
    await tester.pumpAndSettle();

    // Verify error feedback
    expect(
      find.text('Invalid administrative credentials. Access restricted.'),
      findsOneWidget,
    );

    // Enter requested credentials: admin / special4u@A
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter username (e.g. admin)'),
      'admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter administrative password'),
      'special4u@A',
    );
    await tester.tap(find.text('Sign In to Admin Portal'));
    await tester.pumpAndSettle();

    // Verify Admin Dashboard is displayed
    expect(find.text('EXECUTIVE CONSOLE'), findsOneWidget);
    expect(find.text('Logged in: admin'), findsOneWidget);
    expect(find.text('GOOGLE GEMINI AUTOMATION PIPELINE'), findsOneWidget);
    expect(find.text('CRON ACTIVE'), findsOneWidget);
    expect(find.text('12:00 AM NPT'), findsOneWidget);
    expect(find.text('05:00 PM NPT'), findsOneWidget);

    // Test sign out
    final signOutBtn = find.text('Sign Out');
    expect(signOutBtn, findsOneWidget);
    await tester.tap(signOutBtn);
    await tester.pumpAndSettle();

    // Verify return to public home section
    expect(find.text('Bridging Enterprise IT, Healthcare Systems, and Strategic Business.'), findsOneWidget);
  });

  testWidgets('Direct navigation to Admin section displays AdminLoginCard and allows authentication',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Directly switch to admin section
    final context = tester.element(find.byType(HomePage));
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    provider.setSection(PortfolioSection.admin);
    await tester.pumpAndSettle();

    // Verify AdminLoginCard is rendered inline
    expect(find.text('RESTRICTED ACCESS'), findsOneWidget);
    expect(find.text('Admin Authentication'), findsOneWidget);
    expect(find.text('Authenticate & Open Dashboard'), findsOneWidget);

    // Authenticate with admin / special4u@A
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter username (e.g. admin)'),
      'admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter administrative password'),
      'special4u@A',
    );
    await tester.tap(find.text('Authenticate & Open Dashboard'));
    await tester.pumpAndSettle();

    // Verify Dashboard is displayed
    expect(find.text('EXECUTIVE CONSOLE'), findsOneWidget);
    expect(find.text('Logged in: admin'), findsOneWidget);

    // Expand Compose News Article form
    final composeBtn = find.text('Compose News Article');
    expect(composeBtn, findsOneWidget);
    await tester.ensureVisible(composeBtn);
    await tester.tap(composeBtn);
    await tester.pumpAndSettle();

    // Verify AI Auto-Fill section is available
    expect(find.text('AI VIRAL NEWS AUTO-GENERATOR'), findsOneWidget);
    final autoFillBtn = find.text('Auto-Fill Full Article with AI');
    expect(autoFillBtn, findsOneWidget);

    // Tap Auto-Fill
    await tester.ensureVisible(autoFillBtn);
    await tester.tap(autoFillBtn);
    await tester.pumpAndSettle();

    // Verify Title is auto-filled with MiniMax vs HeyGen viral article
    expect(
      find.text('MiniMax Video-01 vs HeyGen: How Free Open AI Video Engines Outpace Commercial Subscriptions'),
      findsOneWidget,
    );

    // Tap Publish
    final publishBtn = find.text('Publish Immediately to Live Feed');
    await tester.ensureVisible(publishBtn);
    await tester.tap(publishBtn);
    await tester.pumpAndSettle();

    // Verify snackbar confirmation
    expect(
      find.textContaining('successfully published to live News feed!'),
      findsOneWidget,
    );
  });

  testWidgets('Admin Dashboard displays Analytics & Ad Revenue reports, ad slots, and simulations',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Directly authenticate to admin section
    final context = tester.element(find.byType(HomePage));
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    provider.setSection(PortfolioSection.admin);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter username (e.g. admin)'),
      'admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter administrative password'),
      'special4u@A',
    );
    await tester.tap(find.text('Authenticate & Open Dashboard'));
    await tester.pumpAndSettle();

    // Verify Executive Overview KPI tiles
    expect(find.text('TOTAL PLATFORM TRAFFIC'), findsOneWidget);
    expect(find.text('ESTIMATED AD REVENUE'), findsOneWidget);

    // Switch to Analytics & Revenue tab
    final analyticsTab = find.text('Analytics & Revenue');
    expect(analyticsTab, findsOneWidget);
    await tester.tap(analyticsTab);
    await tester.pumpAndSettle();

    // Verify Analytics Section elements
    expect(find.text('TRAFFIC & MONETIZATION INTELLIGENCE'), findsOneWidget);
    expect(find.text('DAILY TRAFFIC & EARNINGS VELOCITY'), findsOneWidget);
    expect(find.text('AD PLACEMENT INVENTORY & UNIT PERFORMANCE'), findsOneWidget);
    expect(find.text('Mid-Article In-Stream Banner'), findsOneWidget);
    expect(find.text('Desktop Sticky Sidebar Unit'), findsOneWidget);
    expect(find.text('Google Auto-Ads Feed Slot'), findsOneWidget);
    expect(find.text('CONTENT AUDIT & ARTICLE TRAFFIC LEADERBOARD'), findsOneWidget);

    // Test Simulate Traffic Pulse
    final pulseBtn = find.text('Simulate Traffic Pulse');
    expect(pulseBtn, findsOneWidget);
    await tester.tap(pulseBtn);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Simulated real-time organic reader burst'),
      findsOneWidget,
    );

    // Test Export Audit Report dialog
    final exportBtn = find.text('Export Audit Report');
    expect(exportBtn, findsOneWidget);
    await tester.tap(exportBtn);
    await tester.pumpAndSettle();

    expect(find.text('Export Analytics & Revenue Report'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
  });
}


import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/url_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../portfolio/presentation/portfolio_provider.dart';

/// Interactive Contact Screen featuring form validation, animated feedback,
/// and direct links to LinkedIn and professional domain (bhattaraibvk.com.np).
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSubmittedSuccess = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final success = await SupabaseService.submitContactMessage(
      name: _nameController.text,
      email: _emailController.text,
      message: _messageController.text,
    );

    if (!mounted) return;

    if (success) {
      try {
        context.read<PortfolioProvider>().recordInquiry(
              name: _nameController.text,
              email: _emailController.text,
              message: _messageController.text,
            );
      } catch (_) {}

      setState(() {
        _isSubmitting = false;
        _isSubmittedSuccess = true;
      });
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } else {
      setState(() {
        _isSubmitting = false;
        _errorMessage =
            'Unable to submit inquiry at this moment. Please reach out via direct email or LinkedIn.';
      });
    }
  }

  void _resetForm() {
    setState(() {
      _isSubmittedSuccess = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 960;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? 20 : 32,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _ContactHeader(isDesktop: isDesktop),

              const SizedBox(height: 40),

              // Two-column layout on Desktop, stacked on Mobile
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Form or Success State
                    Expanded(
                      flex: 7,
                      child: _buildFormCard(context),
                    ),
                    const SizedBox(width: 36),
                    // Right: Direct Channels
                    Expanded(
                      flex: 5,
                      child: const _DirectChannelsCard(),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildFormCard(context),
                    const SizedBox(height: 32),
                    const _DirectChannelsCard(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    if (_isSubmittedSuccess) {
      return _SubmissionSuccessCard(onReset: _resetForm);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send a Direct Message',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in your details and project overview. Inquiries are routed directly to my secure inbox.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Full Name
              Text(
                'Your Name',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Dr. Jane Smith / Alex Rivera',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      size: 20, color: AppTheme.textSecondary),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your name.';
                  }
                  if (val.trim().length < 2) {
                    return 'Name must be at least 2 characters long.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Email Address
              Text(
                'Email Address',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'you@organization.com',
                  prefixIcon: Icon(Icons.alternate_email_rounded,
                      size: 20, color: AppTheme.textSecondary),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email address.';
                  }
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Message
              Text(
                'Message / Project Brief',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      'Provide an outline of your healthcare IT project, architecture review, or strategic initiative...',
                  alignLabelWithHint: true,
                ),
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please write your message or inquiry brief.';
                  }
                  if (val.trim().length < 10) {
                    return 'Message must be at least 10 characters long.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              // Submit Action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.background,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 16),
                  label: Text(_isSubmitting
                      ? 'Transmitting Securely...'
                      : 'Send Inquiry Message'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactHeader extends StatelessWidget {
  final bool isDesktop;

  const _ContactHeader({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
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
              ),
              const SizedBox(width: 8),
              Text(
                'DIRECT INQUIRY & ADVISORY',
                style: AppTheme.codeStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryAccent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Start a Strategic Conversation',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 36 : 28,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.8,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            'Whether exploring healthcare informatics consulting, distributed systems architecture reviews, or executive technology leadership, I welcome the discussion.',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated submission success feedback card
class _SubmissionSuccessCard extends StatelessWidget {
  final VoidCallback onReset;

  const _SubmissionSuccessCard({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryAccent, width: 1.5),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppTheme.primaryAccent,
                size: 32,
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              'Message Transmitted Successfully',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Thank you for reaching out. Your inquiry has been routed to Bibek Bhattarai. You can expect a response within 24–48 hours.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Send Another Message'),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

/// Direct channels card containing website (bhattaraibvk.com.np), LinkedIn, GitHub, and email
class _DirectChannelsCard extends StatelessWidget {
  const _DirectChannelsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Contact Profile
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
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
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.primaryAccent,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bibek Bhattarai',
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
                            size: 15,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Direct Consultations & Advisory',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            Text(
              'Direct Channels & Presence',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect directly across professional platforms and verified web properties.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Professional Website Link (bhattaraibvk.com.np)
            _ChannelItem(
              title: 'Professional Website',
              subtitle: AppConstants.websiteLabel,
              icon: Icons.language_rounded,
              onTap: () => UrlService.launch(AppConstants.websiteUrl),
            ),
            const SizedBox(height: 14),

            // LinkedIn Profile Link
            _ChannelItem(
              title: 'LinkedIn Profile',
              subtitle: 'linkedin.com/in/bhattaraibvk',
              icon: Icons.link_rounded,
              onTap: () => UrlService.launch(AppConstants.linkedinUrl),
            ),
            const SizedBox(height: 14),

            // GitHub Repository
            _ChannelItem(
              title: 'GitHub Projects',
              subtitle: 'github.com/bhattaraibvk',
              icon: Icons.code_rounded,
              onTap: () => UrlService.launch(AppConstants.githubUrl),
            ),
            const SizedBox(height: 14),

            // Direct Email
            _ChannelItem(
              title: 'Direct Email',
              subtitle: AppConstants.email,
              icon: Icons.mail_outline_rounded,
              onTap: () => UrlService.launch('mailto:${AppConstants.email}'),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Typical Response Window Note
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppTheme.primaryAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Standard executive response window: 24–48 hours.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ChannelItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends State<_ChannelItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.surfaceElevated : AppTheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered ? AppTheme.primaryAccent : AppTheme.border,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: _isHovered
                    ? AppTheme.primaryAccent
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _isHovered
                            ? AppTheme.primaryAccent
                            : AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: _isHovered
                    ? AppTheme.primaryAccent
                    : AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

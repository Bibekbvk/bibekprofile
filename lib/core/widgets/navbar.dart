import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../features/admin/presentation/admin_login_dialog.dart';
import '../../features/portfolio/presentation/portfolio_provider.dart';
import '../theme/app_theme.dart';

/// Sticky minimalist navigation bar for the Flutter Web portfolio & journal app.
class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand / Logo with Portrait Avatar
              InkWell(
                onTap: () => provider.setSection(PortfolioSection.home),
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
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
                                  fontSize: 12,
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
                    Text(
                      'Bibek Bhattarai',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Desktop Navigation Links
              if (isDesktop)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...PortfolioSection.values
                            .where((section) => section != PortfolioSection.admin)
                            .map((section) {
                          final isActive = provider.currentSection == section;
                          return _NavLinkItem(
                            section: section,
                            isActive: isActive,
                            onTap: () => provider.setSection(section),
                          );
                        }),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            provider.isAdminAuthenticated
                                ? Icons.admin_panel_settings_rounded
                                : Icons.lock_outline_rounded,
                            size: 19,
                            color: provider.isAdminAuthenticated
                                ? AppTheme.primaryAccent
                                : AppTheme.textSecondary,
                          ),
                          tooltip: provider.isAdminAuthenticated
                              ? 'Admin Console (Logged In)'
                              : 'Admin Portal Access',
                          onPressed: () {
                            if (provider.isAdminAuthenticated) {
                              provider.setSection(PortfolioSection.admin);
                            } else {
                              AdminLoginDialog.show(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Mobile Menu Toggle
                IconButton(
                  icon: Icon(
                    provider.isMobileDrawerOpen
                        ? Icons.close_rounded
                        : Icons.menu_rounded,
                    color: AppTheme.textPrimary,
                    size: 24,
                  ),
                  onPressed: () => provider.toggleMobileDrawer(),
                  tooltip: 'Toggle Navigation Menu',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLinkItem extends StatefulWidget {
  final PortfolioSection section;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLinkItem({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLinkItem> createState() => _NavLinkItemState();
}

class _NavLinkItemState extends State<_NavLinkItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isActive
        ? AppTheme.textPrimary
        : (_isHovered ? AppTheme.textPrimary : AppTheme.textSecondary);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.section.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              // Active route indicator: Muted Bronze (#C5A059) bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 22 : (_isHovered ? 12 : 0),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppTheme.primaryAccent
                      : AppTheme.border,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mobile dropdown navigation panel shown when mobile menu is toggled.
class MobileNavMenu extends StatelessWidget {
  const MobileNavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    if (!provider.isMobileDrawerOpen) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...PortfolioSection.values
              .where((section) => section != PortfolioSection.admin)
              .map((section) {
            final isActive = provider.currentSection == section;
            return InkWell(
              onTap: () => provider.setSection(section),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryAccent.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive ? AppTheme.primaryAccent : Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      section.label,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? AppTheme.primaryAccent : AppTheme.textPrimary,
                      ),
                    ),
                    if (isActive)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          const Divider(color: AppTheme.border, thickness: 1.0),
          const SizedBox(height: 6),
          InkWell(
            onTap: () {
              provider.toggleMobileDrawer(false);
              if (provider.isAdminAuthenticated) {
                provider.setSection(PortfolioSection.admin);
              } else {
                AdminLoginDialog.show(context);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: provider.currentSection == PortfolioSection.admin
                    ? AppTheme.primaryAccent.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.currentSection == PortfolioSection.admin
                      ? AppTheme.primaryAccent
                      : AppTheme.border,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        provider.isAdminAuthenticated
                            ? Icons.admin_panel_settings_rounded
                            : Icons.lock_outline_rounded,
                        size: 18,
                        color: provider.isAdminAuthenticated
                            ? AppTheme.primaryAccent
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        provider.isAdminAuthenticated
                            ? 'Admin Console (Active)'
                            : 'Admin Portal Access',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: provider.isAdminAuthenticated
                              ? AppTheme.primaryAccent
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/journey_data.dart';
import '../../domain/models/timeline_milestone.dart';

/// Interactive, visually striking Professional & Educational Journey Timeline.
/// Features a solid Muted Bronze (#C5A059) vertical spine with minimalist node dots.
class JourneyTimeline extends StatelessWidget {
  const JourneyTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 960;
    final milestones = JourneyData.milestones;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? 16 : 32,
            vertical: 36,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _TimelineHeader(isDesktop: isDesktop),

              const SizedBox(height: 48),

              // Timeline Canvas
              if (isDesktop)
                _DesktopCenterSpineTimeline(milestones: milestones)
              else
                _MobileLeftSpineTimeline(milestones: milestones),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header with overview description and multidisciplinary badges
class _TimelineHeader extends StatelessWidget {
  final bool isDesktop;

  const _TimelineHeader({required this.isDesktop});

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
                'CHRONOLOGICAL TRAJECTORY',
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
          'Professional & Educational Journey',
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
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            'From frontline clinical medicine to enterprise distributed software architecture and executive business leadership. A purposeful evolution dedicated to solving critical system challenges.',
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

/// Desktop Timeline with central bronze spine and alternating editorial milestone cards
class _DesktopCenterSpineTimeline extends StatelessWidget {
  final List<TimelineMilestone> milestones;

  const _DesktopCenterSpineTimeline({required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Solid Muted Bronze Central Spine
        Positioned(
          top: 24,
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 2,
              color: AppTheme.primaryAccent.withValues(alpha: 0.7),
            ),
          ),
        ),

        // List of Milestone Entries
        Column(
          children: List.generate(milestones.length, (index) {
            final milestone = milestones[index];
            final isEven = index.isEven;

            return Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Slot
                  Expanded(
                    child: isEven
                        ? _MilestoneCard(milestone: milestone, isRightAligned: true)
                        : const SizedBox.shrink(),
                  ),

                  // Center Node Dot & Year
                  _CenterNodeDot(
                    year: milestone.year,
                    isCurrent: milestone.isCurrent,
                  ),

                  // Right Slot
                  Expanded(
                    child: !isEven
                        ? _MilestoneCard(milestone: milestone, isRightAligned: false)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (index * 80).ms, duration: 500.ms)
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
          }),
        ),
      ],
    );
  }
}

/// Center Node Dot with Year badge for Desktop
class _CenterNodeDot extends StatelessWidget {
  final String year;
  final bool isCurrent;

  const _CenterNodeDot({
    required this.year,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          // Node dot
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.background,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryAccent,
                width: isCurrent ? 3.0 : 2.0,
              ),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Year Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isCurrent ? AppTheme.primaryAccent : AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCurrent ? AppTheme.primaryAccent : AppTheme.border,
                width: 1.0,
              ),
            ),
            child: Text(
              year,
              style: AppTheme.codeStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isCurrent ? AppTheme.background : AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile/Tablet Timeline with left-aligned bronze spine and stacked cards
class _MobileLeftSpineTimeline extends StatelessWidget {
  final List<TimelineMilestone> milestones;

  const _MobileLeftSpineTimeline({required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left Solid Bronze Spine
        Positioned(
          top: 16,
          bottom: 16,
          left: 12,
          child: Container(
            width: 2,
            color: AppTheme.primaryAccent.withValues(alpha: 0.7),
          ),
        ),

        // Milestones
        Column(
          children: List.generate(milestones.length, (index) {
            final milestone = milestones[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Node
                  Container(
                    width: 26,
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryAccent,
                          width: milestone.isCurrent ? 3.0 : 2.0,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content Card
                  Expanded(
                    child: _MilestoneCard(
                      milestone: milestone,
                      isRightAligned: false,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (index * 70).ms, duration: 450.ms)
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
          }),
        ),
      ],
    );
  }
}

/// Editorial milestone card with hover animations and solid dark styling
class _MilestoneCard extends StatefulWidget {
  final TimelineMilestone milestone;
  final bool isRightAligned;

  const _MilestoneCard({
    required this.milestone,
    required this.isRightAligned,
  });

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.milestone;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.012 : 1.0,
          _isHovered ? 1.012 : 1.0,
          1.0,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? AppTheme.primaryAccent : AppTheme.border,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category Tag & Current Status
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.border, width: 1.0),
                  ),
                  child: Text(
                    m.typeLabel,
                    style: AppTheme.codeStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ),
                if (m.isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.primaryAccent, width: 1.0),
                    ),
                    child: Text(
                      'ACTIVE ROLE',
                      style: AppTheme.codeStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Role or Degree
            Text(
              m.roleOrDegree,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 4),

            // Organization & Location
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${m.organization} • ${m.location}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              m.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),

            // Highlights
            if (m.highlights.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...m.highlights.map((item) {
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
                          color: AppTheme.primaryAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 12,
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
          ],
        ),
      ),
    );
  }
}

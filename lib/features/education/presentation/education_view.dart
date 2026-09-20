import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../data/education_data.dart';
import '../domain/models/degree_item.dart';

/// Pure Education & Degrees screen.
/// Dedicated strictly to degrees, courses completed, and courses currently taking.
/// Work experience is completely excluded from this section.
class EducationView extends StatefulWidget {
  const EducationView({super.key});

  @override
  State<EducationView> createState() => _EducationViewState();
}

class _EducationViewState extends State<EducationView> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final degrees = _filterDegrees();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // University Campus Spotlight Banner
        _UniversityCampusHero(screenWidth: screenWidth),

        const SizedBox(height: 36),

        // Filter Chips Row
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildFilterChip('All', 'All Credentials'),
            _buildFilterChip('Completed', 'Completed Degrees'),
            _buildFilterChip('Ongoing', 'Currently Taking / Ongoing'),
          ],
        ),

        const SizedBox(height: 28),

        // Degree & Coursework Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: degrees.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final degree = degrees[index];
            return _DegreeCard(degree: degree, index: index);
          },
        ),
      ],
    );
  }

  List<DegreeItem> _filterDegrees() {
    switch (_selectedFilter) {
      case 'Completed':
        return EducationData.allDegrees
            .where((d) => d.status == DegreeStatus.completed)
            .toList();
      case 'Ongoing':
        return EducationData.allDegrees
            .where((d) => d.status == DegreeStatus.currentlyTaking)
            .toList();
      default:
        return EducationData.allDegrees;
    }
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = key),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryAccent : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryAccent : AppTheme.border,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppTheme.background : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Editorial Hero Banner highlighting Tribhuvan University clocktower campus and academic insignia
class _UniversityCampusHero extends StatelessWidget {
  final double screenWidth;

  const _UniversityCampusHero({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isDesktop = screenWidth >= 840;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campus Panoramic Photo Frame
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: isDesktop ? 260 : 180,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/tribhuvan_university.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.surfaceElevated,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.account_balance_rounded,
                          size: 48,
                          color: AppTheme.primaryAccent,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Institutional Attribution Overlay
              Positioned(
                bottom: 12,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.background.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.border, width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 13,
                        color: AppTheme.primaryAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tribhuvan University Clocktower Campus, Kirtipur',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Overview Details Row
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TU Official Logo Emblem
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border, width: 1.0),
                  ),
                  child: Image.asset(
                    'assets/images/tribhuvan_university_logo.jpg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.school_rounded,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Degrees & University Coursework',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: screenWidth < 600 ? 18 : 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Detailed academic portfolio spanning Health Education, Computing, Clinical Sciences, and ongoing Graduate Management studies. Strictly academic research and qualifications.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Detailed Academic Degree Card
class _DegreeCard extends StatelessWidget {
  final DegreeItem degree;
  final int index;

  const _DegreeCard({required this.degree, required this.index});

  @override
  Widget build(BuildContext context) {
    final isOngoing = degree.status == DegreeStatus.currentlyTaking;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Status pill & duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOngoing
                        ? AppTheme.primaryAccent.withValues(alpha: 0.15)
                        : AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isOngoing ? AppTheme.primaryAccent : AppTheme.border,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isOngoing) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        degree.statusLabel.toUpperCase(),
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isOngoing
                              ? AppTheme.primaryAccent
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  degree.duration,
                  style: AppTheme.codeStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Degree Title & Institution
            Text(
              degree.degreeTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              degree.campus != null
                  ? '${degree.institution} • ${degree.campus}'
                  : degree.institution,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryAccent,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              degree.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 16),

            // Focus / Thesis Callout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.border, width: 1.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome_outlined,
                    size: 15,
                    color: AppTheme.primaryAccent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Research Focus: ${degree.thesisOrFocus}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Key Coursework Pills
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: degree.keyCoursework.map((course) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.border, width: 1.0),
                  ),
                  child: Text(
                    course,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index), duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

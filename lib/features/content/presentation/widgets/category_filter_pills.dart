import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../portfolio/presentation/portfolio_provider.dart';
import '../../data/mock_content_repository.dart';

/// Category filter pills bar for filtering journals, writings, and study notes.
class CategoryFilterPills extends StatelessWidget {
  const CategoryFilterPills({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: MockContentRepository.categories.map((category) {
        final isSelected = provider.selectedCategory == category;
        return _CategoryPillItem(
          label: category,
          isSelected: isSelected,
          onTap: () => provider.setCategory(category),
        );
      }).toList(),
    );
  }
}

class _CategoryPillItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPillItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryPillItem> createState() => _CategoryPillItemState();
}

class _CategoryPillItemState extends State<_CategoryPillItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (widget.isSelected) {
      backgroundColor = AppTheme.primaryAccent;
      textColor = AppTheme.background;
      borderColor = AppTheme.primaryAccent;
    } else {
      backgroundColor = _isHovered ? AppTheme.surfaceElevated : AppTheme.surface;
      textColor = _isHovered ? AppTheme.textPrimary : AppTheme.textSecondary;
      borderColor = _isHovered ? AppTheme.primaryAccent : AppTheme.border;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../portfolio/presentation/portfolio_provider.dart';
import '../data/marketplace_data.dart';
import '../domain/models/marketplace_item.dart';

class MarketplaceView extends StatefulWidget {
  const MarketplaceView({super.key});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  MarketplaceCategory _selectedCategory = MarketplaceCategory.all;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final isNepali = provider.isNepali;
    final screenWidth = MediaQuery.of(context).size.width;

    final filteredItems = MarketplaceData.items.where((item) {
      if (_selectedCategory == MarketplaceCategory.all) return true;
      return item.category == _selectedCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: MarketplaceCategory.values.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: FilterChip(
                  label: Text(
                    cat.getLocalizedLabel(isNepali),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppTheme.background : AppTheme.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryAccent,
                  backgroundColor: AppTheme.surface,
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryAccent : AppTheme.border,
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedCategory = cat);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Product Catalog Grid
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 1;
            if (constraints.maxWidth >= 1000) {
              crossAxisCount = 3;
            } else if (constraints.maxWidth >= 650) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 580,
              ),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _MarketplaceCard(
                  item: item,
                  isNepali: isNepali,
                  onInquire: () => _showInquiryDialog(context, item, isNepali),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showInquiryDialog(
      BuildContext context, MarketplaceItem item, bool isNepali) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border, width: 1.0),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, color: AppTheme.primaryAccent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isNepali ? 'अर्डर तथा सोधपुछ' : 'Commission & Inquiry',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.displayTitle(isNepali),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.displayDescription(isNepali),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isNepali ? 'मूल्य' : 'Pricing',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '\$${item.priceUsd} / रु ${item.priceNpr}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isNepali ? 'डेलिभरी' : 'Timeline',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            item.displayDelivery(isNepali),
                            textAlign: TextAlign.end,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isNepali
                    ? 'सिधै इमेल पठाएर वा तलको फारमबाट परामर्श सुरु गर्न सक्नुहुन्छ:'
                    : 'Reach out directly via email or the portfolio inquiry form to get started:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              isNepali ? 'बन्द गर्नुहोस्' : 'Cancel',
              style: GoogleFonts.inter(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              final subject = Uri.encodeComponent('Inquiry: ${item.title}');
              final body = Uri.encodeComponent(
                  'Hello Bibek,\n\nI am interested in acquiring/commissioning "${item.title}".\n\nPlease let me know the next steps.');
              UrlService.launch(
                  'mailto:${AppConstants.email}?subject=$subject&body=$body');
            },
            icon: const Icon(Icons.email_outlined, size: 16),
            label: Text(
              isNepali ? 'इमेल पठाउनुहोस्' : 'Send Direct Email',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAccent,
              foregroundColor: AppTheme.background,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceCard extends StatelessWidget {
  final MarketplaceItem item;
  final bool isNepali;
  final VoidCallback onInquire;

  const _MarketplaceCard({
    required this.item,
    required this.isNepali,
    required this.onInquire,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Category Badge + Highlight Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primaryAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primaryAccent.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: AppTheme.primaryAccent,
                  size: 22,
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    item.displayBadge(isNepali),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryAccent,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            item.displayTitle(isNepali),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Short Description
          Text(
            item.displayDescription(isNepali),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 14),

          // Tech Stack Chip Row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: item.techStack.take(3).map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
                ),
                child: Text(
                  tech,
                  style: AppTheme.codeStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 12),

          // Features List
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.displayFeatures(isNepali).take(4).length,
              itemBuilder: (context, idx) {
                final feat = item.displayFeatures(isNepali)[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppTheme.primaryAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feat,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 12),

          // Pricing & Delivery Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${item.priceUsd} (${isNepali ? 'रु' : 'NPR'} ${item.priceNpr.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryAccent,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.displayDelivery(isNepali),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onInquire,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAccent,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isNepali ? 'अर्डर / सोधपुछ' : 'Inquire',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

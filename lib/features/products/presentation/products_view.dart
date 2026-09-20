import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/url_service.dart';
import '../../../core/theme/app_theme.dart';
import '../data/products_data.dart';
import '../domain/models/product_item.dart';

/// Products, Software, and Applications showcase screen with direct downloadable files.
class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'E-Commerce & Delivery',
    'Health IT & Diagnostics',
    'System Utilities',
    'FinTech & Trading',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final products = _filterProducts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Card
        _ProductsHeaderBanner(screenWidth: screenWidth),

        const SizedBox(height: 32),

        // Filter Pills
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
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
                  cat,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppTheme.background : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Product Cards Grid
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 28),
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductCard(
              product: product,
              index: index,
              onDownload: (url, label) => _triggerDownload(context, url, label),
            );
          },
        ),
      ],
    );
  }

  List<ProductItem> _filterProducts() {
    if (_selectedCategory == 'All') return ProductsData.allProducts;
    return ProductsData.allProducts
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  void _triggerDownload(BuildContext context, String? url, String label) {
    if (url == null || url.isEmpty) return;

    // Trigger URL launch in browser for download
    UrlService.launch(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppTheme.border),
        ),
        content: Row(
          children: [
            const Icon(Icons.download_done_rounded, color: AppTheme.primaryAccent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Initiating download for $label...',
                style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsHeaderBanner extends StatelessWidget {
  final double screenWidth;

  const _ProductsHeaderBanner({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GOOGLE PLAY CONSOLE • VERIFIED APPLICATIONS',
                    style: AppTheme.codeStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.shop_two_outlined,
                  color: AppTheme.primaryAccent,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Google Play Applications, Production Builds & Downloadable Binaries',
              style: GoogleFonts.plusJakartaSans(
                fontSize: screenWidth < 600 ? 20 : 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Showcasing official applications deployed and tested on Google Play Console across mobile commerce, clinical diagnostics, system utilities, and financial analytics. Direct download packages and technical specifications are available below.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItem product;
  final int index;
  final Function(String?, String) onDownload;

  const _ProductCard({
    required this.product,
    required this.index,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 880;

    final imageWidget = Container(
      width: isDesktop ? 340 : double.infinity,
      height: isDesktop ? 250 : 190,
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            product.previewImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppTheme.surface,
              alignment: Alignment.center,
              child: const Icon(
                Icons.devices_other_rounded,
                size: 48,
                color: AppTheme.primaryAccent,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.background.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.category.toUpperCase(),
                style: AppTheme.codeStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final detailsWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Title Row with App Icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (product.iconImage != null) ...[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppTheme.border, width: 1.0),
                  color: AppTheme.surfaceElevated,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  product.iconImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.android_rounded,
                    color: AppTheme.primaryAccent,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      if (product.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.primaryAccent, width: 0.8),
                          ),
                          child: Text(
                            'FEATURED',
                            style: AppTheme.codeStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryAccent,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (product.packageName != null)
                    Text(
                      product.packageName!,
                      style: AppTheme.codeStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Play Store Status Bar
        if (product.playStoreStatus != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: product.playStoreStatus!.contains('Production')
                  ? AppTheme.primaryAccent.withValues(alpha: 0.12)
                  : AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: product.playStoreStatus!.contains('Production')
                    ? AppTheme.primaryAccent
                    : AppTheme.border,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  product.playStoreStatus!.contains('Production')
                      ? Icons.check_circle_rounded
                      : Icons.science_outlined,
                  size: 13,
                  color: product.playStoreStatus!.contains('Production')
                      ? AppTheme.primaryAccent
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  product.playStoreStatus!,
                  style: AppTheme.codeStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: product.playStoreStatus!.contains('Production')
                        ? AppTheme.primaryAccent
                        : AppTheme.textSecondary,
                  ),
                ),
                if (product.lastUpdated != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '•  Updated ${product.lastUpdated}',
                    style: AppTheme.codeStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),

        const SizedBox(height: 8),
        Text(
          product.tagline,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryAccent,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Key Features
        ...product.features.map((feat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 15,
                  color: AppTheme.primaryAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feat,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        // Tech Pills
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: product.technologies.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.border, width: 0.8),
              ),
              child: Text(
                tech,
                style: AppTheme.codeStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        // Download & Action Buttons
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            // Live Play Store or Web Button
            if (product.liveUrl != null)
              product.liveUrl!.contains('play.google.com')
                  ? ElevatedButton.icon(
                      onPressed: () => UrlService.launch(product.liveUrl!),
                      icon: const Icon(Icons.shop_two_rounded, size: 17),
                      label: const Text('View on Google Play Store'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryAccent,
                        foregroundColor: AppTheme.background,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    )
                  : TextButton.icon(
                      onPressed: () => UrlService.launch(product.liveUrl!),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Live Property'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),

            // Primary Download Button
            if (product.downloadUrl != null)
              (product.liveUrl != null && product.liveUrl!.contains('play.google.com'))
                  ? OutlinedButton.icon(
                      onPressed: () => onDownload(
                        product.downloadUrl,
                        product.downloadLabel ?? 'Application Package',
                      ),
                      icon: const Icon(Icons.download_rounded, size: 17),
                      label: Text(product.downloadLabel ?? 'Download Binary'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => onDownload(
                        product.downloadUrl,
                        product.downloadLabel ?? 'Application Package',
                      ),
                      icon: const Icon(Icons.download_rounded, size: 17),
                      label: Text(product.downloadLabel ?? 'Download Binary'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),

            // Secondary Spec Download Button
            if (product.specDownloadUrl != null)
              OutlinedButton.icon(
                onPressed: () => onDownload(
                  product.specDownloadUrl,
                  product.specDownloadLabel ?? 'Specification Document',
                ),
                icon: const Icon(Icons.description_outlined, size: 17),
                label: Text(product.specDownloadLabel ?? 'Download Spec'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
          ],
        ),
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget,
                  const SizedBox(width: 28),
                  Expanded(child: detailsWidget),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget,
                  const SizedBox(height: 20),
                  detailsWidget,
                ],
              ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 60 * index), duration: 400.ms)
        .slideY(begin: 0.04, end: 0);
  }
}


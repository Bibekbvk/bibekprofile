/// Domain model for software products, mobile apps, web applications, and technical projects.
class ProductItem {
  final String id;
  final String title;
  final String tagline;
  final String category;
  final String description;
  final String previewImage;
  final String? iconImage;
  final String? packageName;
  final String? playStoreStatus;
  final String? lastUpdated;
  final String? installedAudience;
  final List<String> screenshots;
  final List<String> technologies;
  final List<String> features;
  final String? downloadUrl;
  final String? downloadLabel;
  final String? specDownloadUrl;
  final String? specDownloadLabel;
  final String? liveUrl;
  final bool isFeatured;

  const ProductItem({
    required this.id,
    required this.title,
    required this.tagline,
    required this.category,
    required this.description,
    required this.previewImage,
    this.iconImage,
    this.packageName,
    this.playStoreStatus,
    this.lastUpdated,
    this.installedAudience,
    required this.screenshots,
    required this.technologies,
    required this.features,
    this.downloadUrl,
    this.downloadLabel,
    this.specDownloadUrl,
    this.specDownloadLabel,
    this.liveUrl,
    this.isFeatured = false,
  });
}


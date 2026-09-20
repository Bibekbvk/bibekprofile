import '../domain/models/product_item.dart';

/// Pre-populated repository containing exclusively the verified Google Play Console applications:
/// 1. Machhamart (Production - Live on Google Play Store)
/// 2. Android Health (Closed testing - Health diagnostics & vitals telemetry)
/// 3. Search Everything (Closed testing - System indexing & file search)
/// 4. 3D MS Trader (Closed testing - Financial market analytics & indicators)
class ProductsData {
  static const List<ProductItem> allProducts = [
    // 1. Machhamart (Production / Live on Google Play Store)
    ProductItem(
      id: 'machhamart',
      title: 'Machhamart',
      tagline: 'Aquaculture Logistics, Fresh Seafood Marketplace & Direct Delivery Network',
      category: 'E-Commerce & Delivery',
      packageName: 'com.machhamart',
      playStoreStatus: 'Production (Live on Google Play)',
      lastUpdated: 'Jul 6, 2026',
      installedAudience: 'Production Active Installs',
      iconImage: 'assets/images/products/icon_machhamart.png',
      previewImage: 'assets/images/products/machhamart_banner.png',
      screenshots: [
        'assets/images/products/icon_machhamart.png',
      ],
      description:
          'Official production e-commerce mobile platform connecting fresh fisheries directly to commercial kitchens, restaurants, and retail consumers across Nepal. Features cold-chain dispatch routing, dynamic market pricing, and automated inventory reconciliation.',
      technologies: [
        'Flutter / Android',
        'Node.js / Express',
        'PostgreSQL Database',
        'Google Maps Routing API',
        'Digital Payment Gateways (eSewa / Khalti)',
      ],
      features: [
        'Production release published live on the Google Play Store',
        'Real-time cold-chain vehicle dispatch and live delivery tracking',
        'Multi-vendor fishery cataloging with dynamic catch-weight pricing',
        'Direct checkout with integrated digital payment gateways',
      ],
      downloadUrl: '/downloads/machhamart-release.apk',
      downloadLabel: 'Download Production APK',
      specDownloadUrl: '/downloads/machhamart_architecture_spec.txt',
      specDownloadLabel: 'Download Architecture Spec',
      liveUrl: 'https://play.google.com/store/apps/details?id=com.machhamart',
      isFeatured: true,
    ),

    // 2. Android Health (Closed Testing / Google Play Console)
    ProductItem(
      id: 'android-health',
      title: 'Android Health',
      tagline: 'Mobile Clinical Telemetry, Vitals Monitoring & Device Diagnostics',
      category: 'Health IT & Diagnostics',
      packageName: 'com.mobilehealth.droidpulse.mobile_health',
      playStoreStatus: 'Closed Testing (Google Play Console)',
      lastUpdated: 'Sep 5, 2026',
      installedAudience: 'Testing Cohort',
      iconImage: 'assets/images/products/icon_android_health.png',
      previewImage: 'assets/images/products/app_feature_graphic.png',
      screenshots: [
        'assets/images/products/app_screen_1.jpeg',
        'assets/images/products/app_screen_2.jpeg',
      ],
      description:
          'Comprehensive Android health platform integrating physiological vitals monitoring with on-device medical diagnostics. Engineered with the DroidPulse telemetry engine for continuous telemetry capture, quantitative biostatistical anomaly detection, and HL7 FHIR sync.',
      technologies: [
        'Android Kotlin',
        'DroidPulse Diagnostic Core',
        'HL7 FHIR Clinical APIs',
        'Bluetooth Low Energy (BLE)',
        'Room Local Database',
      ],
      features: [
        'High-frequency physiological telemetry streaming and vital logs',
        'Quantitative biostatistical anomaly detection and risk scoring',
        'HL7 FHIR compliant clinical health record interoperability',
        'Offline clinical edge caching with cryptographic data storage',
      ],
      downloadUrl: '/downloads/android-health-release.apk',
      downloadLabel: 'Download Telemetry APK',
      specDownloadUrl: '/downloads/android_health_clinical_spec.txt',
      specDownloadLabel: 'Download Clinical Spec',
      liveUrl: 'https://bhattaraibvk.com.np',
      isFeatured: true,
    ),

    // 3. Search Everything (Closed Testing / Google Play Console)
    ProductItem(
      id: 'search-everything',
      title: 'Search Everything',
      tagline: 'Instant On-Device Multi-Storage Search Engine & File Indexer',
      category: 'System Utilities',
      packageName: 'com.devicefinder.app.device_finder',
      playStoreStatus: 'Closed Testing (Google Play Console)',
      lastUpdated: 'Sep 5, 2026',
      installedAudience: 'Testing Cohort',
      iconImage: 'assets/images/products/icon_search_everything.png',
      previewImage: 'assets/images/products/search_everything_banner.png',
      screenshots: [
        'assets/images/products/icon_search_everything.png',
      ],
      description:
          'High-speed Android system indexing utility engineered for instantaneous multi-storage search across internal flash, SD cards, application assets, document caches, and media archives. Delivers sub-50ms query response with boolean pattern matching.',
      technologies: [
        'Android Kotlin / C++ NDK',
        'SQLite FTS5 Full-Text Engine',
        'Android Storage Access Framework (SAF)',
        'Kotlin Coroutines & Flow',
      ],
      features: [
        'In-memory B-Tree storage index delivering sub-50ms search latency',
        'Global search across internal storage, external cards, and cache files',
        'Deep metadata parsing for EXIF camera data, ID3 tags, and PDF text',
        'Battery-optimized low-overhead background file system observer',
      ],
      downloadUrl: '/downloads/search-everything-release.apk',
      downloadLabel: 'Download Utility APK',
      specDownloadUrl: '/downloads/search_everything_spec.txt',
      specDownloadLabel: 'Download Indexing Spec',
      liveUrl: 'https://bhattaraibvk.com.np',
      isFeatured: false,
    ),

    // 4. 3D MS Trader (Closed Testing / Google Play Console)
    ProductItem(
      id: '3d-ms-trader',
      title: '3D MS Trader',
      tagline: 'Algorithmic Multi-Asset Market Analytics & Technical Indicator Dashboard',
      category: 'FinTech & Trading',
      packageName: 'com.mstrader.com',
      playStoreStatus: 'Closed Testing (Google Play Console)',
      lastUpdated: 'Feb 22, 2022',
      installedAudience: 'Testing Cohort',
      iconImage: 'assets/images/products/icon_3d_ms_trader.png',
      previewImage: 'assets/images/products/3d_ms_trader_banner.png',
      screenshots: [
        'assets/images/products/icon_3d_ms_trader.png',
      ],
      description:
          'Specialized Android financial application designed for quantitative traders. Offers real-time market data visualization, depth-of-market indicators, algorithmic signals, and low-latency trade calculation tools.',
      technologies: [
        'Android Java / Kotlin',
        'Financial Market Charting Engine',
        'REST & WebSocket Streaming Feed',
        'SQLite Local Cache',
      ],
      features: [
        'Real-time technical indicators, depth-of-market, and chart overlays',
        'Quantitative risk calculator and mathematical position sizing tool',
        'Multi-asset portfolio tracking and comprehensive PnL analytics',
        'Low-latency edge caching engine for instantaneous market retrieval',
      ],
      downloadUrl: '/downloads/3d-ms-trader-release.apk',
      downloadLabel: 'Download Trader APK',
      specDownloadUrl: '/downloads/3d_ms_trader_spec.txt',
      specDownloadLabel: 'Download Analytics Spec',
      liveUrl: 'https://bhattaraibvk.com.np',
      isFeatured: false,
    ),
  ];
}

enum AnalyticsTimeFilter {
  today('Today', 'Past 24 Hours'),
  weekly('Weekly', 'Past 7 Days'),
  monthly('Monthly', 'Past 30 Days'),
  allTime('All-Time', 'Total Cumulative');

  final String label;
  final String description;
  const AnalyticsTimeFilter(this.label, this.description);
}

class AdUnitStat {
  final String id;
  final String name;
  final String placement;
  final String format;
  final int impressions;
  final int clicks;
  final double eCpm;
  final String status;

  const AdUnitStat({
    required this.id,
    required this.name,
    required this.placement,
    required this.format,
    required this.impressions,
    required this.clicks,
    required this.eCpm,
    this.status = 'Active & Monetized',
  });

  double get ctr => impressions > 0 ? (clicks / impressions) * 100 : 0.0;
  double get revenue => (impressions / 1000.0 * eCpm) + (clicks * 0.12);

  AdUnitStat copyWith({
    int? impressions,
    int? clicks,
    double? eCpm,
    String? status,
  }) {
    return AdUnitStat(
      id: id,
      name: name,
      placement: placement,
      format: format,
      impressions: impressions ?? this.impressions,
      clicks: clicks ?? this.clicks,
      eCpm: eCpm ?? this.eCpm,
      status: status ?? this.status,
    );
  }
}

class ArticleTrafficStat {
  final String id;
  final String title;
  final String category;
  final int views;
  final int adImpressions;
  final double revenue;
  final String trendBadge;

  const ArticleTrafficStat({
    required this.id,
    required this.title,
    required this.category,
    required this.views,
    required this.adImpressions,
    required this.revenue,
    required this.trendBadge,
  });

  ArticleTrafficStat copyWith({
    int? views,
    int? adImpressions,
    double? revenue,
    String? trendBadge,
  }) {
    return ArticleTrafficStat(
      id: id,
      title: title,
      category: category,
      views: views ?? this.views,
      adImpressions: adImpressions ?? this.adImpressions,
      revenue: revenue ?? this.revenue,
      trendBadge: trendBadge ?? this.trendBadge,
    );
  }
}

class DailyTrendStat {
  final String day;
  final int views;
  final double revenue;

  const DailyTrendStat({
    required this.day,
    required this.views,
    required this.revenue,
  });
}

class AnalyticsReport {
  final AnalyticsTimeFilter filter;
  final int totalVisits;
  final int totalArticleViews;
  final int totalAdImpressions;
  final int totalAdClicks;
  final double totalRevenueUsd;
  final double totalRevenueNpr;
  final double overallCtr;
  final double averageEcpm;
  final List<DailyTrendStat> dailyTrends;
  final List<AdUnitStat> adUnits;
  final List<ArticleTrafficStat> articleStats;

  const AnalyticsReport({
    required this.filter,
    required this.totalVisits,
    required this.totalArticleViews,
    required this.totalAdImpressions,
    required this.totalAdClicks,
    required this.totalRevenueUsd,
    required this.totalRevenueNpr,
    required this.overallCtr,
    required this.averageEcpm,
    required this.dailyTrends,
    required this.adUnits,
    required this.articleStats,
  });
}

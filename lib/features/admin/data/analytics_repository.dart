import 'dart:convert';
import 'dart:math';
import '../domain/models/analytics_model.dart';
import '../../content/data/mock_content_repository.dart';

class AnalyticsRepository {
  // Telemetry counters
  int _extraVisits = 0;
  int _extraArticleViews = 0;
  final Map<String, int> _articleExtraViews = {};
  final Map<String, int> _adUnitExtraImpressions = {
    'in_article_mid_banner': 0,
    'desktop_sidebar_rectangle': 0,
    'google_auto_ads_feed': 0,
  };
  final Map<String, int> _adUnitExtraClicks = {
    'in_article_mid_banner': 0,
    'desktop_sidebar_rectangle': 0,
    'google_auto_ads_feed': 0,
  };

  void recordArticleView(String articleId, String title, String category) {
    _extraVisits += 1;
    _extraArticleViews += 1;
    _articleExtraViews[articleId] = (_articleExtraViews[articleId] ?? 0) + 1;
    recordAdImpression('in_article_mid_banner', articleId);
    recordAdImpression('desktop_sidebar_rectangle', articleId);
  }

  void recordAdImpression(String adUnitId, [String? articleId]) {
    _adUnitExtraImpressions[adUnitId] = (_adUnitExtraImpressions[adUnitId] ?? 0) + 1;
  }

  void recordAdClick(String adUnitId) {
    _adUnitExtraClicks[adUnitId] = (_adUnitExtraClicks[adUnitId] ?? 0) + 1;
  }

  void simulateTrafficPulse() {
    final rand = Random();
    final addedViews = 45 + rand.nextInt(40); // 45 to 84 views
    final addedMidAds = addedViews;
    final addedSideAds = (addedViews * 0.75).round();
    final addedFeedAds = (addedViews * 0.35).round();
    final addedClicks = 1 + rand.nextInt(3);

    _extraVisits += addedViews + 15;
    _extraArticleViews += addedViews;

    // Distribute among top articles
    final posts = MockContentRepository.allPosts;
    if (posts.isNotEmpty) {
      for (int i = 0; i < min(3, posts.length); i++) {
        final p = posts[i];
        final portion = (addedViews / min(3, posts.length)).round();
        _articleExtraViews[p.id] = (_articleExtraViews[p.id] ?? 0) + portion;
      }
    }

    _adUnitExtraImpressions['in_article_mid_banner'] =
        (_adUnitExtraImpressions['in_article_mid_banner'] ?? 0) + addedMidAds;
    _adUnitExtraImpressions['desktop_sidebar_rectangle'] =
        (_adUnitExtraImpressions['desktop_sidebar_rectangle'] ?? 0) + addedSideAds;
    _adUnitExtraImpressions['google_auto_ads_feed'] =
        (_adUnitExtraImpressions['google_auto_ads_feed'] ?? 0) + addedFeedAds;

    _adUnitExtraClicks['in_article_mid_banner'] =
        (_adUnitExtraClicks['in_article_mid_banner'] ?? 0) + (addedClicks > 1 ? 1 : 0);
    _adUnitExtraClicks['desktop_sidebar_rectangle'] =
        (_adUnitExtraClicks['desktop_sidebar_rectangle'] ?? 0) + 1;
  }

  void resetTelemetry() {
    _extraVisits = 0;
    _extraArticleViews = 0;
    _articleExtraViews.clear();
    _adUnitExtraImpressions.updateAll((key, value) => 0);
    _adUnitExtraClicks.updateAll((key, value) => 0);
  }

  AnalyticsReport getReport(AnalyticsTimeFilter filter) {
    double multiplier;
    switch (filter) {
      case AnalyticsTimeFilter.today:
        multiplier = 0.16;
        break;
      case AnalyticsTimeFilter.weekly:
        multiplier = 1.0;
        break;
      case AnalyticsTimeFilter.monthly:
        multiplier = 3.9;
        break;
      case AnalyticsTimeFilter.allTime:
        multiplier = 8.5;
        break;
    }

    // Baseline stats scaled by filter multiplier + real live extras
    final baseVisits = (3450 * multiplier).round() + _extraVisits;
    final baseArticleViews = (2780 * multiplier).round() + _extraArticleViews;

    // Ad units breakdown
    final adMid = AdUnitStat(
      id: 'in_article_mid_banner',
      name: 'Mid-Article In-Stream Banner',
      placement: 'In-Article Content (Mid-point)',
      format: '728x90 Responsive Banner',
      impressions: (2780 * multiplier).round() +
          (_adUnitExtraImpressions['in_article_mid_banner'] ?? 0),
      clicks: (68 * multiplier).round() +
          (_adUnitExtraClicks['in_article_mid_banner'] ?? 0),
      eCpm: 3.65,
    );

    final adSidebar = AdUnitStat(
      id: 'desktop_sidebar_rectangle',
      name: 'Desktop Sticky Sidebar Unit',
      placement: 'Right Column (Screens >= 1000px)',
      format: '300x250 Medium Rectangle',
      impressions: (1940 * multiplier).round() +
          (_adUnitExtraImpressions['desktop_sidebar_rectangle'] ?? 0),
      clicks: (42 * multiplier).round() +
          (_adUnitExtraClicks['desktop_sidebar_rectangle'] ?? 0),
      eCpm: 4.10,
    );

    final adFeed = AdUnitStat(
      id: 'google_auto_ads_feed',
      name: 'Google Auto-Ads Feed Slot',
      placement: 'Between Article Cards in Feed',
      format: 'Native Responsive Feed',
      impressions: (890 * multiplier).round() +
          (_adUnitExtraImpressions['google_auto_ads_feed'] ?? 0),
      clicks: (18 * multiplier).round() +
          (_adUnitExtraClicks['google_auto_ads_feed'] ?? 0),
      eCpm: 2.80,
    );

    final adUnits = [adMid, adSidebar, adFeed];

    final totalAdImpressions = adUnits.fold<int>(0, (sum, ad) => sum + ad.impressions);
    final totalAdClicks = adUnits.fold<int>(0, (sum, ad) => sum + ad.clicks);
    final totalRevenueUsd = adUnits.fold<double>(0.0, (sum, ad) => sum + ad.revenue);
    final totalRevenueNpr = totalRevenueUsd * 134.0; // standard NPR exchange benchmark
    final overallCtr = totalAdImpressions > 0 ? (totalAdClicks / totalAdImpressions) * 100 : 0.0;
    final averageEcpm = totalAdImpressions > 0 ? (totalRevenueUsd / totalAdImpressions) * 1000 : 0.0;

    // Daily Trend for current week (Mon-Sun)
    final dailyFractions = [0.12, 0.14, 0.17, 0.16, 0.19, 0.13, 0.09];
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dailyTrends = <DailyTrendStat>[];

    for (int i = 0; i < 7; i++) {
      final frac = dailyFractions[i];
      final dayViews = (baseArticleViews * frac).round();
      final dayRev = totalRevenueUsd * frac;
      dailyTrends.add(DailyTrendStat(
        day: dayNames[i],
        views: dayViews,
        revenue: double.parse(dayRev.toStringAsFixed(2)),
      ));
    }

    // Per-Article Leaderboard
    final articleStats = <ArticleTrafficStat>[];
    final allPosts = MockContentRepository.allPosts;

    for (int i = 0; i < allPosts.length; i++) {
      final post = allPosts[i];
      final rankFactor = max(0.2, 1.0 - (i * 0.12));
      final extra = _articleExtraViews[post.id] ?? 0;
      final views = ((baseArticleViews * 0.28 * rankFactor) + extra).round();
      final adImps = views * 2;
      final rev = (adImps / 1000.0 * 3.80) + (views * 0.008);

      String badge;
      if (i == 0) {
        badge = '🔥 Viral Trend';
      } else if (i == 1) {
        badge = '💎 Top Earner';
      } else if (i == 2) {
        badge = '⭐ High Engagement';
      } else {
        badge = '📈 Steady Traffic';
      }

      articleStats.add(ArticleTrafficStat(
        id: post.id,
        title: post.title,
        category: post.category,
        views: views,
        adImpressions: adImps,
        revenue: double.parse(rev.toStringAsFixed(2)),
        trendBadge: badge,
      ));
    }

    // Sort by views descending
    articleStats.sort((a, b) => b.views.compareTo(a.views));

    return AnalyticsReport(
      filter: filter,
      totalVisits: baseVisits,
      totalArticleViews: baseArticleViews,
      totalAdImpressions: totalAdImpressions,
      totalAdClicks: totalAdClicks,
      totalRevenueUsd: double.parse(totalRevenueUsd.toStringAsFixed(2)),
      totalRevenueNpr: double.parse(totalRevenueNpr.toStringAsFixed(2)),
      overallCtr: double.parse(overallCtr.toStringAsFixed(2)),
      averageEcpm: double.parse(averageEcpm.toStringAsFixed(2)),
      dailyTrends: dailyTrends,
      adUnits: adUnits,
      articleStats: articleStats,
    );
  }

  String exportJsonReport(AnalyticsTimeFilter filter) {
    final report = getReport(filter);
    final map = {
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'filter': report.filter.label,
      'summary': {
        'total_visits': report.totalVisits,
        'total_article_views': report.totalArticleViews,
        'total_ad_impressions': report.totalAdImpressions,
        'total_ad_clicks': report.totalAdClicks,
        'total_revenue_usd': report.totalRevenueUsd,
        'total_revenue_npr': report.totalRevenueNpr,
        'overall_ctr_pct': report.overallCtr,
        'average_ecpm_usd': report.averageEcpm,
      },
      'ad_units': report.adUnits.map((u) => {
        'id': u.id,
        'name': u.name,
        'placement': u.placement,
        'format': u.format,
        'impressions': u.impressions,
        'clicks': u.clicks,
        'ctr_pct': double.parse(u.ctr.toStringAsFixed(2)),
        'ecpm_usd': u.eCpm,
        'revenue_usd': double.parse(u.revenue.toStringAsFixed(2)),
      }).toList(),
      'articles': report.articleStats.map((a) => {
        'id': a.id,
        'title': a.title,
        'category': a.category,
        'views': a.views,
        'ad_impressions': a.adImpressions,
        'revenue_usd': a.revenue,
        'trend': a.trendBadge,
      }).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  String exportCsvReport(AnalyticsTimeFilter filter) {
    final report = getReport(filter);
    final sb = StringBuffer();
    sb.writeln('Bibek Bhattarai Portfolio - Analytics & Ad Revenue Report');
    sb.writeln('Generated,${DateTime.now().toUtc().toIso8601String()}');
    sb.writeln('Period,${report.filter.label} (${report.filter.description})');
    sb.writeln('');
    sb.writeln('SUMMARY METRICS');
    sb.writeln('Total Platform Visits,${report.totalVisits}');
    sb.writeln('Total Article Pageviews,${report.totalArticleViews}');
    sb.writeln('Total Ad Impressions,${report.totalAdImpressions}');
    sb.writeln('Total Ad Clicks,${report.totalAdClicks}');
    sb.writeln('Overall CTR (%),${report.overallCtr}%');
    sb.writeln('Average eCPM (\$),\$${report.averageEcpm}');
    sb.writeln('Estimated Revenue (\$ USD),\$${report.totalRevenueUsd}');
    sb.writeln('Estimated Revenue (NPR),NPR ${report.totalRevenueNpr}');
    sb.writeln('');
    sb.writeln('AD PLACEMENT PERFORMANCE');
    sb.writeln('Ad Unit Name,Placement,Format,Impressions,Clicks,CTR (%),eCPM (\$),Revenue (\$ USD)');
    for (final u in report.adUnits) {
      sb.writeln('"${u.name}","${u.placement}","${u.format}",${u.impressions},${u.clicks},${u.ctr.toStringAsFixed(2)}%,\$${u.eCpm},\$${u.revenue.toStringAsFixed(2)}');
    }
    sb.writeln('');
    sb.writeln('ARTICLE TRAFFIC & REVENUE LEADERBOARD');
    sb.writeln('Rank,Article Title,Category,Unique Views,Ad Impressions,Revenue (\$ USD),Status');
    for (int i = 0; i < report.articleStats.length; i++) {
      final a = report.articleStats[i];
      sb.writeln('${i + 1},"${a.title.replaceAll('"', '""')}","${a.category}",${a.views},${a.adImpressions},\$${a.revenue},"${a.trendBadge}"');
    }
    return sb.toString();
  }
}

import 'package:flutter/material.dart';

enum MarketplaceCategory {
  all,
  aiModel,
  aiService,
  itEngineering;

  String get label {
    switch (this) {
      case MarketplaceCategory.all:
        return 'All Offerings';
      case MarketplaceCategory.aiModel:
        return 'AI Models & Architectures';
      case MarketplaceCategory.aiService:
        return 'AI Services & Agents';
      case MarketplaceCategory.itEngineering:
        return 'IT & App Engineering';
    }
  }

  String getLocalizedLabel(bool isNepali) {
    if (!isNepali) return label;
    switch (this) {
      case MarketplaceCategory.all:
        return 'सबै उत्पादनहरू';
      case MarketplaceCategory.aiModel:
        return 'एआई मोडेलहरू';
      case MarketplaceCategory.aiService:
        return 'एआई सेवा तथा एजेन्ट';
      case MarketplaceCategory.itEngineering:
        return 'आईटी तथा एप इन्जिनियरिङ';
    }
  }
}

class MarketplaceItem {
  final String id;
  final String title;
  final String titleNepali;
  final MarketplaceCategory category;
  final String shortDescription;
  final String shortDescriptionNepali;
  final int priceUsd;
  final int priceNpr;
  final String deliveryTime;
  final String deliveryTimeNepali;
  final String badge;
  final String badgeNepali;
  final List<String> features;
  final List<String> featuresNepali;
  final List<String> techStack;
  final IconData icon;

  const MarketplaceItem({
    required this.id,
    required this.title,
    required this.titleNepali,
    required this.category,
    required this.shortDescription,
    required this.shortDescriptionNepali,
    required this.priceUsd,
    required this.priceNpr,
    required this.deliveryTime,
    required this.deliveryTimeNepali,
    required this.badge,
    required this.badgeNepali,
    required this.features,
    required this.featuresNepali,
    required this.techStack,
    required this.icon,
  });

  String displayTitle(bool isNepali) => isNepali ? titleNepali : title;
  String displayDescription(bool isNepali) =>
      isNepali ? shortDescriptionNepali : shortDescription;
  String displayDelivery(bool isNepali) =>
      isNepali ? deliveryTimeNepali : deliveryTime;
  String displayBadge(bool isNepali) => isNepali ? badgeNepali : badge;
  List<String> displayFeatures(bool isNepali) =>
      isNepali ? featuresNepali : features;
}

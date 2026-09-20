import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service utility to safely launch external URLs on web and mobile platforms.
class UrlService {
  static Future<bool> launch(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } else {
        debugPrint('Could not launch URL: $urlString');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching URL ($urlString): $e');
      return false;
    }
  }
}

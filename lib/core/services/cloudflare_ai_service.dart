import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to interact with Cloudflare Workers AI via the /api/ai Pages Function.
class CloudflareAiService {
  static const String _apiEndpoint = '/api/ai';

  /// Sends a query to the Cloudflare Workers AI endpoint.
  static Future<String> askAi(String prompt) async {
    try {
      if (kIsWeb) {
        final response = await http
            .post(
              Uri.parse(_apiEndpoint),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'prompt': prompt}),
            )
            .timeout(const Duration(seconds: 12));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['response'] != null) {
            final raw = data['response'];
            if (raw is Map && raw['response'] != null) {
              return raw['response'].toString().trim();
            }
            return raw.toString().trim();
          }
        }
      }
    } catch (_) {
      // Fallback to on-device context intelligence if offline or local server
    }

    return _generateLocalContextResponse(prompt);
  }

  /// High-accuracy local context response when local or before Cloudflare Workers AI binding is activated.
  static String _generateLocalContextResponse(String prompt) {
    final p = prompt.toLowerCase();

    if (p.contains('machhamart')) {
      return 'Machhamart (com.machhamart) is Bibek Bhattarai\'s verified production mobile application published on the Google Play Store. It is an end-to-end aquaculture logistics and fresh seafood e-commerce platform operating across Nepal with cold-chain tracking and payment gateway integrations.';
    }

    if (p.contains('android health') || p.contains('health') || p.contains('triage') || p.contains('vitals')) {
      return 'Android Health (com.mobilehealth.droidpulse.mobile_health) is in Closed Testing on Google Play Console. It is a clinical telemetry and diagnostics application powered by the DroidPulse engine, supporting vital signs monitoring, biostatistical anomaly detection, and HL7 FHIR sync.';
    }

    if (p.contains('search') || p.contains('everything')) {
      return 'Search Everything (com.devicefinder.app.device_finder) is a high-speed Android system indexing utility in Closed Testing on Google Play Console. It uses in-memory B-Trees and SQLite FTS5 to deliver sub-50ms search across device storage and document caches.';
    }

    if (p.contains('trader') || p.contains('trading') || p.contains('3d ms')) {
      return '3D MS Trader (com.mstrader.com) is an algorithmic market analytics app on Google Play Console designed for quantitative traders with real-time technical indicators and risk position sizing.';
    }

    if (p.contains('education') || p.contains('degree') || p.contains('study') || p.contains('university')) {
      return 'Bibek Bhattarai\'s academic credentials include: 1) Bachelor in Education (B.Ed 4 Years) at Tribhuvan University, 2) MBA at Pokhara University, 3) BSc (Hons) Computing at London Metropolitan University, 4) Diploma in General Medicine (HA) from CTEVT, and 5) SLC with Distinction.';
    }

    if (p.contains('contact') || p.contains('email') || p.contains('hire')) {
      return 'You can reach Bibek directly through the Contact page on bhattaraibvk.com.np or via email at bhattaraibvk@gmail.com and LinkedIn.';
    }

    return 'Bibek Bhattarai is a multidisciplinary technologist and researcher bridging Enterprise IT, Healthcare Biostatistical Systems, and Strategic Business Management. He has 4 verified Google Play applications: Machhamart (Production), Android Health (Closed Testing), Search Everything (Closed Testing), and 3D MS Trader (Closed Testing).';
  }
}

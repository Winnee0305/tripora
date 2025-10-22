import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tripora/core/services/booking_url_service.dart';

class BookNowViewModel extends ChangeNotifier {
  // Optionally you can track last launched URL or state
  String? lastLaunchedUrl;

  Future<void> onBookingItemTapped(String label) async {
    final url = BookingUrlService.getUrlByLabel(label);
    if (url.isEmpty) {
      debugPrint("No URL found for $label");
      return;
    }

    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    } else {
      lastLaunchedUrl = url;
      notifyListeners();
    }
  }
}

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static void initialize() {
    MobileAds.instance.initialize();
  }
}
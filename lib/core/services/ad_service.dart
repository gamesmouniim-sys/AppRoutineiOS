import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/app_repository.dart';

enum AdPlacement { focusCompleted, freeLimitGate, settingsBanner }

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  int _sessionCompletionsSinceLastAd = 0;
  DateTime _lastAdShownAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _interstitialReady = false;

  Future<void> init() async {
    if (kDebugMode) {
      AppLovinMAX.setVerboseLogging(true);
    }

    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) => _interstitialReady = true,
      onAdLoadFailedCallback: (adUnitId, error) => _interstitialReady = false,
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) => _interstitialReady = false,
      onAdHiddenCallback: (ad) {
        _interstitialReady = false;
        loadInterstitial();
      },
      onAdClickedCallback: (ad) {},
      onAdRevenuePaidCallback: (ad) {},
    ));

    await AppLovinMAX.initialize('YOUR_APPLOVIN_SDK_KEY');
    loadInterstitial();
  }

  void loadInterstitial() {
    AppLovinMAX.loadInterstitial('YOUR_INTERSTITIAL_AD_UNIT_ID');
  }

  Future<void> showInterstitialIfEligible({required AdPlacement placement}) async {
    final isPro = AppRepository.instance.settings.isPro;
    if (isPro) return;

    final now = DateTime.now();
    final timeEligible = now.difference(_lastAdShownAt).inMinutes >= 10;

    if (placement == AdPlacement.focusCompleted) {
      _sessionCompletionsSinceLastAd++;
      if (!(_sessionCompletionsSinceLastAd >= 3 || timeEligible)) return;
    }

    if (!_interstitialReady) {
      loadInterstitial();
      return;
    }

    AppLovinMAX.showInterstitial('YOUR_INTERSTITIAL_AD_UNIT_ID');
    _lastAdShownAt = now;
    _sessionCompletionsSinceLastAd = 0;
  }
}

Future<void> showAds({required AdPlacement placement}) =>
    AdService.instance.showInterstitialIfEligible(placement: placement);

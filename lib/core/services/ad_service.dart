import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/models.dart';
import '../../data/repositories/app_repository.dart';

enum AdPlacement { focusCompleted, freeLimitGate, settingsBanner }

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  int _sessionCompletionsSinceLastAd = 0;
  DateTime _lastAdShownAt = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> init() async {
    if (kDebugMode) {
      await AppLovinMAX.setVerboseLogging(true);
    }
    await AppLovinMAX.initialize('YOUR_APPLOVIN_SDK_KEY');
    await loadInterstitial();
  }

  Future<void> loadInterstitial() async {
    await AppLovinMAX.loadInterstitial('YOUR_INTERSTITIAL_AD_UNIT_ID');
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

    final isReady = (await AppLovinMAX.isInterstitialReady('YOUR_INTERSTITIAL_AD_UNIT_ID')) ?? false;
    if (!isReady) {
      await loadInterstitial();
      return;
    }
    await AppLovinMAX.showInterstitial('YOUR_INTERSTITIAL_AD_UNIT_ID');
    _lastAdShownAt = now;
    _sessionCompletionsSinceLastAd = 0;
    await loadInterstitial();
  }
}

Future<void> showAds({required AdPlacement placement}) =>
    AdService.instance.showInterstitialIfEligible(placement: placement);

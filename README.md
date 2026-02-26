# Deep Work Routine (iOS-first Flutter MVP)

Tagline: **Plan 3. Focus. Done. Repeat.**

Bundle id: `com.deep.workmo`

## Architecture

- `lib/core`: theme, router, constants, services (ads, notifications, export, app state)
- `lib/domain`: entities + usecases (streak + limit rules)
- `lib/data`: repository + DB schema placeholder
- `lib/features`: onboarding, home/today, focus, habits, calendar, settings
- State management: **Riverpod**
- Navigation: **go_router**
- UI: **Material 3** (iOS-friendly simple cards and controls)

## MVP Features included

- Onboarding with 3 steps.
- Home Today:
  - outcomes (1–3)
  - today tasks
  - start focus CTA
  - quick stats (today minutes + streak)
- Focus timer:
  - 25/50/90 presets
  - start/pause/stop
  - keep awake during session
  - session completion prompt (required done entry + optional note)
  - saves focus session and increments streak metrics
- Habits:
  - add habits
  - free/pro limit enforcement (3 free, 5 absolute)
- Calendar:
  - daily agenda list
  - focus block suggestion and creation
- Settings:
  - reminders placeholder
  - theme mode display
  - export JSON (versioned with `exportVersion: 1`)
  - debug mock Pro toggle
- Freemium + Ads:
  - single source of truth `settings.isPro`
  - `AdService` and global `showAds({required AdPlacement placement})`
  - AppLovin interstitial frequency cap (1 per 3 sessions or 10 min)

## Flutter version and setup

Recommended:
- Flutter 3.24+
- Dart 3.3+
- Xcode 15+

Install dependencies:

```bash
flutter pub get
```

Generate iOS pods:

```bash
cd ios
pod install
cd ..
```

Run code generation if you expand Drift tables into generated DB classes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Run app (iOS simulator):

```bash
flutter run -d ios
```

## AppLovin MAX setup

1. Replace placeholders in `lib/core/services/ad_service.dart`:
   - `YOUR_APPLOVIN_SDK_KEY`
   - `YOUR_INTERSTITIAL_AD_UNIT_ID`
2. Ensure iOS `Info.plist` has AppLovin SDK key and ATT usage key.
3. Follow AppLovin MAX dashboard instructions for ad units and test devices.

## Notifications

- Daily reminder service scaffold exists in `NotificationsService`.
- Extend scheduling for exact local daily notifications based on selected time.

## Tests

Contains unit tests for:
- streak calculation
- task limit enforcement
- habit active limit

Run:

```bash
flutter test
```

## iOS project structure note

This repository includes a valid Xcode project scaffold (not just placeholders): `ios/Runner.xcodeproj` with a real `project.pbxproj`, workspace, and shared Runner scheme, plus `ios/Runner/Info.plist`, `ios/Podfile`, and `ios/Flutter/*.xcconfig`.

If your local environment still reports missing iOS files, regenerate standard platform files with:

```bash
flutter create .
```

Then re-apply bundle identifiers and AppLovin keys.

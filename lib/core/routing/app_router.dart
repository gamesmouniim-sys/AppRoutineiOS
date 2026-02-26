import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/calendar_screen.dart';
import '../../features/focus/focus_timer_screen.dart';
import '../../features/habits/habits_screen.dart';
import '../../features/home_today/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/settings/settings_screen.dart';

GoRouter buildRouter(bool onboardingDone) => GoRouter(
      initialLocation: onboardingDone ? '/' : '/onboarding',
      routes: [
        GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/focus', builder: (_, __) => const FocusTimerScreen()),
        GoRoute(path: '/habits', builder: (_, __) => const HabitsScreen()),
        GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    );

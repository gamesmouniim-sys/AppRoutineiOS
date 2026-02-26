import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/services/ad_service.dart';
import 'core/services/app_state.dart';
import 'core/services/notifications_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().init();
  await AdService.instance.init();
  runApp(const ProviderScope(child: DeepWorkRoutineApp()));
}

class DeepWorkRoutineApp extends ConsumerStatefulWidget {
  const DeepWorkRoutineApp({super.key});

  @override
  ConsumerState<DeepWorkRoutineApp> createState() => _DeepWorkRoutineAppState();
}

class _DeepWorkRoutineAppState extends ConsumerState<DeepWorkRoutineApp> {
  @override
  void initState() {
    super.initState();
    ref.read(appStateProvider).bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final router = buildRouter(app.settings.onboardingDone);
    final mode = switch (app.settings.themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return MaterialApp.router(
      title: 'Deep Work Routine',
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/app_state.dart';
import '../../core/services/export_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(title: Text(appName), subtitle: Text(appTagline)),
          SwitchListTile(
            value: app.settings.remindersEnabled,
            onChanged: (_) {},
            title: const Text('Daily reminders'),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(app.settings.themeMode),
          ),
          ListTile(
            title: const Text('Export data'),
            onTap: () => ExportService().exportJson(),
          ),
          const Divider(),
          ListTile(
            title: const Text('Upgrade to Pro'),
            subtitle: Text(app.settings.isPro ? 'Pro enabled' : 'Free plan'),
          ),
          if (kDebugMode)
            SwitchListTile(
              value: app.settings.isPro,
              onChanged: (v) => app.togglePro(v),
              title: const Text('Debug: mock Pro toggle'),
            )
        ],
      ),
    );
  }
}

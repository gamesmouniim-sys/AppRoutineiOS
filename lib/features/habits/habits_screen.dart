import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/ad_service.dart';
import '../../core/services/app_state.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Max 5 active habits. Free plan allows 3.'),
          ...app.habits.map((h) => SwitchListTile(value: h.active, onChanged: (_) {}, title: Text(h.name))),
          FilledButton(
            onPressed: () async {
              final c = TextEditingController();
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Add habit'),
                  content: TextField(controller: c),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final ok = app.addHabit(c.text.trim());
                        Navigator.pop(context);
                        if (!ok) {
                          showAds(placement: AdPlacement.freeLimitGate);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Limit reached. Upgrade to Pro or deactivate one habit.')));
                        }
                      },
                      child: const Text('Save'),
                    )
                  ],
                ),
              );
            },
            child: const Text('Add habit'),
          ),
        ],
      ),
    );
  }
}

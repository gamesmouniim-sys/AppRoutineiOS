import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/app_state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int step = 0;
  String goal = 'Study';
  final reminder = TextEditingController(text: '20:00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(appTagline),
            const SizedBox(height: 12),
            if (step == 0)
              DropdownButton<String>(
                value: goal,
                items: const ['Study', 'Work', 'Fitness', 'Creative', 'Custom']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => goal = v ?? goal),
              ),
            if (step == 1) const Text('Pick 3 starter habits (you can edit later).'),
            if (step == 2)
              TextField(controller: reminder, decoration: const InputDecoration(labelText: 'Daily reminder time (HH:mm)')),
            const Spacer(),
            FilledButton(
              onPressed: () {
                if (step < 2) {
                  setState(() => step++);
                } else {
                  ref.read(appStateProvider).updateOnboardingDone();
                  context.go('/');
                }
              },
              child: Text(step < 2 ? 'Next' : 'Finish'),
            )
          ],
        ),
      ),
    );
  }
}

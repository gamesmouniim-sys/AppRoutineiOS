import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/app_state.dart';
import '../../domain/entities/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final outcomes = app.todayOutcomes;
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Outcomes (1–3)'),
              subtitle: outcomes.items.isEmpty
                  ? const Text('No outcomes yet. Add 1–3.')
                  : Text(outcomes.items.map((e) => '• $e').join('\n')),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final c = TextEditingController(text: outcomes.items.join(', '));
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Today outcomes'),
                      content: TextField(controller: c, decoration: const InputDecoration(hintText: 'comma separated')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
                      ],
                    ),
                  );
                  app.saveOutcomes(c.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList());
                },
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                const ListTile(title: Text('Today tasks')),
                if (app.tasks.where((e) => !e.done).isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('No tasks. Add a task.'),
                  ),
                ...app.tasks.where((e) => !e.done).map((t) => CheckboxListTile(
                      value: t.done,
                      title: Text(t.title),
                      onChanged: (_) => app.completeTask(t.id),
                    )),
                TextButton(
                  onPressed: () => _addTask(context, app),
                  child: const Text('Add task'),
                )
              ],
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Quick stats'),
              subtitle: Text('Today minutes: ${app.todayFocusMinutes} • Streak: ${app.streak} days'),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.push('/focus'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Focus'),
          ),
          Wrap(
            spacing: 8,
            children: [
              TextButton(onPressed: () => context.push('/habits'), child: const Text('Habits')),
              TextButton(onPressed: () => context.push('/calendar'), child: const Text('Calendar')),
              TextButton(onPressed: () => context.push('/settings'), child: const Text('Settings')),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _addTask(BuildContext context, AppStateController app) async {
    final c = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add task'),
        content: TextField(controller: c),
        actions: [
          TextButton(
            onPressed: () {
              final ok = app.addTask(c.text, TaskListType.today);
              Navigator.pop(context);
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Free limit reached (10 tasks).')));
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}

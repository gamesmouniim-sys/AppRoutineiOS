import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/services/app_state.dart';
import '../../domain/entities/models.dart';

class FocusTimerScreen extends ConsumerStatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen> {
  int selected = 25;
  int remaining = 25 * 60;
  Timer? timer;
  bool running = false;
  FocusCategory category = FocusCategory.study;

  @override
  Widget build(BuildContext context) {
    final mins = (remaining ~/ 60).toString().padLeft(2, '0');
    final secs = (remaining % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 25, label: Text('25')),
                ButtonSegment(value: 50, label: Text('50')),
                ButtonSegment(value: 90, label: Text('90')),
              ],
              selected: {selected},
              onSelectionChanged: (s) {
                setState(() {
                  selected = s.first;
                  remaining = selected * 60;
                });
              },
            ),
            const SizedBox(height: 24),
            Text('$mins:$secs', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),
            DropdownButton<FocusCategory>(
              value: category,
              items: FocusCategory.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (v) => setState(() => category = v ?? category),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: running ? _pause : _start, child: Text(running ? 'Pause' : 'Start')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _stop, child: const Text('Stop')),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _start() {
    HapticFeedback.mediumImpact();
    WakelockPlus.enable();
    setState(() => running = true);
    timer ??= Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!running) return;
      if (remaining <= 1) {
        t.cancel();
        timer = null;
        await WakelockPlus.disable();
        setState(() {
          running = false;
          remaining = 0;
        });
        if (mounted) _showCompleteSheet();
      } else {
        setState(() => remaining--);
      }
    });
  }

  void _pause() => setState(() => running = false);

  void _stop() {
    HapticFeedback.selectionClick();
    timer?.cancel();
    timer = null;
    WakelockPlus.disable();
    setState(() {
      running = false;
      remaining = selected * 60;
    });
  }

  Future<void> _showCompleteSheet() async {
    HapticFeedback.heavyImpact();
    final doneCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What did you finish?'),
            TextField(controller: doneCtrl, decoration: const InputDecoration(labelText: 'Required done entry')),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Optional note')),
            FilledButton(
              onPressed: () {
                if (doneCtrl.text.trim().isEmpty) return;
                ref.read(appStateProvider).addSession(FocusSession(
                      id: ref.read(appStateProvider).repo.nextId(),
                      durationMinutes: selected,
                      category: category,
                      completedAt: DateTime.now(),
                      doneEntry: doneCtrl.text.trim(),
                      note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                      label: doneCtrl.text.trim(),
                    ));
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Save session'),
            )
          ],
        ),
      ),
    );
  }
}

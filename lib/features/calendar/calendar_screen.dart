import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/app_state.dart';
import '../../domain/entities/models.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final today = DateTime.now();
    final dayAppointments = app.appointments
        .where((a) => a.startDateTime.year == today.year && a.startDateTime.month == today.month && a.startDateTime.day == today.day)
        .toList()
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Daily agenda'),
          ...dayAppointments.map((a) => ListTile(
                title: Text(a.title),
                subtitle: Text('${a.startDateTime.hour}:${a.startDateTime.minute.toString().padLeft(2, '0')} - ${a.endDateTime.hour}:${a.endDateTime.minute.toString().padLeft(2, '0')}'),
              )),
          const SizedBox(height: 8),
          Text('Suggested focus block: ${_suggestBlock(dayAppointments)} min'),
          FilledButton(
            onPressed: () {
              final start = DateTime(today.year, today.month, today.day, 9);
              app.addAppointment(Appointment(
                id: app.repo.nextId(),
                title: 'Focus Block',
                startDateTime: start,
                endDateTime: start.add(const Duration(minutes: 50)),
                type: AppointmentType.focusBlock,
              ));
            },
            child: const Text('Add Focus Block'),
          )
        ],
      ),
    );
  }

  int _suggestBlock(List<Appointment> appts) {
    if (appts.isEmpty) return 90;
    return 50;
  }
}

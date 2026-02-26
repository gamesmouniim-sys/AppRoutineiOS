import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/entities/models.dart';

class AppRepository {
  AppRepository._();
  static final AppRepository instance = AppRepository._();

  final List<TaskItem> tasks = [];
  final List<FocusSession> sessions = [];
  final List<Habit> habits = [];
  final List<HabitCompletion> habitCompletions = [];
  final List<Appointment> appointments = [];
  final Map<String, OutcomePlan> outcomesByDate = {};
  AppSettings settings = AppSettings();
  int _idSeed = 0;

  Future<File> _dbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/deep_work_routine.json');
  }

  Future<void> load() async {
    final file = await _dbFile();
    if (!file.existsSync()) return;
    final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    settings = AppSettings(
      themeMode: map['settings']['themeMode'] as String? ?? 'system',
      remindersEnabled: map['settings']['remindersEnabled'] as bool? ?? true,
      reminderTime: map['settings']['reminderTime'] as String? ?? '20:00',
      isPro: map['settings']['isPro'] as bool? ?? false,
      onboardingDone: map['settings']['onboardingDone'] as bool? ?? false,
    );
  }

  Future<void> save() async {
    final file = await _dbFile();
    await file.writeAsString(jsonEncode({
      'exportVersion': 1,
      'settings': {
        'themeMode': settings.themeMode,
        'remindersEnabled': settings.remindersEnabled,
        'reminderTime': settings.reminderTime,
        'isPro': settings.isPro,
        'onboardingDone': settings.onboardingDone,
      },
    }));
  }

  int nextId() => ++_idSeed;

  Map<String, dynamic> exportAll() => {
        'exportVersion': 1,
        'settings': {
          'themeMode': settings.themeMode,
          'remindersEnabled': settings.remindersEnabled,
          'reminderTime': settings.reminderTime,
          'isPro': settings.isPro,
          'onboardingDone': settings.onboardingDone,
        },
        'outcomes': outcomesByDate.values.map((e) => {'dateKey': e.dateKey, 'items': e.items}).toList(),
        'tasks': tasks
            .map((t) => {
                  'id': t.id,
                  'title': t.title,
                  'listType': t.listType.name,
                  'createdAt': t.createdAt.toIso8601String(),
                  'done': t.done,
                })
            .toList(),
        'sessions': sessions
            .map((s) => {
                  'id': s.id,
                  'durationMinutes': s.durationMinutes,
                  'category': s.category.name,
                  'completedAt': s.completedAt.toIso8601String(),
                  'note': s.note,
                  'doneEntry': s.doneEntry,
                  'linkedTaskId': s.linkedTaskId,
                  'label': s.label,
                })
            .toList(),
      };
}

enum TaskListType { today, next, someday }
enum FocusCategory { study, design, fitness, other }
enum AppointmentType { regular, focusBlock }

class OutcomePlan {
  OutcomePlan({required this.dateKey, required this.items});
  final String dateKey;
  final List<String> items;
}

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.listType,
    required this.createdAt,
    this.scheduledDate,
    this.linkedCategory,
    this.done = false,
  });
  final int id;
  final String title;
  final TaskListType listType;
  final DateTime createdAt;
  final DateTime? scheduledDate;
  final FocusCategory? linkedCategory;
  final bool done;

  TaskItem copyWith({bool? done, TaskListType? listType}) => TaskItem(
        id: id,
        title: title,
        listType: listType ?? this.listType,
        createdAt: createdAt,
        scheduledDate: scheduledDate,
        linkedCategory: linkedCategory,
        done: done ?? this.done,
      );
}

class FocusSession {
  FocusSession({
    required this.id,
    required this.durationMinutes,
    required this.category,
    required this.completedAt,
    this.note,
    this.doneEntry,
    this.linkedTaskId,
    required this.label,
  });
  final int id;
  final int durationMinutes;
  final FocusCategory category;
  final DateTime completedAt;
  final String? note;
  final String? doneEntry;
  final int? linkedTaskId;
  final String label;
}

class Habit {
  Habit({required this.id, required this.name, required this.active});
  final int id;
  final String name;
  final bool active;

  Habit copyWith({bool? active}) => Habit(id: id, name: name, active: active ?? this.active);
}

class HabitCompletion {
  HabitCompletion({required this.habitId, required this.dateKey});
  final int habitId;
  final String dateKey;
}

class Appointment {
  Appointment({
    required this.id,
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
    this.note,
    this.type = AppointmentType.regular,
  });
  final int id;
  final String title;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? note;
  final AppointmentType type;
}

class AppSettings {
  AppSettings({
    this.themeMode = 'system',
    this.remindersEnabled = true,
    this.reminderTime = '20:00',
    this.isPro = false,
    this.onboardingDone = false,
    this.dailyReminderLabel = 'Plan 3. Focus. Done. Repeat.',
  });
  final String themeMode;
  final bool remindersEnabled;
  final String reminderTime;
  final bool isPro;
  final bool onboardingDone;
  final String dailyReminderLabel;

  AppSettings copyWith({
    String? themeMode,
    bool? remindersEnabled,
    String? reminderTime,
    bool? isPro,
    bool? onboardingDone,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        remindersEnabled: remindersEnabled ?? this.remindersEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
        isPro: isPro ?? this.isPro,
        onboardingDone: onboardingDone ?? this.onboardingDone,
      );
}

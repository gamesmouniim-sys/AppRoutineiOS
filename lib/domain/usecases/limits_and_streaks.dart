import '../entities/models.dart';

int calculateSessionStreakDays(List<FocusSession> sessions, {DateTime? now}) {
  final today = DateTime((now ?? DateTime.now()).year, (now ?? DateTime.now()).month, (now ?? DateTime.now()).day);
  final completedDays = sessions
      .map((s) => DateTime(s.completedAt.year, s.completedAt.month, s.completedAt.day))
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));

  var streak = 0;
  for (var i = 0; i < 3650; i++) {
    final day = today.subtract(Duration(days: i));
    if (completedDays.contains(day)) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

bool canAddTask({required bool isPro, required List<TaskItem> activeTasks, int freeLimit = 10}) {
  if (isPro) return true;
  return activeTasks.where((t) => !t.done).length < freeLimit;
}

bool canActivateHabit({required bool isPro, required List<Habit> habits, int freeLimit = 3, int absoluteLimit = 5}) {
  final activeCount = habits.where((h) => h.active).length;
  if (activeCount >= absoluteLimit) return false;
  if (isPro) return true;
  return activeCount < freeLimit;
}

import 'package:deep_work_routine/domain/entities/models.dart';
import 'package:deep_work_routine/domain/usecases/limits_and_streaks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('streak calculation counts consecutive days with sessions', () {
    final now = DateTime(2026, 1, 10, 10);
    final sessions = [
      FocusSession(id: 1, durationMinutes: 25, category: FocusCategory.study, completedAt: DateTime(2026, 1, 10), label: 'A'),
      FocusSession(id: 2, durationMinutes: 25, category: FocusCategory.study, completedAt: DateTime(2026, 1, 9), label: 'B'),
      FocusSession(id: 3, durationMinutes: 25, category: FocusCategory.study, completedAt: DateTime(2026, 1, 8), label: 'C'),
    ];
    expect(calculateSessionStreakDays(sessions, now: now), 3);
  });

  test('task limit enforcement for free tier', () {
    final tasks = List.generate(
      10,
      (i) => TaskItem(id: i, title: 'T$i', listType: TaskListType.today, createdAt: DateTime.now()),
    );
    expect(canAddTask(isPro: false, activeTasks: tasks), false);
    expect(canAddTask(isPro: true, activeTasks: tasks), true);
  });

  test('habit active limit enforcement for free and absolute cap', () {
    final habits = [
      Habit(id: 1, name: 'A', active: true),
      Habit(id: 2, name: 'B', active: true),
      Habit(id: 3, name: 'C', active: true),
    ];
    expect(canActivateHabit(isPro: false, habits: habits), false);
    expect(canActivateHabit(isPro: true, habits: habits), true);
    final maxed = [...habits, Habit(id: 4, name: 'D', active: true), Habit(id: 5, name: 'E', active: true)];
    expect(canActivateHabit(isPro: true, habits: maxed), false);
  });
}

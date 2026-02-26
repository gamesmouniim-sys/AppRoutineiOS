import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/app_repository.dart';
import '../../domain/entities/models.dart';
import '../../domain/usecases/limits_and_streaks.dart';
import 'ad_service.dart';

final appStateProvider = ChangeNotifierProvider<AppStateController>((ref) => AppStateController());

class AppStateController extends ChangeNotifier {
  final repo = AppRepository.instance;

  Future<void> bootstrap() async {
    await repo.load();
    notifyListeners();
  }

  List<TaskItem> get tasks => repo.tasks;
  List<FocusSession> get sessions => repo.sessions;
  List<Habit> get habits => repo.habits;
  List<Appointment> get appointments => repo.appointments;
  AppSettings get settings => repo.settings;

  String todayKey() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  OutcomePlan get todayOutcomes => repo.outcomesByDate[todayKey()] ?? OutcomePlan(dateKey: todayKey(), items: []);

  void saveOutcomes(List<String> items) {
    repo.outcomesByDate[todayKey()] = OutcomePlan(dateKey: todayKey(), items: items.take(3).toList());
    repo.save();
    notifyListeners();
  }

  bool addTask(String title, TaskListType listType) {
    if (!canAddTask(isPro: settings.isPro, activeTasks: tasks)) return false;
    tasks.add(TaskItem(id: repo.nextId(), title: title, listType: listType, createdAt: DateTime.now()));
    repo.save();
    notifyListeners();
    return true;
  }

  void completeTask(int id) {
    final idx = tasks.indexWhere((e) => e.id == id);
    if (idx != -1) tasks[idx] = tasks[idx].copyWith(done: true);
    repo.save();
    notifyListeners();
  }

  void addSession(FocusSession session) {
    sessions.add(session);
    if (session.linkedTaskId != null) completeTask(session.linkedTaskId!);
    repo.save();
    notifyListeners();
    showAds(placement: AdPlacement.focusCompleted);
  }

  int get streak => calculateSessionStreakDays(sessions);

  int get todayFocusMinutes {
    final key = todayKey();
    return sessions
        .where((s) => '${s.completedAt.year}-${s.completedAt.month.toString().padLeft(2, '0')}-${s.completedAt.day.toString().padLeft(2, '0')}' == key)
        .fold(0, (a, b) => a + b.durationMinutes);
  }

  bool addHabit(String name) {
    final allowed = canActivateHabit(isPro: settings.isPro, habits: habits);
    if (!allowed) return false;
    habits.add(Habit(id: repo.nextId(), name: name, active: true));
    repo.save();
    notifyListeners();
    return true;
  }

  void togglePro(bool isPro) {
    repo.settings = repo.settings.copyWith(isPro: isPro);
    repo.save();
    notifyListeners();
  }

  void updateOnboardingDone() {
    repo.settings = repo.settings.copyWith(onboardingDone: true);
    repo.save();
    notifyListeners();
  }

  void addAppointment(Appointment appt) {
    appointments.add(appt);
    repo.save();
    notifyListeners();
  }
}

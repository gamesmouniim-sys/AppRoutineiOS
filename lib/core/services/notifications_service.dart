import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const ios = DarwinInitializationSettings();
    await _notifications.initialize(const InitializationSettings(iOS: ios));
  }

  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    await _notifications.show(
      1,
      'Deep Work Routine',
      'Plan 3. Focus. Done. Repeat.',
      const NotificationDetails(iOS: DarwinNotificationDetails()),
    );
  }
}

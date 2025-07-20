import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  Future<int> _getNextNotificationId() async {
    final prefs = await SharedPreferences.getInstance();
    int lastId = prefs.getInt('notification_id') ?? 0;
    int newId = lastId + 1;
    await prefs.setInt('notification_id', newId);
    return newId;
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledTime) async {
    int id = await _getNextNotificationId(); // Genera un ID único persistente

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        preciseAlarm: true,
      ),
    );
  }
}

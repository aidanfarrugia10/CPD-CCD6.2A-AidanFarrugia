import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
      },
    );
  }

  static Future<void> show(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'pilot_channel',
      'Pilot Notifications',
      channelDescription: 'Channel for pilot app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notifDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(
      DateTime.now().millisecond, // Dynamic ID to avoid overwriting
      title,
      body,
      notifDetails,
    );
  }
}

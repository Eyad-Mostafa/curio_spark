import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the plugin and set up the callback for notification taps
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  // Show a notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', // Channel ID
      'channel_name', // Channel name
      channelDescription: 'Your notification description',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
    );
  }

  // Handle notification tap
  static Future<void> onSelectNotification(NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      print('Notification payload: ${notificationResponse.payload}');
    }
  }

  // Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // NEW METHOD: Notify when a new curiosity is added
  static Future<void> notifyNewCuriosity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notificationsOn = prefs.getBool('notifications_on') ?? true;

    if (notificationsOn) {
      await showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id based on time
        title: 'New Curiosity!',
        body: 'A new curiosity has been added. Check it out!',
      );
    }
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const _prefKey = 'notifications_on';
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings, onDidReceiveNotificationResponse: onSelectNotification);

    // Ensure the preference exists
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_prefKey)) {
      await prefs.setBool(_prefKey, true);
    }
  }

  /// Read current preference.
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? true;
  }

  /// Update preference.
  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
  }

  /// Show a notification *only if* prefs allow.
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!await isEnabled()) return;

    const androidDetails = AndroidNotificationDetails(
      'daily_curiosity',              // channel id
      'Daily Curiosities',            // channel name
      channelDescription: 'Your daily curiosity alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, platformDetails);
  }

  /// Cancel a specific notification.
  static Future<void> cancelNotification(int id) => _plugin.cancel(id);

  /// Cancel *all* notifications.
  static Future<void> cancelAllNotifications() => _plugin.cancelAll();

  /// Handler for taps on notifications.
  static Future<void> onSelectNotification(NotificationResponse response) async {
    // You can navigate or handle payload here.
    if (response.payload != null) {
      print('Tapped notification payload: ${response.payload}');
    }
  }

  /// Convenience: notify when a new curiosity is added.
  static Future<void> notifyNewCuriosity() async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'New Curiosity!',
      body: 'A new curiosity has been added. Check it out!',
    );
  }
}

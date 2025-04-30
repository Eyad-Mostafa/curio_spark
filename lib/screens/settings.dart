import 'dart:io';

import 'package:curio_spark/screens/home.dart';
import 'package:curio_spark/screens/splashscreen.dart';
import 'package:curio_spark/services/hive/profile_hive_service.dart';
import 'package:curio_spark/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/screens/about.dart';
import 'package:curio_spark/screens/updateProfile.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    // Load saved profile data (image and name) from Hive
    final profile = ProfileHiveService.getProfile();
    _currentImagePath = profile?.image;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profile = ProfileHiveService.getProfile();
    final name = profile?.name ?? '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _currentImagePath != null &&
                              File(_currentImagePath!).existsSync()
                          ? Image.file(
                              File(_currentImagePath!),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/icon/default.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Text(
                "Welcome $name",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen(),
                      ),
                    );
                  },
                  child: const Text("Edit Profile"),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // Notifications and Dark Mode settings
              const NotificationSettings(),
              const DarkModeSettings(),

              SettingsMenu(
                title: "Help",
                icon: Icons.help_outline,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Help'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🔍 What is CurioSpark?', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('CurioSpark is an app that delivers fascinating daily curiosities and facts.'),
                          SizedBox(height: 12),
                          Text('📅 Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('You can enable or disable notifications to get your daily curiosity delivered.'),
                          SizedBox(height: 12),
                          Text('🌗 Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('You can switch between light and dark themes from the Settings screen.'),
                          SizedBox(height: 12),
                          Text('🛠 Need Help?', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Contact us at: support@curiospark.app'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SettingsMenu(
                title: "About",
                icon: Icons.info_outline,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),

              const Divider(),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    ProfileHiveService.deleteProfile();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                    );
                  },
                  child: const Text("Restart Progress"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).iconTheme.color;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(Icons.navigate_next, color: iconColor),
            )
          : null,
    );
}
}
/// NOTIFICATIONS
class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _notificationsOn = true;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Load profile image if needed
    final profile = ProfileHiveService.getProfile();
    // You can also use profile?.image if you want to display it here

    _loadNotificationPreference();
    _initializeNotificationPlugin();
  }

  Future<void> _initializeNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsOn = prefs.getBool('notifications_on') ?? true;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsOn = value;
    });
    await prefs.setBool('notifications_on', value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(value ? 'Notifications Enabled' : 'Notifications Disabled'),
        duration: const Duration(seconds: 1),
      ),
    );

    if (value) {
      _showNotification();
    } else {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Channel for notification settings',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Notification Enabled',
      'You will now receive notifications.',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
      title: const Text('Notifications'),
      trailing: Switch(
        value: _notificationsOn,
        onChanged: _toggleNotification,
      ),
    );
  }
}

/// DARK MODE
class DarkModeSettings extends StatelessWidget {
  const DarkModeSettings({super.key});

  Future<void> _toggleDarkMode(BuildContext context, bool value) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.toggleTheme();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Dark Mode Enabled' : 'Dark Mode Disabled'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Icon(
        themeProvider.isDarkMode ? Icons.shield_moon : Icons.wb_sunny,
        color: Theme.of(context).iconTheme.color,
      ),
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: themeProvider.isDarkMode,
        onChanged: (value) => _toggleDarkMode(context, value),
      ),
    );
  }
}


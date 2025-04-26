import 'package:curio_spark/screens/home.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(tProfileImage),
                    ),
                  ),                
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Welcome Mr.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProfileScreen()),
                    );
                  },
                  child: Text("Edit Profile"),
                ),
              ),
              SizedBox(width: 30),
              Divider(),
              SizedBox(width: 10),

              /// Notifications and Dark Mode
              NotificationSettings(),
              DarkModeSettings(),

              SettingsMenu(
                title: "Help",
                icon: Icons.help_outline,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Help'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🔍 What is CurioSpark?',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                              'CurioSpark is an app that delivers fascinating daily curiosities and facts.'),
                          SizedBox(height: 12),
                          Text('📅 Notifications',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                              'You can enable or disable notifications to get your daily curiosity delivered.'),
                          SizedBox(height: 12),
                          Text('🌗 Dark Mode',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                              'You can switch between light and dark themes from the Settings screen.'),
                          SizedBox(height: 12),
                          Text('🛠 Need Help?',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Contact us at: support@curiospark.app'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// About
              SettingsMenu(
                title: "About",
                icon: Icons.info_outline,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              Divider(),
              SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text("Restart Progress"),
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

Future<void> _requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    // Permission granted, proceed to show notifications
  } else {
    // Handle permission denial
  }
}

/// NOTIFICATIONS
class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

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
    _loadNotificationPreference();
    _initializeNotificationPlugin();
  }

  Future<void> _initializeNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'better'); // Ensure app_icon exists in your resources
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

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
        duration: Duration(seconds: 1),
      ),
    );

    if (value) {
      _showNotification();
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
      leading:
          Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
      title: Text('Notifications'),
      trailing: Switch(
        value: _notificationsOn,
        onChanged: _toggleNotification,
      ),
    );
  }
}

/// DARK MODE
class DarkModeSettings extends StatefulWidget {
  const DarkModeSettings({super.key});

  @override
  State<DarkModeSettings> createState() => _DarkModeSettingsState();
}

class _DarkModeSettingsState extends State<DarkModeSettings> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = value;
    });
    await prefs.setBool('dark_mode', value);

    // Actually change theme
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Dark Mode Enabled' : 'Dark Mode Disabled'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_darkMode ? Icons.shield_moon : Icons.wb_sunny,
          color: Theme.of(context).iconTheme.color),
      title: Text('Dark Mode'),
      trailing: Switch(
        value: _darkMode,
        onChanged: _toggleDarkMode,
      ),
    );
  }
}

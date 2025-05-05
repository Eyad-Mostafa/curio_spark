import 'dart:io';
import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:curio_spark/model/profile.dart';
import 'package:curio_spark/screens/about.dart';
import 'package:curio_spark/screens/splashscreen.dart';
import 'package:curio_spark/screens/updateProfile.dart';
import 'package:curio_spark/services/hive/profile_hive_service.dart';
import 'package:curio_spark/widgets/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final profile = ProfileHiveService.getProfile();
    setState(() => _profile = profile);
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    final imagePath = _profile?.image;
    final profileName = _profile?.name ?? '';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileImage(imagePath),
            const SizedBox(height: 10),
            Text("$profileName",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            _buildEditButton(context),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const NotificationSettings(),
            const DarkModeSettings(),
            const SizedBox(height: 20),
            SettingsMenu(
              title: "Help",
              icon: Icons.help_outline,
              onPress: _showHelpDialog,
            ),
            SettingsMenu(
              title: "About",
              icon: Icons.info_outline,
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()));
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            _buildRestartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? path) {
    final exists = path != null && File(path).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        width: 120,
        height: 120,
        child: exists
            ? Image.file(File(path), fit: BoxFit.cover)
            : Image.asset('assets/images/icon/default.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          final updated = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const UpdateProfileScreen()));
          if (updated == true) _loadProfile();
        },
        child: const Text("Edit Profile"),
      ),
    );
  }

  Widget _buildRestartButton(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          ProfileHiveService.deleteProfile();
          CuriosityHiveService.clear();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SplashScreen()));
        },
        child: const Text("Restart Progress"),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpItem("🔍 What is CurioSpark?",
                "CurioSpark delivers daily curiosities and facts."),
            _HelpItem("📅 Notifications",
                "Enable notifications to get daily curiosities."),
            _HelpItem("🌗 Dark Mode", "Switch between light and dark themes."),
            _HelpItem("🛠 Need Help?", "Contact us at: support@curiospark.app"),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String title;
  final String content;

  const _HelpItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(content),
        const SizedBox(height: 12),
      ],
    );
  }
}

class SettingsMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;

  const SettingsMenu({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    return ListTile(
      onTap: onPress,
      leading: CircleAvatar(
        backgroundColor: iconColor?.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
      trailing: endIcon ? const Icon(Icons.navigate_next) : null,
    );
  }
}

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _enabled = true;
  final _plugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadPref();
    _initializePlugin();
  }

  Future<void> _initializePlugin() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin
        .initialize(const InitializationSettings(android: androidSettings));
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _enabled = prefs.getBool('notifications_on') ?? true);
  }

  Future<void> _toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_on', value);
    setState(() => _enabled = value);

    if (value) {
      const androidDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'Notification settings channel',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      await _plugin.show(
          0,
          'Notifications Enabled',
          'You will now receive daily curiosities.',
          const NotificationDetails(android: androidDetails));
    } else {
      await _plugin.cancelAll();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(value ? 'Notifications Enabled' : 'Notifications Disabled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
      title: const Text('Notifications'),
      trailing: Switch(value: _enabled, onChanged: _toggle),
    );
  }
}

class DarkModeSettings extends StatelessWidget {
  const DarkModeSettings({super.key});

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
        onChanged: (value) async {
          await themeProvider.toggleTheme();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(value ? 'Dark Mode Enabled' : 'Dark Mode Disabled')),
          );
        },
      ),
    );
  }
}

import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/screens/about.dart';
import 'package:curio_spark/screens/updateProfile.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
              //Image
              Stack(
                children: [
                  SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(image: AssetImage(tProfileImage)),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: editIcon,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Text("welcome mr.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              /////////we need display name and some details alternate welcome///////////////
              SizedBox(height: 20,),
              SizedBox(
                width: 200, height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
                  },
                  child: Text("Edit Profile",),
                ),
              ),
              SizedBox(width: 30,),
              Divider(),
              SizedBox(width: 10,),
              NotificationSettings(),
              ListTile(
                leading: Icon(isDark ? Icons.wb_sunny : Icons.shield_moon, color: Theme.of(context).iconTheme.color),
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value){
                    themeProvider.toggleTheme();
                  }
                ),
              ),
              SettingsMenu(
                  title: "About",
                  icon: Icons.info_outline,
                  onPress:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutScreen()))
              ),
              Divider(),
              SizedBox(height: 10,),
              SizedBox(
                  width: 200, height: 40,
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfileScreen()));
                  },
                  child: Text("Restart Progress",),
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
        width: 30, height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).iconTheme.color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 15,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(
                Icons.navigate_next,
                color: iconColor,
              ),
            )
          : null,
    );
  }
}
class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _notificationsOn = true;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _initializeNotificationPlugin();
  }

  Future<void> _initializeNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
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

    // Show a snackbar indicating notification preference change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Notifications Enabled' : 'Notifications Disabled'),
        duration: Duration(seconds: 1),
      ),
    );

    // Trigger a notification if the user enables notifications
    if (value) {
      _showNotification();
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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
      leading: Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
      title: Text('Notifications'),
      trailing: Switch(
        value: _notificationsOn,
        onChanged: _toggleNotification,
      ),
    );
  }
}

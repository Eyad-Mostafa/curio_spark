import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/screens/updateProfile.dart';
import 'package:curio_spark/screens/home.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
                        color: tPrimary,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("welcome mr.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              /////////we need display name and some details alternate welcome///////////////
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfileScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgButton,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                        color: tBColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    ///////////////we need change fontFamily/////////////
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const Divider(),
              const SizedBox(
                width: 10,
              ),

              ProfileMenu(
                  title: "Notifications",
                  icon: LineAwesomeIcons.bell,
                  onPress: () {}),
              ProfileMenu(
                  title: "Help",
                  icon: LineAwesomeIcons.question_circle,
                  onPress: () {}),
              ProfileMenu(
                  title: "About",
                  icon: LineAwesomeIcons.exclamation_circle,
                  onPress: () {}),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              ProfileMenu(
                title: "Reset",
                textColor: Colors.red,
                endIcon: false,
                icon: LineAwesomeIcons.alternate_sign_out,
                onPress: () async {
                  final box = Hive.box<Curiosity>('curiosities');
                  await box.clear();

                  setState(() {
                    curiosities.clear(); // remove from memory
                    filteredCuriosities.clear(); // remove from screen
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Data cleared.")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? dIColor : lIColor;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: tArrow.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 15).apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                LineAwesomeIcons.angle_right,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}

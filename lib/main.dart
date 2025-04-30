import 'package:curio_spark/model/profile.dart';
import 'package:curio_spark/screens/splashscreen.dart';
import 'package:curio_spark/services/hive/profile_hive_service.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_preview/device_preview.dart'; // <--- Added back

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  if (kIsWeb) {
    await Hive.initFlutter(''); // Web uses IndexedDB, no path needed
  } else {
    await Hive.initFlutter();
  }
  Hive.registerAdapter(CuriosityAdapter());
  Hive.registerAdapter(ProfileAdapter());

  await Hive.openBox<Profile>('profiles');
  await Hive.openBox<Curiosity>('curiosities');
  CuriosityHiveService.init();
  ProfileHiveService.init();

  // Initialize Android Alarm Manager (non-web only)
  if (!kIsWeb) {
    await AndroidAlarmManager.initialize();
  }

  // Run the app
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only enable in debug or profile mode
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ThemeProvider()..init(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      builder: DevicePreview.appBuilder, // <--- Added back
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'CurioSpark',
      home: SplashScreen(),
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
    );
  }
}

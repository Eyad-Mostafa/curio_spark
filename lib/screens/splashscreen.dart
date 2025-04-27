import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:curio_spark/services/gemini_service.dart';
import 'package:curio_spark/screens/MainScreen.dart';
import 'package:curio_spark/constants/colors.dart';

// Hive imports for background isolate
import 'package:hive_flutter/hive_flutter.dart';
import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/model/profile.dart';

// Define the alarm interval as a constant for easy changes
const Duration alarmInterval = Duration(seconds: 30); // Adjust as needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _prepareApp();
  }

  Future<void> _prepareApp() async {
    // 1) Let the splash animation play
    await Future.delayed(const Duration(seconds: 3));

    // 2) Schedule background fetch (won't block UI)
    _scheduleBackgroundFetch();

    // 3) Navigate on
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _scheduleBackgroundFetch() {
    // Only Android supports AlarmManager
    if (kIsWeb || !Platform.isAndroid) {
      debugPrint('⛔ AlarmManager skipped on this platform');
      return;
    }

    // Cancel any existing alarm with ID 0
    AndroidAlarmManager.cancel(0).then((_) {
      debugPrint("🗑️ Existing alarm cancelled");

      // Schedule a repeating task every `alarmInterval`
      AndroidAlarmManager.periodic(
        alarmInterval,
        0, // unique alarm ID
        _backgroundFetchTask,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      debugPrint("⏰ AlarmManager task scheduled every ${alarmInterval.inSeconds} seconds");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: tdBGColor,
        body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/images/icon/idea.png'),
            ),
          ),
        ),
      );
}

/// Runs in its own background isolate every [alarmInterval]
@pragma('vm:entry-point')
Future<void> _backgroundFetchTask() async {
  debugPrint("🔔 AlarmManager triggered curiosity generation");

  // Initialize Hive in this isolate
  await Hive.initFlutter();

  // Register adapters only once
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CuriosityAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ProfileAdapter());
  }

  // Open the necessary box
  final curiosityBox = await Hive.openBox<Curiosity>('curiosities');

  // Call your generator (passing the box)
  await CuriosityGeneratorService.generateAndSaveUniqueCuriosity(curiosityBox);
}

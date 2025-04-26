import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:curio_spark/services/gemini_service.dart';
import 'package:curio_spark/screens/MainScreen.dart';
import 'package:curio_spark/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
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
      // Schedule a repeating task every 30 seconds (test interval)
      AndroidAlarmManager.periodic(
        const Duration(seconds: 30),
        0, // unique alarm ID
        _backgroundFetchTask,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
      debugPrint("⏰ AlarmManager task scheduled every 5 minutes");
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

/// This runs in its own background isolate every 5 minutes
@pragma('vm:entry-point')
Future<void> _backgroundFetchTask() async {
  debugPrint("🔔 AlarmManager triggered curiosity generation");
  await CuriosityGeneratorService.generateAndSaveUniqueCuriosity();
}

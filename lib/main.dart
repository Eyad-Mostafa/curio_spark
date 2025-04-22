import 'package:curio_spark/model/profile.dart';
import 'package:curio_spark/screens/MainScreen.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/curiosity.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CuriosityAdapter());
  Hive.registerAdapter(ProfileAdapter());

  await Hive.openBox<Profile>('profiles');
  await Hive.openBox<Curiosity>('curiosities');

  final box = Hive.box<Curiosity>('curiosities');
  if (box.isEmpty) {
    for (var item in Curiosity.sampleData()) {
      box.put(item.id, item);
    }
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
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
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Text("data");
    // MaterialApp(
    //   builder: DevicePreview.appBuilder,
    //   useInheritedMediaQuery: true,
    //   debugShowCheckedModeBanner: false,
    //   title: 'CurioSpark',
    //   home: MainScreen(),
    //   themeMode: themeProvider.themeMode,
    //   theme: ThemeData.light(),
    //   darkTheme: ThemeData.dark(),
    // );
  }
}

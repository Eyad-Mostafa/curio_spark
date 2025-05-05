import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    // Constructor doesn't call init directly to avoid async issues
  }

  // Initialize theme from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
    notifyListeners();
  }

  // Light theme definition
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFEDE6F4),
        iconTheme: IconThemeData(color: Color(0xFF260656)),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF260656)),
          headlineMedium: TextStyle(fontSize: 32, color: Color(0xFF120239)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF120239)),
          titleLarge: TextStyle(fontSize: 22, color: Color(0xFF120239)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF260656),
            foregroundColor: Color(0xFFEDE6F4),
            side: BorderSide.none,
            shape: StadiumBorder(),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFEDE6F4),
          iconTheme: IconThemeData(color: Color(0xFF120239)),
          titleTextStyle: TextStyle(
              color: Color(0xFF120239),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF120239)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF4a1985)),
          ),
          labelStyle: TextStyle(
            color: Color(0xFF120239),
          ),
          prefixIconColor: Color(0xFF120239),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Color(0xFF120239)),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

  // Dark theme definition
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF080121),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 126, 48, 204)),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFEDE6F4)),
          headlineMedium: TextStyle(fontSize: 32, color: Color(0xFFEDE6F4)),
          bodyLarge: TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 250, 250, 252)),
          titleLarge: TextStyle(fontSize: 22, color: Color(0xFFEDE6F4)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFa580ca),
            foregroundColor: Color(0xFF080121),
            side: BorderSide.none,
            shape: StadiumBorder(),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFFa580ca)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFFEDE6F4)),
          ),
          labelStyle: TextStyle(
            color: Color(0xFFEDE6F4),
          ),
          prefixIconColor: Color(0xFFEDE6F4),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Color(0xFFa580ca)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF080121),
          iconTheme: IconThemeData(color: Color(0xFFa580ca)),
          titleTextStyle: TextStyle(
              color: Color(0xFFa580ca),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        cardTheme: CardTheme(
          color: Color(0xFFa580ca),
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
}

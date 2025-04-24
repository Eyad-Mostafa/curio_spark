import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // Light theme definition
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFEDE6F4),
        iconTheme: IconThemeData(color: Color(0xFF120239)),
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
          titleTextStyle: TextStyle(color: Color(0xFF120239), fontSize: 20, fontWeight: FontWeight.bold),
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
      );

  // Dark theme definition
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF080121),
        iconTheme: IconThemeData(color: Color(0xFFa580ca)),
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
          color: Color(0xFFa580ca),
          ),
        prefixIconColor: Color(0xFFa580ca),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Color(0xFFa580ca)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor:  Color(0xFF080121),
          iconTheme: IconThemeData(color: Color(0xFFa580ca)),
          titleTextStyle: TextStyle(color: Color(0xFFa580ca), fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}

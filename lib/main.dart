import 'package:flutter/material.dart';
import 'splash_screen.dart';


void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: RouteSplash(),
    );
  }
}
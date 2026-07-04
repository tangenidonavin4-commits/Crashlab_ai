import 'package:flutter/material.dart';
import 'screens/disclaimer_screen.dart';

void main() {
  runApp(CrashLabApp());
}

class CrashLabApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrashLab AI',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
      ),
      home: DisclaimerScreen(),
    );
  }
}

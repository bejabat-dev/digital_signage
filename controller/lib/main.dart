import 'package:digital_signage_controller/controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            inputDecorationTheme:
                const InputDecorationTheme(border: OutlineInputBorder())),
        debugShowCheckedModeBanner: false,
        home: const Controller());
  }
}

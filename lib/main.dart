import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MandaditoApp());
}

class MandaditoApp extends StatelessWidget {
  const MandaditoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Mandadito',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

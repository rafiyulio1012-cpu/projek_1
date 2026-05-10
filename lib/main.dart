import 'package:flutter/material.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Keuangan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InputScreen(), // Mengarah langsung ke InputScreen
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pressure_flutter/screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen()
    );
  }
}

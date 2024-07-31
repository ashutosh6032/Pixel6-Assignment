import 'package:flutter/material.dart';
import 'package:pixel6_application/View/appscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmployeeListScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(AgriFlowApp());
}

class AgriFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginScreen(),
    );
  }
}
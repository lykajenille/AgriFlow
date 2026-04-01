import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(AgriFlowApp());
}

class AgriFlowApp extends StatelessWidget {
  const AgriFlowApp({super.key});
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
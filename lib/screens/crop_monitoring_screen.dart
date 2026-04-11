import 'package:flutter/material.dart';

class CropMonitoringScreen extends StatelessWidget {
  final String userId;

const CropMonitoringScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(title: Text("Crop Monitoring")),

      body: Center(
        child: Text(
          "Monitor Crop Growth Here",
          style: TextStyle(fontSize:20),
        ),
      ),

    );
  }
}
import 'package:flutter/material.dart';

class CropMonitoringScreen extends StatelessWidget {
  const CropMonitoringScreen({super.key});
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
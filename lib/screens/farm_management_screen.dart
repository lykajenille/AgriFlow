import 'package:flutter/material.dart';

class FarmManagementScreen extends StatelessWidget {
  const FarmManagementScreen({super.key});
  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(title: Text("Farm Management")),

      body: Center(
        child: Text(
          "Manage Farms Here",
          style: TextStyle(fontSize:20),
        ),
      ),

    );
  }
}
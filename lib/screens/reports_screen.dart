import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  final String userId;

const ReportsScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(title: Text("Reports")),

      body: Center(
        child: Text(
          "Farm Reports and Analytics",
          style: TextStyle(fontSize:20),
        ),
      ),

    );
  }
}
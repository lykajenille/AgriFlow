import 'package:flutter/material.dart';

class AdminReports extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text("Farm Reports")),

      body: Center(
        child: Text(
          "Farm productivity and harvest reports",
          style: TextStyle(fontSize:20),
        ),
      ),

    );
  }
}
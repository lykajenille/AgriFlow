import 'package:flutter/material.dart';
import '../models/user.dart';
import 'crop_monitoring_screen.dart';
import 'farm_management_screen.dart';
import 'reports_screen.dart';

class DashboardScreen extends StatelessWidget {
  
  final User userId;

  const DashboardScreen({super.key,required this.userId});

  Widget buildButton(BuildContext context, String title, Widget Function() pageBuilder) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageBuilder()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text("AgriFlow Dashboard"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Welcome ${userId.username}"),

            SizedBox(height:20),

            buildButton(context, "Crop Monitoring", () => CropMonitoringScreen(userId: userId.id.toString())),
            buildButton(context, "Farm Management", () => FarmManagementScreen(userId: userId.id.toString())),
            buildButton(context, "Reports", () => ReportsScreen(userId: userId.id.toString())),

            if(userId.isAdmin()) ...[
              SizedBox(height:20),
              Text("Admin Controls",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
              ElevatedButton(
                onPressed: (){},
                child: Text("View All Farmer Data"),
              )
            ]

          ],
        ),
      ),

    );
  }
}
import 'package:flutter/material.dart';

class AdminCrops extends StatelessWidget {

  final List<String> crops = [
    "Rice - Growing",
    "Corn - Harvest Ready",
    "Tomatoes - Seedling"
  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text("Crop Monitoring")),

      body: ListView.builder(
        itemCount: crops.length,
        itemBuilder: (context,index){

          return ListTile(
            title: Text(crops[index]),
          );

        },
      ),
    );
  }
}
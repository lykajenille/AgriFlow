import 'package:flutter/material.dart';

class AdminFarms extends StatelessWidget {

  final List<String> farms = [
    "Rice Farm A",
    "Corn Field B",
    "Vegetable Farm C"
  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text("Farm Management")),

      body: ListView.builder(
        itemCount: farms.length,
        itemBuilder: (context,index){

          return ListTile(
            title: Text(farms[index]),
            trailing: Icon(Icons.edit),
          );

        },
      ),
    );
  }
}
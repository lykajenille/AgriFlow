import 'package:flutter/material.dart';

class AdminUsers extends StatelessWidget {
   AdminUsers({super.key});
  final List<String> farmers = [
    "Juan Dela Cruz",
    "Pedro Santos",
    "Maria Lopez"
  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text("Farmer Management")),

      body: ListView.builder(
        itemCount: farmers.length,
        itemBuilder: (context,index){

          return ListTile(
            title: Text(farmers[index]),
            trailing: Icon(Icons.delete),
          );

        },
      ),
    );
  }
}
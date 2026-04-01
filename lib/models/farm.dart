import 'package:flutter/foundation.dart';

class Farm {

  String farmName;
  String location;
  int size;

  Farm(this.farmName,this.location,this.size);

  void addFarm(){
  debugPrint("Farm added");
  }

}
import 'package:flutter/widgets.dart';

class Crop {

  String cropName;
  String plantingDate;

  Crop(this.cropName,this.plantingDate);

  void monitorCrop(){
    debugPrint("Monitoring crop");
  }

}
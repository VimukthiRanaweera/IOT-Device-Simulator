import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

class ReadDeviceList{
  late String filePath;
   int nameIndex=-1;
   int macIndex=-1;
  var deviceList = new Map();
  ReadDeviceList(this.filePath);

  Future<bool> readFile() async {
    final input = new File(filePath).openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    print(fields);
    for(int i=0;i<fields[0].length;i++){
      if(fields[0][i].toString().trim().toLowerCase()=="devicename"){
        nameIndex=i;
      }
      else if(fields[0][i].toString().trim().toLowerCase()=="macaddress"){
        macIndex=i;
      }
    }
    if(nameIndex==-1||macIndex==-1)
      return false;
    fields.removeAt(0);
    for(var list in fields){
      deviceList[list[nameIndex]]=list[macIndex];
    }
    print(deviceList);
    return true;

  }

}
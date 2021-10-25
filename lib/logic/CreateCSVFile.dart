
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';



class CreateCSVFile{
  var body;
  String params;
  String devicesIds;
  String eventName;

  CreateCSVFile(this.body, this.params, this.devicesIds,this.eventName);

  Future<int> createList() async {
    try {
      List paramsList = await seperateStrings(params);
      List deviIdsList = await seperateStrings(devicesIds);
      print('in the write device history file');
      var deviceLists = [];

      for (var ids in deviIdsList) {
        if(body[ids]!=null) {
          List deviceIdBody = body[ids];
          deviceLists.add(deviceIdBody);
        }
      }

      List<List<dynamic>> fileList = [];

      List<dynamic> header = [];
      header.add("device_id");
      for (var params in paramsList) {
        header.add(params);
        print(params);
      }

      header.add("stateName_s");
      header.add("timestamp_s");
      header.add("time_s");
      header.add("mac_s");

      fileList.add(header);

      for (int i = 0; i < deviceLists.length; i++) {
        for (var rowList in deviceLists[i]) {
          List<dynamic> row = [];
          row.add(deviIdsList[i]);
          for (var params in paramsList) {
            if(rowList[params]!=null) {
              row.add(rowList[params]);
            }else{
              row.add("");
            }
          }
          row.add(rowList["stateName_s"]);
          row.add(rowList["timestamp_s"]);
          row.add(rowList["time_s"]);
          row.add(rowList["mac_s"]);
          fileList.add(row);
          print(row);
        }
      }
      String csv = const ListToCsvConverter().convert(fileList);
      await writeCounter(csv);
      return 0;
    }catch(e){
      throw Exception(e);
    }
    // print(fileList);

  }


  Future<List> seperateStrings(String value) async {
    List<dynamic>  valuesList = value.split(',');
    return valuesList;
  }


  Future<String?> get _localPath async {
    String? result= await FilePicker.platform.saveFile(
        dialogTitle: "Save the File",
    type: FileType.custom,
    allowedExtensions: ['CSV']) ;
    print(result);
    if(result!=null){
      return result;
    }
    else {
      throw Exception();
    }

  }
  Future<File> get _localFile async {
    try {
      final path = await _localPath;
      print("File path " + path.toString());
      return File('$path.csv');
    }catch(_){
      throw Exception('File Not Save');
    }
  }
  Future<File> writeCounter(csv) async {
    try {
      final file = await _localFile;
      // Write the file
      return file.writeAsString('$csv', mode: FileMode.append, flush: true);
    }
    catch(e){
      throw Exception(e);
    }
  }



}


import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';


class CreateExploreIDCSVFile{
  var body;
  String fileName="";

  CreateExploreIDCSVFile(this.body);

  Future<int> createDevicesList() async {
    fileName="DeviceList";
    try{
    List<List<dynamic>> fileList = [];

    List<dynamic> header = [];

    header.add("id");
    header.add("name");
    header.add("macAddress");
    header.add("deviceDefinitionId");
    header.add("brand");
    header.add("type");
    header.add("model");
    header.add("userId");
    header.add("deviceParentId");
    header.add("createdDate");
    header.add("modifiedDate");

    fileList.add(header);

    for(var device in body){

        List<dynamic> row = [];
        row.add(device["id"]);
        row.add(device["name"]);
        row.add(device["macAddress"]);
        row.add(device["deviceDefinitionId"]);
        row.add(device["brand"]);
        row.add(device["type"]);
        row.add(device["model"]);
        row.add(device["userId"]);
        row.add(device["deviceParentId"]);
        row.add(device["createdDate"]);
        row.add(device["modifiedDate"]);

        fileList.add(row);

    }

    String csv = const ListToCsvConverter().convert(fileList);
    await writeCounter(csv);
    return 0;

    }catch(e){
      throw Exception(e);
    }


  }

  Future<int> createSceneList() async {
    fileName="ScenesList";
    try {
      List<List<dynamic>> fileList = [];

      List<dynamic> header = [];

      header.add("id");
      header.add("name");
      header.add("userId");
      header.add("executionInterval");
      header.add("connectedSceneId");
      header.add("type");
      fileList.add(header);

      for (var Scene in body) {
        List<dynamic> row = [];
        row.add(Scene["id"]);
        row.add(Scene["name"]);
        row.add(Scene["userId"]);
        row.add(Scene["connectedSceneId"]);
        row.add(Scene["executionInterval"]);
        row.add(Scene["type"]);
        print("11111");
        if (Scene["type"] == "device") {
          print("before");
          row.add(Scene["device"]["inDeviceId"]);
          print(Scene["device"]["inDeviceId"]);
          row.add(Scene["device"]["eventName"]);
          row.add(Scene["device"]["stateName"]);
          if (Scene["device"]["stateName"] == "none") {
            row.add(Scene["device"]["evaluationValues"]);
          }
          print("2222222");
          addActions(fileList, row, Scene);
        } else if (Scene["type"] == "schedular") {
          row.add(Scene["schedular"]["date"]);
          row.add(Scene["schedular"][ "time"]);
          print("333333");
          addActions(fileList, row, Scene);
        }

        fileList.add(row);
      }

      String csv = const ListToCsvConverter().convert(fileList);
      await writeCounter(csv);
      return 0;
    }catch(e){
      throw Exception(e);
    }
  }

  void addActions(fileList,row,scene){
    for(var action in scene["actions"]) {
      row.add(action["sequence"]);
      row.add(action["action"]);
      print("444444");
      if (action["action"] == "sms") {
        row.add(action["externalServiceData"]["receiverAddress"]);
        row.add(action["externalServiceData"]["message"]);
        print("sms....");

      } else if (action["action"] == "email") {
        row.add(action["externalServiceData"]["subject"]);
        row.add(action["externalServiceData"]["toAddress"]);
        row.add(action["externalServiceData"]["content"]);
        print("email....");

      } else if (action["action"] == "callurl") {
        row.add(action["externalServiceData"]["autherization"]);
        row.add(action["externalServiceData"]["callback"]);
        print("callurl....");
      }
      else if(action["action"] == "device"){
        row.add(action["externalServiceData"]["deviceId"]);
        row.add(action["externalServiceData"]["actionName"]);
        row.add(action["externalServiceData"]["actionParameters"]);
        print("device....");
      }
    }
  }

  Future<int> createDeviceEvents(String deviceId) async {
    fileName="$deviceId-DeviceEvents";
    try {
      List<List<dynamic>> fileList = [];

      List<dynamic> header = [];

      header.add("createdDate");
      header.add("lastModifiedDate");
      header.add("deleted");
      header.add("selection");
      header.add("path");
      header.add("eventName");
      header.add("statusName");
      header.add("syncWithHDMS");

      fileList.add(header);
      for (var event in body) {
        List<dynamic> row = [];
        row.add(event["lastModifiedDate"]);
        row.add(event["deleted"]);
        row.add(event["selection"]);
        row.add(event["path"]);
        row.add(event["eventName"]);
        row.add(event["statusName"]);
        row.add(event["syncWithHDMS"]);
        row.add(event["createdDate"]);

        fileList.add(row);
      }

      String csv = const ListToCsvConverter().convert(fileList);
      await writeCounter(csv);
      return 0;
    }
    catch(e){
      throw Exception(e);
    }

  }
  Future<int> createDeviceActions(String deviceId) async {
    fileName="$deviceId-DeviceActions";
    try {
      List<List<dynamic>> fileList = [];

      List<dynamic> header = [];

      header.add("createdDate");
      header.add("lastModifiedDate");
      header.add("deleted");
      header.add("id");
      header.add("name");
      header.add("displayName");
      header.add("message");
      header.add("statusFlag");
      header.add("visible");

      fileList.add(header);
      for (var event in body) {
        List<dynamic> row = [];
        row.add(event["lastModifiedDate"]);
        row.add(event["deleted"]);
        row.add(event["id"]);
        row.add(event["name"]);
        row.add(event["displayName"]);
        row.add(event["message"]);
        row.add(event["statusFlag"]);
        row.add(event["visible"]);

        fileList.add(row);
      }

      String csv = const ListToCsvConverter().convert(fileList);
      writeCounter(csv);
      return 0;
    }
    catch(e){
      throw Exception(e);
    }

  }

  Future<String?> get _localPath async {

    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save the file',
        type:FileType.custom,
        allowedExtensions: ['CSV']
    );
    return outputFile;

  }
  Future<File> get _localFile async {

    final path = await _localPath;
    print(path);
    if(path==null){
      print("Exception in the local file");
      throw Exception();
    }
    return File('$path.csv');

  }
  Future<File> writeCounter(csv) async {
    try {
      final file = await _localFile;
      // Write the file
      return file.writeAsString('$csv', mode: FileMode.append, flush: true);
    }catch(_){
      throw Exception("File not Saved");
    }
  }

}
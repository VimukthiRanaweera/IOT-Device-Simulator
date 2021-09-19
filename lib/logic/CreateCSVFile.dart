
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


class CreateCSVFile{
  var body;
  String params;
  String devicesIds;
  String eventName;

  CreateCSVFile(this.body, this.params, this.devicesIds,this.eventName);

  void createList(){
    List paramsList =seperateStrings(params);
    List deviIdsList =seperateStrings(devicesIds);

    var deviceLists = [];

    for(var ids in deviIdsList){
      List deviceIdBody = body[ids];
      deviceLists.add(deviceIdBody);
    }

    List<List<dynamic>> fileList = [];

    List<dynamic> header = [];
    header.add("device_id");
    for(var params in paramsList){
      header.add(params);
    }

    header.add("stateName_s");
    header.add("timestamp_s");
    header.add("time_s");
    header.add("mac_s");

    fileList.add(header);

    for(int i=0;i<deviceLists.length;i++){
      for(var rowList in deviceLists[i]){
        List<dynamic> row = [];
        row.add(deviIdsList[i]);
        for(var params in paramsList){
          row.add(rowList[params]);
        }
        row.add(rowList["stateName_s"]);
        row.add(rowList["timestamp_s"]);
        row.add(rowList["time_s"]);
        row.add(rowList["mac_s"]);
        fileList.add(row);
      }

    }
    String csv = const ListToCsvConverter().convert(fileList);
    writeCounter(csv);
    print(fileList);

  }


  List<dynamic> seperateStrings(String value){
    List<dynamic>  valuesList = value.split(',');
    return valuesList;
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    print("File path "+path.toString());
    var inputFormat =  DateFormat("yyyyMMdd-HHmmss");
    String time=inputFormat.format(DateTime.now()).toString();
    return File('$path\\$eventName-$time.csv');
  }
  Future<File> writeCounter(csv) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$csv',mode: FileMode.append, flush: true);
  }



// Future<void> downloadCSV() async {
  //   await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
  //   bool checkPermission = await SimplePermissions.checkPermission(
  //       Permission.WriteExternalStorage);
  //   if (checkPermission) {
  //     String dir = (await getExternalStorageDirectory())!.absolute.path +
  //         "/documents";
  //     var file = "$dir";
  //     print(" FILE " + file);
  //     File f = new File((file + "filename.csv"),);
  // }
  // }
}


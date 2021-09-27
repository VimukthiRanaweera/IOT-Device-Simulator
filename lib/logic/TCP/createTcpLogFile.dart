import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:iot_device_simulator/MODEL/tcpMessages.dart';
import 'package:path_provider/path_provider.dart';

class CreateTcpLogFile{

  late String fileName;
  late String customPath;
  List<TcpMessages> messages=[];


  CreateTcpLogFile(this.fileName, this.messages);

  Future<bool> writeLogFile() async {

    String? result= await FilePicker.platform.getDirectoryPath(dialogTitle: "Save the File") ;
    print(result);
    if(result!=null) {
      customPath = result;
      writeMessage();
      return true;
    }
    else
      return false;

  }

  Future<String> get _localPath async {
    if(customPath.isNotEmpty){
          return customPath;
    }
    else{
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }

  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path\\$fileName.csv',);
  }

  Future<File> writeMessage() async {
    final file = await _localFile;

    List<List<dynamic>> fileList = [];

    for(var item in messages){
      List<dynamic> row = [];
      var inputFormat =  DateFormat("yyyy-MM-dd HH:mm:ss");
      String time=inputFormat.format(DateTime.now()).toString();
      row.add(time);
      row.add(item.message);
      row.add(item.response);
      fileList.add(row);
    }

    String csv = const ListToCsvConverter().convert(fileList);
    // Write the file
    return file.writeAsString('$csv\n',mode: FileMode.append, flush: true);
  }

}
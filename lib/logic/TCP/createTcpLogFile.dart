import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:iot_device_simulator/MODEL/tcpMessages.dart';

class CreateTcpLogFile{

  late String customPath;
  List<TcpMessages> messages=[];


  CreateTcpLogFile(this.messages);

  Future<bool> writeLogFile() async {

    String? result= await FilePicker.platform.saveFile(
        dialogTitle: "Save the File",
        type: FileType.custom,
        allowedExtensions:["CSV"],
    ) ;
    print(result);
    if(result!=null) {
      customPath = result;
      writeMessage();
      return true;
    }
    else
      return false;

  }


  Future<File> get _localFile async {
    final path = customPath;
    return File('$path.csv',);
  }

  Future<File> writeMessage() async {
    final file = await _localFile;

    List<List<dynamic>> fileList = [];
    List<dynamic> header = [];
    header.add("Timestamp");
    header.add("Message");
    header.add("Response");
    fileList.add(header);

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
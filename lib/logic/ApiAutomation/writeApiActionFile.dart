
import 'dart:io';
import 'package:csv/csv.dart';



class WriteApiActionFile{
  late bool isCheckLogWrite;
  late String fileName;
  late String filePath;

  WriteApiActionFile(this.isCheckLogWrite);

  void writeActionResponse(String message,String time,String body,String path){
    if(isCheckLogWrite){
      print("Print Action file");
      filePath= path;
      writeMessage(time,body,message);

    }
  }


  Future<File> get _localFile async {
    final path = filePath;
    return File('$path.csv',);
  }

  Future<File> writeMessage(time,body,message,) async {
    final file = await _localFile;

    List<List<dynamic>> fileList = [];
    List<dynamic> header = [];
    header.add("Timestamp");
    header.add("Action");
    header.add("Response");
    fileList.add(header);
    List<dynamic> row = [];
    row.add(time);
    row.add(body);
    row.add(message);
    fileList.add(row);
    String csv = const ListToCsvConverter().convert(fileList);
    // Write the file
    return file.writeAsString('$csv\n',mode: FileMode.append, flush: true);
  }

}
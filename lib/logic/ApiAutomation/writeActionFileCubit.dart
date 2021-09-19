

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class WriteActionFileCubit extends Cubit<WriteActionFileState>{
  WriteActionFileCubit() : super(WriteActionFileState(false));

}



class WriteActionFileState{
  late bool isCheckLogWrite;
  late String fileName;

  WriteActionFileState(this.isCheckLogWrite);

  void writeActionResponse(String message,String name,String time,String body){
    if(isCheckLogWrite){
      print("Print Action file");
      fileName = name;
      writeMessage(time,body,message);

    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path\\$fileName.csv',);
  }

  Future<File> writeMessage(time,body,message,) async {
    final file = await _localFile;

    List<List<dynamic>> fileList = [];
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
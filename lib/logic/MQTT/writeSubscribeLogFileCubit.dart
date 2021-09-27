
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class WriteSubscribeLogFileCubit extends Cubit<WriteSubscribeLogFileState>{
  WriteSubscribeLogFileCubit() : super(WriteSubscribeLogFileState(false,""));

  // void setResponse() =>emit(WriteSubscribeLogFileState(state.isLogWrite,state.filePath));

}

class WriteSubscribeLogFileState{
  late bool isLogWrite;
  late String filename;
  late String response;
  late String filePath;
  WriteSubscribeLogFileState(this.isLogWrite,this.filePath);

  Future<void> writeLogMessage(String message,String responseMsg,String time,String name) async {
    if(isLogWrite){
      filename = name;
      response=responseMsg;
     await writeMessage(message,time);

    }
  }

  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();

    return filePath;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename.csv',);
  }

  Future<File> writeMessage(message,time) async {
    final file = await _localFile;
    // Write the file
    List<List<dynamic>> fileList = [];
    List<dynamic> row = [];
    row.add(time);
    row.add(message);
    row.add(response);

    fileList.add(row);

    String csv = const ListToCsvConverter().convert(fileList);
    return file.writeAsString('$csv\n',mode: FileMode.append, flush: true);
  }
}
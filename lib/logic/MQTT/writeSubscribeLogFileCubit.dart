
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';

class WriteSubscribeLogFileCubit extends Cubit<WriteSubscribeLogFileState>{
  WriteSubscribeLogFileCubit() : super(WriteSubscribeLogFileState(false,""));

  void setResponse(isCheck,response) =>emit(WriteSubscribeLogFileState(isCheck,response));

}

class WriteSubscribeLogFileState{
  late bool isLogWrite;
  late String filename;
  late String response;
  WriteSubscribeLogFileState(this.isLogWrite,this.response);

  Future<void> writeLogMessage(String message,String time,String name) async {
    if(isLogWrite){
      filename = name;
     await writeMessage(message,time);

    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename.txt',);
  }

  Future<File> writeMessage(message,time) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$time $message $response\n',mode: FileMode.append, flush: true);
  }
}
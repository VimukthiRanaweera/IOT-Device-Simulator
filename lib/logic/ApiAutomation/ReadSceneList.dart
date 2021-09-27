

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

class ReadSceneList{
  late String filePath;
  var sceneBody = new Map();
  ReadSceneList(this.filePath);

  Future<dynamic> readFile() async {
    final input = new File(filePath).openRead();
    final fields = await input.transform(utf8.decoder).transform(
        new CsvToListConverter()).toList();
    return fields;
  }


}
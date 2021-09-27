import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';

class ApiAutomateEvents extends Equatable{
  @override
  List<Object?> get props => [];

}
class ClearButtonClickedEvent extends ApiAutomateEvents{}
class EventExportButtonClickedEvent extends ApiAutomateEvents{
  late final String xSecret;
  late final String username;
  late final String password;
  late final String eventName;
  late final String deviceIds;
  late final String startDate;
  late final String endDate;
  late final String zoneId;
  late final String eventParms;
  late final String noOfEvents;


  EventExportButtonClickedEvent({
      required this.xSecret,
      required this.username,
      required this.password,
      required this.eventName,
      required this.deviceIds,
      required this.startDate,
      required this.endDate,
      required this.zoneId,
      required this.eventParms,
      required this.noOfEvents});

  List<Object?> get props => [xSecret];

}
class ActionExportButtonClickedEvent extends ApiAutomateEvents{
  late final String xSecret;
  late final String username;
  late final String password;
  late final String actionName;
  late final String deviceId;
  late final int noOfActions;
  late final int time;
  late final List<ApiParaControllers> paraList;
  late final bool isLogWrite;
  late final String filePath;


  ActionExportButtonClickedEvent(this.xSecret, this.username, this.password,
      this.actionName, this.deviceId, this.noOfActions,this.time, this.paraList,this.isLogWrite,this.filePath);

  List<Object?> get props => [
    xSecret,
    username,
    password,
    actionName,
    noOfActions,
    paraList,
    time,
    filePath
  ];

}
class CreateDeviceEvent extends ApiAutomateEvents{
  late final String xSecret;
  late final String username;
  late final String password;
  late final int deviceDefinitionId;
  late final String brand;
  late final String type;
  late final String model;
  late final String deviceCategory;
  late final int deviceParentId;
  late final String zoneId;
  late final String filePath;

  CreateDeviceEvent({
      required this.xSecret,
      required this.username,
      required this.password,
      required this.deviceDefinitionId,
      required this.brand,
      required this.type,
      required this.model,
      required this.deviceCategory,
      required this.deviceParentId,
    required this.zoneId,
      required this.filePath});

  List<Object?> get props => [
    xSecret,
    username,
    password,
    deviceDefinitionId,
    deviceCategory,
    brand,
    type,
    model,
    deviceParentId,
    filePath

  ];

}

class ApiAddSceneEvent extends ApiAutomateEvents{
  late final String xSecret;
  late final String username;
  late final String password;
  late final String filePath;


  ApiAddSceneEvent(this.xSecret, this.username, this.password, this.filePath);

  List<Object?> get props => [
    username,
    password,
    xSecret,
    filePath
  ];
}
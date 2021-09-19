import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';

class ApiAutomateEvents extends Equatable{
  @override
  List<Object?> get props => [];

}

class ExportButtonClickedEvent extends ApiAutomateEvents{
  late final String xSecret;
  late final String username;
  late final String password;
  late final String eventName;
  late final String deviceIds;
  late final String startDate;
  late final String endDate;
  late final String zoneId;
  late final String eventParms;
  late final int noOfEvents;


  ExportButtonClickedEvent({
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

}class ActionExportButtonClickedEvent extends ApiAutomateEvents{
  late final String xSecret;
  late final String username;
  late final String password;
  late final String actionName;
  late final String deviceId;
  late final int noOfActions;
  late final int time;
  late final List<ApiParaControllers> paraList;
  late final bool isLogWrite;


  ActionExportButtonClickedEvent(this.xSecret, this.username, this.password,
      this.actionName, this.deviceId, this.noOfActions,this.time, this.paraList,this.isLogWrite);

  List<Object?> get props => [
    xSecret,
    username,
    password,
    actionName,
    noOfActions,
    paraList,
    time,
  ];

}
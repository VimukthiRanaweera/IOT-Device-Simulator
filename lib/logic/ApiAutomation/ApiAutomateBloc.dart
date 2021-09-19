import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateRepo.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/writeActionFileCubit.dart';
import 'package:iot_device_simulator/logic/CreateCSVFile.dart';
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';


class ApiAutomateBloc extends Bloc<ApiAutomateEvents,ApiAutomateState>{
  ApiAutomateBloc(this.apiAutomateRepo) : super(ExportButtonNotClickedState());
ApiAutomateRepo apiAutomateRepo;
  @override
  Stream<ApiAutomateState> mapEventToState(ApiAutomateEvents event) async*{

    if(event is ExportButtonClickedEvent){
      yield ApiCallingState();
      try {
        var responseAPIJason = await apiAutomateRepo.apiManagement(event.xSecret);
       var responseUserJason = await apiAutomateRepo.userManagemnet(event.username,event.password, responseAPIJason["token_type"], responseAPIJason["access_token"]);
       var finalResponseJson = await apiAutomateRepo.deviceHistory(tokenType: responseAPIJason["token_type"],accessToken:responseAPIJason["access_token"],XIotJwt: responseUserJason["X-IoT-JWT"],
       deviceIds: event.deviceIds,eventName: event.eventName,startDate: event.startDate,endDate: event.endDate,noOfEvents: event.noOfEvents,zoneId: event.zoneId,
       params: event.eventParms);

       CreateCSVFile createCSVFile = new CreateCSVFile(finalResponseJson, event.eventParms, event.deviceIds,event.eventName);
       createCSVFile.createList();
       yield ApiCallSuccessState();
      }
      catch(e){
        yield NotConnectedState();
        print(e);
      }
      finally{
        ExportButtonNotClickedState();
      }
    }

    if(event is ActionExportButtonClickedEvent){
      String messageRes="";
      try {
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);
        print(responseUserJason);
        for (int i = 0; i < event.noOfActions; i++) {
          await Future.delayed(Duration(seconds: event.time), () async{
            List<ApiParaControllers> parameterList=[new ApiParaControllers()];
            for(int i=0;i<event.paraList.length;i++) {
              RandomDataState randomData = RandomDataState(dataString:event.paraList[i].value.text);
              randomData.setData();
              parameterList[i].para.text=event.paraList[i].para.text;
              parameterList[i].value.text=randomData.dataString;
              print("${parameterList[i].para.text}: ${parameterList[i].value.text}");
            }
            var responseAction= await apiAutomateRepo.executeAction(
                tokenType: responseAPIJason["token_type"],
                accessToken: responseAPIJason["access_token"],
                XIotJwt: responseUserJason["X-IoT-JWT"],
                deviceId: int.parse(event.deviceId),
                actionName: event.actionName,
                userID: responseUserJason["data"]["userId"], paramList:parameterList);
               print(responseAction);
               messageRes=responseAction;

            WriteActionFileState writeActionFileState=WriteActionFileState(event.isLogWrite);
            var inputFormat =  DateFormat("yyyy-MM-dd HH:mm:ss");

           String body = json.encode({
              "operation": "deviceControl",
              "deviceId": event.deviceId,
              "actionName": event.actionName,
              "userId": responseUserJason["data"]["userId"],
              "actionParameters": {
                for(var item in parameterList)
                  "${item.para.text}": "${item.value.text}"
              }
            });
            writeActionFileState.writeActionResponse(responseAction.toString(),event.deviceId.toString(),inputFormat.format(DateTime.now()).toString(),body);

          });
          yield ApiActionSuccessState(messageRes);
        }

      }catch(e){
        yield NotConnectedState();
        print(e);
      }
      finally{
        ExportButtonNotClickedState();
      }
    }

  }

}
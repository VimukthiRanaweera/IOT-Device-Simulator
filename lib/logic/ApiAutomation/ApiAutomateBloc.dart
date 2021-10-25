import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:iot_device_simulator/MODEL/apiParaControllers.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateRepo.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/CreateApiSceneBody.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/CreateExploreIDCSVFile.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ReadDeviceList.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/writeApiActionFile.dart';
import 'package:iot_device_simulator/logic/CreateCSVFile.dart';
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';

import 'ReadSceneList.dart';


class ApiAutomateBloc extends Bloc<ApiAutomateEvents,ApiAutomateState>{
  ApiAutomateBloc(this.apiAutomateRepo) : super(ExportButtonNotClickedState());
ApiAutomateRepo apiAutomateRepo;
  @override
  Stream<ApiAutomateState> mapEventToState(ApiAutomateEvents event) async* {
    if (event is ClearButtonClickedEvent) {
      yield ExportButtonNotClickedState();
    }

    if (event is EventExportButtonClickedEvent) {
      yield ApiCallingState();
      try {
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);
        print("in the bloc>>>> $responseUserJason");
        var finalResponseJson = await apiAutomateRepo.deviceHistory(
            tokenType: responseAPIJason["token_type"],
            accessToken: responseAPIJason["access_token"],
            XIotJwt: responseUserJason["X-IoT-JWT"],
            deviceIds: event.deviceIds,
            eventName: event.eventName,
            startDate: event.startDate,
            endDate: event.endDate,
            noOfEvents: event.noOfEvents,
            zoneId: event.zoneId,
            params: event.eventParms);

        CreateCSVFile createCSVFile = new CreateCSVFile(
            finalResponseJson, event.eventParms, event.deviceIds,
            event.eventName);
        await createCSVFile.createList();
        yield ApiCallSuccessState();
      }
      catch (e) {
        yield ApiEventErrorState(e.toString().replaceAll("Exception:", ""));
        print(e);
      }
      finally {
        ExportButtonNotClickedState();
      }
    }

    //Execute Action
    if (event is ActionExportButtonClickedEvent) {
      String messageRes = "";
      try {
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);
        print(responseUserJason);
        for (int i = 0; i < event.noOfActions; i++) {
          await Future.delayed(Duration(seconds: event.time), () async {
            List<ApiParaControllers> parameterList = [new ApiParaControllers()];
            for (int i = 0; i < event.paraList.length; i++) {

              RandomDataState randomData = RandomDataState(
                  dataString: event.paraList[i].value.text);
              randomData.setData();
              parameterList[i].para.text = event.paraList[i].para.text;
              parameterList[i].value.text = randomData.dataString;
              print("${parameterList[i].para.text}: ${parameterList[i].value
                  .text}");
            }
            var responseAction = await apiAutomateRepo.executeAction(
                tokenType: responseAPIJason["token_type"],
                accessToken: responseAPIJason["access_token"],
                XIotJwt: responseUserJason["X-IoT-JWT"],
                deviceId: int.parse(event.deviceId),
                actionName: event.actionName,
                userID: responseUserJason["data"]["userId"],
                paramList: parameterList);
            print(responseAction);
            messageRes = responseAction;

            if (event.isLogWrite) {
              WriteApiActionFile writeApiActionFile = WriteApiActionFile(
                  event.isLogWrite);
              var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

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
              writeApiActionFile.writeActionResponse(
                  responseAction.toString(),
                  inputFormat.format(DateTime.now()).toString(), body,
                  event.filePath);
            }
          });
          yield ApiActionSuccessState(messageRes);
        }
      } catch (e) {
        yield NotConnectedState();
        print(e);
      }
      finally {
        ExportButtonNotClickedState();
      }
    }

    if (event is CreateDeviceEvent) {
      List notCreateDeviceList = [];
      try {
        ReadDeviceList readDeviceList = ReadDeviceList(event.filePath);
        bool checkFile = await readDeviceList.readFile();
        if (!checkFile) {
          throw Exception("Incorrect CSV File Header");
        }
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);
        // print(responseUserJason);
        for (var device in readDeviceList.deviceList.keys) {
          print(device);
          print(readDeviceList.deviceList[device].toString());
          var responseCreateDevice = await apiAutomateRepo.createDevice(
              tokenType: responseAPIJason["token_type"],
              accessToken: responseAPIJason["access_token"],
              XIotJwt: responseUserJason["X-IoT-JWT"],
              deviceDefinitionId: event.deviceDefinitionId,
              brand: event.brand,
              type: event.type,
              userId: responseUserJason["data"]["userId"],
              deviceParentId: event.deviceParentId,
              macAddress: readDeviceList.deviceList[device].toString(),
              name: device.toString(),
              zoneId: event.zoneId);

          if (responseCreateDevice["macAddress"] ==
              readDeviceList.deviceList[device].toString()) {
            print("Device $device Successfully created");
          }
          else if (responseCreateDevice["errorCode"] == 1000) {
            if (responseCreateDevice["desc"] ==
                "Device with same Mac/SN address already in use") {
              print(" Device with same Mac/SN address already in use");
              notCreateDeviceList.add(readDeviceList.deviceList[device]);
            }
            else {
              throw Exception(responseCreateDevice["desc"]);
            }
          }
          else if (responseCreateDevice["errorCode"] == 1001) {
            throw Exception("Incorrect Parent Device ID");
          }
          else {
            throw Exception(responseCreateDevice["desc"]);
          }
        }

        if (notCreateDeviceList.length == readDeviceList.deviceList.length) {
          throw Exception("All Mac address already in use");
        }
        else {
          yield ApiDeviceCreateSuccessState();
          yield ApiDeviceCreateMessageState(
              notCreateDeviceList, readDeviceList.deviceList.length);
        }
      } catch (e) {
        yield ApiErrorState(e.toString().replaceAll("Exception:", ""));
      }
    }
  // Add scenes
    if (event is ApiAddSceneEvent) {
      try {
        List notCreateScenesList = [];
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);
        print(event.filePath);
        ReadSceneList read = ReadSceneList(event.filePath);
        var sceneList = await read.readFile();
        print(">>>>>>>>>>>>>>>>>>");
        print(sceneList);
        print(sceneList.length);

        for (var scene in sceneList) {
          print(scene[0]);
          CreateApiSceneBody apiSceneBody = CreateApiSceneBody();
          bool checkBody = apiSceneBody.createBody(
              scene, responseUserJason["data"]["userId"]);
          print("create body");
          print(json.encode(apiSceneBody.sceneBody));
          if (checkBody) {
            var responseCreateScene = await apiAutomateRepo.createScene(
                tokenType: responseAPIJason["token_type"],
                accessToken: responseAPIJason["access_token"],
                XIotJwt: responseUserJason["X-IoT-JWT"],
                body: apiSceneBody.sceneBody);

            if (!responseCreateScene) {
              notCreateScenesList.add(scene[0]);
            }
          }
          else {
            notCreateScenesList.add(scene[0]);
          }
        }
        if (sceneList.length == notCreateScenesList.length) {
          throw("Invalid CSV File");
        } else {
          yield ApiSceneCreatedState();
          yield ApiSceneCreateMessageState(
              notCreateScenesList, sceneList.length);
        }
      } catch (e) {
        yield ApiSceneErrorState(e.toString().replaceAll("Exception:", ""));
        print(e.toString());
      }
    }

    //Explore Ids
      //Get Devices
    if (event is ApiGetDevicesEvent) {
      try {
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);
        var responseDevices = await apiAutomateRepo.getDevices(
            tokenType: responseAPIJason["token_type"],
            accessToken: responseAPIJason["access_token"],
            XIotJwt: responseUserJason["X-IoT-JWT"]);
        print(responseDevices);
        yield ApiExploreIdsSuccessed();
        CreateExploreIDCSVFile idCsvFile = CreateExploreIDCSVFile(
            responseDevices);
       await idCsvFile.createDevicesList();
      } catch (e) {
        yield ApiExploreIDsErrorState(
            e.toString().replaceAll("Exception:", ""));
      }
    }
    //Get Scenes
    if (event is ApiGetScenesEvent) {
      try {
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);

        var responseScenes = await apiAutomateRepo.getScenes(
            tokenType: responseAPIJason["token_type"],
            accessToken: responseAPIJason["access_token"],
            XIotJwt: responseUserJason["X-IoT-JWT"]);
        // print(responseScenes);
        CreateExploreIDCSVFile idCsvFile = CreateExploreIDCSVFile(
            responseScenes);
       await idCsvFile.createSceneList();
        yield ApiExploreIdsSuccessed();
      } catch (e) {
        yield ApiExploreIDsErrorState(
            e.toString().replaceAll("Exception:", ""));
      }
    }

    //Get Device Events
    if (event is ApiGetDeviceEventsEvent) {
      try {
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);

        var responseScenes = await apiAutomateRepo.getEvents(
            tokenType: responseAPIJason["token_type"],
            accessToken: responseAPIJason["access_token"],
            XIotJwt: responseUserJason["X-IoT-JWT"], deviceId: event.deviceId);
        print(responseScenes);
        CreateExploreIDCSVFile idCsvFile = CreateExploreIDCSVFile(
            responseScenes);
        await idCsvFile.createDeviceEvents(event.deviceId);
        yield ApiExploreIdsSuccessed();
      }
      on DeferredLoadException{
        yield ApiExploreIDsErrorState("Invalid Device ID: ${event.deviceId}");

      }
      catch (e) {
        if(e.toString().replaceAll("Exception:", "").trim() =="type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'Iterable<dynamic>'"){

          yield ApiExploreIDsErrorState("Invalid Device ID: ${event.deviceId}");
        }
        else {
          yield ApiExploreIDsErrorState(
              e.toString().replaceAll("Exception:", ""));
        }
      }
    }

    //Get Devices Actions
    if (event is ApiGetDeviceActionsEvent) {
      try {
        yield ApiCallingState();
        var responseAPIJason = await apiAutomateRepo.apiManagement(
            event.xSecret);
        var responseUserJason = await apiAutomateRepo.userManagemnet(
            event.username, event.password, responseAPIJason["token_type"],
            responseAPIJason["access_token"]);

        var responseScenes = await apiAutomateRepo.getActions(
            tokenType: responseAPIJason["token_type"],
            accessToken: responseAPIJason["access_token"],
            XIotJwt: responseUserJason["X-IoT-JWT"], deviceId: event.deviceId);
        print(responseScenes);
        CreateExploreIDCSVFile idCsvFile = CreateExploreIDCSVFile(
            responseScenes);
       await idCsvFile.createDeviceActions(event.deviceId);

        yield ApiExploreIdsSuccessed();
      }
      catch (e) {
        if(e.toString().replaceAll("Exception:", "").trim() =="type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'Iterable<dynamic>'"){

          yield ApiExploreIDsErrorState("Invalid Device ID: ${event.deviceId}");
        }
        else {
          yield ApiExploreIDsErrorState(
              e.toString().replaceAll("Exception:", ""));
        }
      }
    }
  }

}
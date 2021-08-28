import 'package:bloc/bloc.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateRepo.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiAutomateState.dart';
import 'package:iot_device_simulator/logic/ApiAutomation/ApiautomateEvents.dart';
import 'package:iot_device_simulator/logic/CreateCSVFile.dart';

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

       CreateCSVFile createCSVFile = new CreateCSVFile(finalResponseJson, event.eventParms, event.deviceIds);
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
  }

}
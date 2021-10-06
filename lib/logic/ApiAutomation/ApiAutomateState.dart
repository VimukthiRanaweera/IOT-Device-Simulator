import 'package:equatable/equatable.dart';

class ApiAutomateState extends Equatable{
  @override
  List<Object?> get props => [];

}
class ExportButtonNotClickedState extends ApiAutomateState{}

class ApiCallingState extends ApiAutomateState{}

// class ApiDeviceCallingState extends ApiAutomateState{}
// class ApiDeviceSuccessState extends ApiAutomateState{}

class ApiCallSuccessState extends ApiAutomateState{}



class ApiActionSuccessState extends ApiAutomateState{
  late final String message;

  ApiActionSuccessState(this.message);
}

class ApiDeviceCreateSuccessState extends ApiAutomateState{

  ApiDeviceCreateSuccessState();
}

class ApiErrorState extends ApiAutomateState{
  late final String error;

  ApiErrorState(this.error);

  List<Object?> get props => [
    error
  ];
}
class ApiEventErrorState extends ApiAutomateState{
  late final String error;

  ApiEventErrorState(this.error);

  List<Object?> get props => [
    error
  ];
}

class NotConnectedState extends ApiAutomateState{}

class ApiDeviceCreateMessageState extends ApiAutomateState{
  late final notCreateDeviceList;
  late final int noOfDevices;

  ApiDeviceCreateMessageState(this.notCreateDeviceList, this.noOfDevices);

  List<Object?> get props => [
   notCreateDeviceList, noOfDevices
  ];
}
class ApiSceneCreateMessageState extends ApiAutomateState{
  late final notCreateSceneList;
  late final int noOfScene;

  ApiSceneCreateMessageState(this.notCreateSceneList, this.noOfScene);

  List<Object?> get props => [
   notCreateSceneList, noOfScene
  ];
}
class ApiSceneCreatedState extends ApiAutomateState{}

class ApiSceneErrorState extends ApiAutomateState{
  late final String error;

  ApiSceneErrorState(this.error);

  List<Object?> get props => [
  error
  ];
}
class ApiExploreIdsSuccessed extends ApiAutomateState{}
class ApiExploreIDsErrorState extends ApiAutomateState{
  late final String error;

  ApiExploreIDsErrorState(this.error);

  List<Object?> get props => [
  error
  ];
}
class ApiGetSceneSuccssed extends ApiAutomateState{}






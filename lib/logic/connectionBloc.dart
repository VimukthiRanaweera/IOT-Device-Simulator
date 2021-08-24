import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';

class ConnetionBloc extends Bloc<ConnectionEvents,ConsState>{
  ConnetionBloc(HiveConObject con) : super(ConnectionNotSelectedState(con)){
    consBox=Hive.box<HiveConObject>(ConnectionsBoxName);
  }
  late Box<HiveConObject> consBox;
  @override
  Stream<ConsState> mapEventToState(ConnectionEvents event) async* {

    if(event is ConnectionSaveEvent){
      consBox.put(event.connectionModel.connectionName,event.connectionModel);
      yield SaveConnectionState(event.connectionModel);
      yield ConnectionSelectedState(event.connectionModel);
    }
    if(event is SelectConnectionEvent){
      if(event.connection.protocol=="HTTP")
        yield ConsState.setDetails(event.connection);
      else
      yield ConnectionSelectedState(event.connection);
    }
    if(event is ClickedSettingEvent){
      yield SetConnectionDetailsState.setDetails(event.connection);
    }
    if( event is CreateNewConnetionEvent){
      yield ClickedNewConnectionState(event.connection);
    }
    if(event is DeleteConnectionEvent){
      consBox.delete(event.key);
      if(event.key==event.connection.connectionName)
        yield ConnectionDeleteState(new HiveConObject("", "", "","", 0, "","", 0));
      else
        yield ConnectionDeleteState(event.connection);
    }
  }

}
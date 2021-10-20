import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/constants/constants.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/connectionEvents.dart';
import 'package:iot_device_simulator/logic/connectionsState.dart';

class ConnetionBloc extends Bloc<ConnectionEvents, ConsState> {
  ConnetionBloc(HiveConObject con) : super(ConnectionNotSelectedState(con)) {
    consBox = Hive.box<HiveConObject>(ConnectionsBoxName);
  }

  late Box<HiveConObject> consBox;

  @override
  Stream<ConsState> mapEventToState(ConnectionEvents event) async* {
    if (event is ConnectionSaveEvent) {
      consBox.put(event.connectionModel.connectionName, event.connectionModel);
      yield SaveConnectionState(event.connectionModel);
      if (event.connectionModel.protocol == HTTP)
        yield SetHttpConnectionDetails.setHttpDetails(event.connectionModel);
      else if (event.connectionModel.protocol == TCP)
        yield SetTcpConnectionDetails.setTcpDetails(event.connectionModel);
      else if(event.connectionModel.protocol==CoAP)
        yield SetCoapConnectionDetails.setCoapDetails(event.connectionModel);
      else
      yield ConnectionSelectedState(event.connectionModel);
    }
    if (event is SelectConnectionEvent) {
      if (event.connection.protocol == HTTP)
        yield SetHttpConnectionDetails.setHttpDetails(event.connection);
      else if (event.connection.protocol == TCP)
        yield SetTcpConnectionDetails.setTcpDetails(event.connection);
      else if (event.connection.protocol == MQTT)
        yield ConnectionSelectedState(event.connection);
      else if(event.connection.protocol == CoAP)
        yield SetCoapConnectionDetails.setCoapDetails(event.connection);
    }
    if (event is ClickedSettingEvent) {
      if (event.connection.protocol == MQTT) {
        yield SetMqttConnectionDetailsState.setMqttDetails(event.connection);
      }
    }
    if (event is CreateNewConnetionEvent) {
      yield ClickedNewConnectionState(event.connection);
    }
    if (event is DeleteConnectionEvent) {
      consBox.delete(event.key);
      if (event.key == event.connection.connectionName)
        yield ConnectionDeleteState(
            new HiveConObject("", "", "", "", 0, "", "", 60));
      else {
        yield ConnectionDeleteState(event.connection);
        if (event.connection.protocol == HTTP)
          yield SetHttpConnectionDetails.setHttpDetails(event.connection);
        else if (event.connection.protocol == TCP)
          yield SetTcpConnectionDetails.setTcpDetails(event.connection);
        else if (event.connection.protocol == CoAP)
          yield SetCoapConnectionDetails.setCoapDetails(event.connection);
        else
          yield ConnectionSelectedState(event.connection);
      }
    }
  }
}

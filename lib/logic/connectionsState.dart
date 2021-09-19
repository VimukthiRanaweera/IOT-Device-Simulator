import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';

class ConsState extends Equatable{
  late final HiveConObject superConModel;
  final TextEditingController formMqttConnectionName = new TextEditingController();
  final TextEditingController formConnectionID = new TextEditingController();
  final TextEditingController formBrokerAddress = new TextEditingController();
  final  TextEditingController formPort = new TextEditingController();
  final TextEditingController formUserName = new TextEditingController();
  final TextEditingController formPassword= new TextEditingController();

  final TextEditingController formHttpConnectionName = new TextEditingController();
  final TextEditingController formHttpAddress = new TextEditingController();

  final TextEditingController formTcpProfileName = new TextEditingController();
  final TextEditingController formTcpHostAddress = new TextEditingController();
  final TextEditingController formTcpHostPort = new TextEditingController();


  ConsState(this.superConModel);

  ConsState.setMqttDetails(this.superConModel){
    formMqttConnectionName.text = superConModel.connectionName;
    formBrokerAddress.text = superConModel.brokerAddress;
    formPort.text = superConModel.port.toString();
    formUserName.text = superConModel.username;
    formPassword.text = superConModel.password;
    formConnectionID.text = superConModel.connectionID;
  }
  
  ConsState.setHttpDetails(this.superConModel){
   formHttpConnectionName.text = superConModel.connectionName;
   formHttpAddress.text = superConModel.brokerAddress;
  }


  ConsState.setTcpDetails(this.superConModel){
    formTcpProfileName.text = superConModel.connectionName;
    formTcpHostAddress.text = superConModel.brokerAddress;
    formTcpHostPort.text = superConModel.port.toString();
  }

  ConsState.newConnection();

  @override
  List<Object?> get props => [
    superConModel
  ];

}

class ConnectionNotSelectedState extends ConsState{
  ConnectionNotSelectedState(HiveConObject superConModel) : super(superConModel);
}


class ConnectionSelectedState extends ConsState{
  ConnectionSelectedState(HiveConObject superConModel) : super(superConModel);

}

class SetMqttConnectionDetailsState extends ConsState{
  SetMqttConnectionDetailsState.setMqttDetails(HiveConObject superConModel) : super.setMqttDetails(superConModel);

}

class SetHttpConnectionDetails extends ConsState{
  SetHttpConnectionDetails.setHttpDetails(HiveConObject superConModel) : super.setHttpDetails(superConModel);

}

class SetTcpConnectionDetails extends ConsState{
  SetTcpConnectionDetails.setTcpDetails(HiveConObject superConModel) : super.setTcpDetails(superConModel);

}

class ClickedNewConnectionState extends ConsState{
  ClickedNewConnectionState(HiveConObject superConModel) : super(superConModel);

}

class SaveConnectionState extends ConsState{
  SaveConnectionState(HiveConObject superConModel) : super(superConModel);
}

class ConnectionDeleteState extends ConsState{
  ConnectionDeleteState(HiveConObject superConModel) : super(superConModel);

}

class SelectedConnectionDeleteState extends ConsState{
  SelectedConnectionDeleteState(HiveConObject superConModel) : super(superConModel);

}
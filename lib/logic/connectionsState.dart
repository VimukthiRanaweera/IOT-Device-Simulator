import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_device_simulator/MODEL/ConnectionModel.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';

class ConsState extends Equatable{
  late final HiveConObject superConModel;
  final TextEditingController formConnectionName = new TextEditingController();
  final TextEditingController formConnectionID = new TextEditingController();
  final TextEditingController formBrokerAddress = new TextEditingController();
  final  TextEditingController formPort = new TextEditingController();
  final TextEditingController formUserName = new TextEditingController();
  final TextEditingController formPassword= new TextEditingController();


  ConsState(this.superConModel);

  ConsState.setDetails(this.superConModel){
    formConnectionName.text = superConModel.connectionName;
    formBrokerAddress.text = superConModel.brokerAddress;
    formPort.text = superConModel.port.toString();
    formUserName.text = superConModel.username;
    formPassword.text = superConModel.password;
    formConnectionID.text = superConModel.connectionID;
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

class SetConnectionDetailsState extends ConsState{
  SetConnectionDetailsState.setDetails(HiveConObject superConModel) : super.setDetails(superConModel);


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
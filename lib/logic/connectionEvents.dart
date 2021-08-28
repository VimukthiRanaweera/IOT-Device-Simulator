import 'package:equatable/equatable.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';


class ConnectionEvents extends Equatable{
  @override
  List<Object?> get props => [];
}

class SelectConnectionEvent extends ConnectionEvents{
  late final HiveConObject connection;

  SelectConnectionEvent(this.connection);
  List<Object?> get props => [connection];
}

class ClickedSettingEvent extends ConnectionEvents{
  late final HiveConObject connection;

  ClickedSettingEvent(this.connection);
  List<Object?> get props => [connection];
}

class ConnectionSaveEvent extends ConnectionEvents{
  late final HiveConObject connectionModel;

  ConnectionSaveEvent(this.connectionModel);

  List<Object?> get props => [connectionModel];
}

class CreateNewConnetionEvent extends ConnectionEvents{
  late final HiveConObject connection;

  CreateNewConnetionEvent(this.connection);

  List<Object?> get props => [connection];

}

class DeleteConnectionEvent extends ConnectionEvents{
  late String key;
  late String ConName;
  late final HiveConObject connection;


  DeleteConnectionEvent(this.key, this.ConName, this.connection);

  List<Object?> get props => [connection,key,ConName];
}

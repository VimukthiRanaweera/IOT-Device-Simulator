import 'package:hive/hive.dart';
part 'hiveConObject.g.dart';

@HiveType(typeId: 0)
class HiveConObject{
  @HiveField(0)
  late String protocol;
  @HiveField(1)
  late String connectionName;
  @HiveField(2)
  late String connectionID;
  @HiveField(3)
  late String brokerAddress;
  @HiveField(4)
  late int port;
  @HiveField(5)
  late String username;
  @HiveField(6)
  late String password;
  @HiveField(7)
  late int keepAlive;

  HiveConObject(
       this.protocol,
     this.connectionName,
       this.connectionID,
       this.brokerAddress,
       this.port,
       this.username,
       this.password,
      this.keepAlive);
}
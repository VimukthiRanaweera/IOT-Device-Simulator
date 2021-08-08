// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveConObject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveConObjectAdapter extends TypeAdapter<HiveConObject> {
  @override
  final int typeId = 0;

  @override
  HiveConObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveConObject(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as int,
      fields[5] as String,
      fields[6] as String,
      fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveConObject obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.protocol)
      ..writeByte(1)
      ..write(obj.connectionName)
      ..writeByte(2)
      ..write(obj.connectionID)
      ..writeByte(3)
      ..write(obj.brokerAddress)
      ..writeByte(4)
      ..write(obj.port)
      ..writeByte(5)
      ..write(obj.username)
      ..writeByte(6)
      ..write(obj.password)
      ..writeByte(7)
      ..write(obj.keepAlive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveConObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

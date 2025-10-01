// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_registration_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchRegistrationModelAdapter
    extends TypeAdapter<MatchRegistrationModel> {
  @override
  final int typeId = 2;

  @override
  MatchRegistrationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchRegistrationModel(
      registrationId: fields[0] as String,
      matchId: fields[1] as String,
      userId: fields[2] as String,
      status: fields[3] as int,
      assignedTarget: fields[4] as int?,
      shootingOrder: fields[5] as String?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MatchRegistrationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.registrationId)
      ..writeByte(1)
      ..write(obj.matchId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.assignedTarget)
      ..writeByte(5)
      ..write(obj.shootingOrder)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchRegistrationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

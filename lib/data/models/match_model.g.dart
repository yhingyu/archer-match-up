// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchModelAdapter extends TypeAdapter<MatchModel> {
  @override
  final int typeId = 1;

  @override
  MatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchModel(
      matchId: fields[0] as String,
      creatorId: fields[1] as String,
      title: fields[2] as String,
      maxTargets: fields[3] as int,
      status: fields[4] as int,
      createdAt: fields[5] as DateTime,
      arrowsPerEnd: fields[6] as int,
      totalEnds: fields[7] as int,
      numberOfRounds: fields[8] as int,
      description: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MatchModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.matchId)
      ..writeByte(1)
      ..write(obj.creatorId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.maxTargets)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.arrowsPerEnd)
      ..writeByte(7)
      ..write(obj.totalEnds)
      ..writeByte(8)
      ..write(obj.numberOfRounds)
      ..writeByte(9)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

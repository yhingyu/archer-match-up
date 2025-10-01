// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_score_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchScoreModelAdapter extends TypeAdapter<MatchScoreModel> {
  @override
  final int typeId = 4;

  @override
  MatchScoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchScoreModel(
      scoreId: fields[0] as String,
      matchId: fields[1] as String,
      userId: fields[2] as String,
      totalScore: fields[3] as int,
      currentRound: fields[4] as int,
      currentEnd: fields[5] as int,
      isComplete: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      completedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MatchScoreModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.scoreId)
      ..writeByte(1)
      ..write(obj.matchId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.totalScore)
      ..writeByte(4)
      ..write(obj.currentRound)
      ..writeByte(5)
      ..write(obj.currentEnd)
      ..writeByte(6)
      ..write(obj.isComplete)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchScoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

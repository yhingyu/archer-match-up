// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EndModelAdapter extends TypeAdapter<EndModel> {
  @override
  final int typeId = 3;

  @override
  EndModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EndModel(
      endId: fields[0] as String,
      matchId: fields[1] as String,
      userId: fields[2] as String,
      roundNumber: fields[3] as int,
      endNumber: fields[4] as int,
      arrows: (fields[5] as List).cast<String>(),
      endTotal: fields[6] as int,
      arrowsPerEnd: fields[7] as int,
      createdAt: fields[8] as DateTime,
      completedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EndModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.endId)
      ..writeByte(1)
      ..write(obj.matchId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.roundNumber)
      ..writeByte(4)
      ..write(obj.endNumber)
      ..writeByte(5)
      ..write(obj.arrows)
      ..writeByte(6)
      ..write(obj.endTotal)
      ..writeByte(7)
      ..write(obj.arrowsPerEnd)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

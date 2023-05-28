// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GamesAdapter extends TypeAdapter<Games> {
  @override
  final int typeId = 1;

  @override
  Games read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Games(
      teamA: fields[0] as String,
      teamB: fields[1] as String,
      goalsA: fields[3] as int,
      goalsB: fields[4] as int,
      times: fields[6] as int,
      duration: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Games obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.teamA)
      ..writeByte(1)
      ..write(obj.teamB)
      ..writeByte(3)
      ..write(obj.goalsA)
      ..writeByte(4)
      ..write(obj.goalsB)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.times);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

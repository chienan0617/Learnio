// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trackable.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackableDataAdapter extends TypeAdapter<TrackableData> {
  @override
  final typeId = 48;

  @override
  TrackableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackableData(
      id: (fields[16] as num).toInt(),
      createTime: (fields[17] as num).toInt(),
      lastEditTime: (fields[18] as num).toInt(),
      editTimes: (fields[19] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TrackableData obj) {
    writer
      ..writeByte(4)
      ..writeByte(16)
      ..write(obj.id)
      ..writeByte(17)
      ..write(obj.createTime)
      ..writeByte(18)
      ..write(obj.lastEditTime)
      ..writeByte(19)
      ..write(obj.editTimes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

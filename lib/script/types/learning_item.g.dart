// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearningItemAdapter extends TypeAdapter<LearningItem> {
  @override
  final typeId = 53;

  @override
  LearningItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearningItem(
      id: fields[0] as String,
      title: fields[1] as String,
      summary: fields[2] as String,
      sourceMessageId: fields[3] as String?,
      tags: (fields[4] as List?)?.cast<String>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LearningItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.sourceMessageId)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

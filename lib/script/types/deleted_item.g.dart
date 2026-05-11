// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeletedItemDataAdapter extends TypeAdapter<DeletedItemData> {
  @override
  final typeId = 49;

  @override
  DeletedItemData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeletedItemData(fields[0] as dynamic, fields[1] as DateTime?);
  }

  @override
  void write(BinaryWriter writer, DeletedItemData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.deletionTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeletedItemDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

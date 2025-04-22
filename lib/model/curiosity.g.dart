// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curiosity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CuriosityAdapter extends TypeAdapter<Curiosity> {
  @override
  final int typeId = 0;

  @override
  Curiosity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Curiosity(
      id: fields[0] as String?,
      content: fields[1] as String?,
      isFavorite: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Curiosity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CuriosityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

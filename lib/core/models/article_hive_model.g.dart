// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleHiveModelAdapter extends TypeAdapter<ArticleHiveModel> {
  @override
  final int typeId = 0;

  @override
  ArticleHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      sourceName: fields[3] as String,
      imageUrl: fields[4] as String,
      content: fields[6] as String,
      url: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.sourceName)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.content)
      ..writeByte(7)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

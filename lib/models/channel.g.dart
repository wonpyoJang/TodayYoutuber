// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    name: json['name'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };

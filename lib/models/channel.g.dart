// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    name: json['name'] as String,
    image: json['image'] as String,
    link: json['link'] as String,
    subscribers: json['subscribers'] as String,
    likes: json['likes'] as int,
    isLike: json['isLike'] as bool,
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'link': instance.link,
      'subscribers': instance.subscribers,
      'likes': instance.likes,
      'isLike': instance.isLike,
    };

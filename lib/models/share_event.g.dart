// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareEvent _$ShareEventFromJson(Map<String, dynamic> json) {
  return ShareEvent(
    url: json['url'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    categories: (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShareEventToJson(ShareEvent instance) =>
    <String, dynamic>{
      'url': instance.url,
      'user': instance.user?.toJson(),
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
    };

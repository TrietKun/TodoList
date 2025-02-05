// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      conversation:
          Conversation.fromJson(json['conversation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'status': instance.status,
    };

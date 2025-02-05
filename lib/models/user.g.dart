// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      role: json['role'] as String?,
      friendList: json['friendList'] as List<dynamic>?,
      isMember: json['isMember'] as bool?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'token': instance.token,
      'role': instance.role,
      'friendList': instance.friendList,
      'isMember': instance.isMember,
      'avatar': instance.avatar,
    };

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? token;
  String? role;
  String? avatar;
  List<dynamic>? friendList;
  bool? isMember = false;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
    this.role,
    this.friendList,
    this.isMember,
    this.avatar
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  get state => null;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, token: $token, role: $role}, friendList: $friendList, isMember: $isMember, avatar: $avatar';
  }

  User? copyWith({String? name, String? avatar}) {
    return User(
      id: id,
      name: name,
      email: email,
      password: password,
      token: token,
      role: role,
      friendList: friendList,
      isMember: isMember,
      avatar: avatar
    );
  }
}

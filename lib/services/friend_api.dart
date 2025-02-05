import 'package:todo_list_riverpod/models/friend.dart';
import 'package:todo_list_riverpod/services/api_service.dart';

class FriendApi extends ApiService {
  Future<List<Friend>> getAllFriendByUserId(String id) async {
    final response = await get('friends/$id');
    return (response.data as List).map((e) => Friend.fromJson(e)).toList();
  }

  Future<Friend> addFriend(String userId, String friendId) async {
    final response = await post('friends/addFriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }

  Future<Friend> acceptFriend(String userId, String friendId) async {
    final response = await post('friends/acceptFriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }

  Future<Friend> blockFriend(String userId, String friendId) async {
    final response = await post('friends/blockFriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }

  Future<Friend> unblockFriend(String userId, String friendId) async {
    final response = await post('friends/unblockFriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }

  Future<Friend> rejectFriend(String userId, String friendId) async {
    final response = await post('friends/rejectFriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }

  Future<Friend> unfriend(String userId, String friendId) async {
    final response = await post('friends/unfriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }
}

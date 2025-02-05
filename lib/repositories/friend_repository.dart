import 'package:todo_list_riverpod/models/friend.dart';
import 'package:todo_list_riverpod/services/friend_api.dart';

class FriendRepository {
  final FriendApi _apiService;

  FriendRepository(this._apiService);

  Future<List<Friend>> getAllFriendByUserId(String id) async {
    final response = await _apiService.get('friends/$id');
    return (response.data as List).map((e) => Friend.fromJson(e)).toList();
  }

  Future<Friend> addFriend(String userId, String friendId) async {
    final response = await _apiService.addFriend(userId, friendId);
    return response;
  }

  Future<Friend> acceptFriend(String userId, String friendId) async {
    final response = await _apiService.acceptFriend(userId, friendId);
    return response;
  }

  Future<Friend> blockFriend(String userId, String friendId) async {
    final response = await _apiService.blockFriend(userId, friendId);
    return response;
  }

  Future<Friend> unblockFriend(String userId, String friendId) async {
    final response = await _apiService.unblockFriend(userId, friendId);
    return response;
  }

  Future<Friend> rejectFriend(String userId, String friendId) async {
    final response = await _apiService.post('friends/rejectFriend', {
      "userId": userId,
      "friendId": friendId,
    });
    return Friend.fromJson(response.data);
  }

  Future<Friend> unfriend(String userId, String friendId) async {
    final response = await _apiService.unfriend(userId, friendId);
    return response;
  }
}

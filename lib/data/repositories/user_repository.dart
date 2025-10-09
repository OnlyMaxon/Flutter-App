import '../models/user.dart';
import '../storage/json_storage.dart';

class UserRepository {
  static const String _file = 'users.json';

  Future<User?> getCurrentUser() async {
    final data = await JsonStorage.instance.readJson(_file);
    final id = data['currentUserId'];
    if (id == null) return null;
    final list = (data['users'] as List?) ?? [];
    final match = list.cast<Map>().firstWhere(
          (e) => e['id'] == id,
      orElse: () => {},
    );
    if (match.isEmpty) return null;
    return User.fromJson(Map<String, dynamic>.from(match));
  }

  Future<void> setCurrentUser(User user) async {
    final data = await JsonStorage.instance.readJson(_file);
    final list = (data['users'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final idx = list.indexWhere((e) => e['id'] == user.id);
    if (idx >= 0) {
      list[idx] = user.toJson();
    } else {
      list.add(user.toJson());
    }
    data['users'] = list;
    data['currentUserId'] = user.id;
    await JsonStorage.instance.writeJson(_file, data);
  }

  Future<void> logout() async {
    final data = await JsonStorage.instance.readJson(_file);
    data['currentUserId'] = null;
    await JsonStorage.instance.writeJson(_file, data);
  }
}

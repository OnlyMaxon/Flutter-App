import 'package:uuid/uuid.dart';
import '../models/forum.dart';
import '../storage/json_storage.dart';

class ForumRepository {
  static const String _file = 'forums.json';
  static const _uuid = Uuid();

  Future<List<Forum>> list() async {
    final data = await JsonStorage.instance.readJson(_file);
    final list = (data['forums'] as List?) ?? [];
    return list.map((e) => Forum.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<Forum> create({
    required String title,
    String? description,
    required String ownerId,
    String visibility = 'public',
    List<String> tags = const [],
  }) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('Название форума не может быть пустым');
    }
    final forum = Forum(
      id: 'forum_${_uuid.v4()}',
      title: title.trim(),
      description: description?.trim(),
      ownerId: ownerId,
      visibility: visibility,
      tags: tags,
      createdAt: DateTime.now().toUtc(),
    );

    final data = await JsonStorage.instance.readJson(_file);
    final list = (data['forums'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    list.add(forum.toJson());
    data['forums'] = list;
    await JsonStorage.instance.writeJson(_file, data);
    return forum;
  }
}

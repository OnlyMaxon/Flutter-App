import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../storage/json_storage.dart';

class PostRepository {
  static const String _file = 'posts.json';
  static const _uuid = Uuid();

  Future<List<Post>> list({String? forumId}) async {
    final data = await JsonStorage.instance.readJson(_file);
    final list = (data['posts'] as List?) ?? [];
    final posts = list.map((e) => Post.fromJson(Map<String, dynamic>.from(e))).toList();
    if (forumId != null) {
      return posts.where((p) => p.forumId == forumId).toList();
    }
    return posts;
  }

  Future<Post> create({
    required String title,
    required String content,
    required String authorId,
    String? forumId,
    String visibility = 'public',
  }) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('Заголовок поста не может быть пустым');
    }
    if (content.trim().length < 3) {
      throw ArgumentError('Содержание слишком короткое');
    }

    final post = Post(
      id: 'post_${_uuid.v4()}',
      title: title.trim(),
      content: content.trim(),
      authorId: authorId,
      forumId: forumId,
      visibility: visibility,
      createdAt: DateTime.now().toUtc(),
    );

    final data = await JsonStorage.instance.readJson(_file);
    final list = (data['posts'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    list.add(post.toJson());
    data['posts'] = list;
    await JsonStorage.instance.writeJson(_file, data);
    return post;
  }
}

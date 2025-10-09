class Post {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String? forumId; // null => глобальный пост
  final String visibility; // public | private
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    this.forumId,
    required this.visibility,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> j) => Post(
    id: j['id'],
    title: j['title'],
    content: j['content'],
    authorId: j['authorId'],
    forumId: j['forumId'],
    visibility: j['visibility'],
    createdAt: DateTime.parse(j['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'authorId': authorId,
    'forumId': forumId,
    'visibility': visibility,
    'createdAt': createdAt.toIso8601String(),
  };
}

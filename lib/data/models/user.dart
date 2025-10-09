class User {
  final String id;
  final String username;
  final String? avatarUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'],
    username: j['username'],
    avatarUrl: j['avatarUrl'],
    createdAt: DateTime.parse(j['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'avatarUrl': avatarUrl,
    'createdAt': createdAt.toIso8601String(),
  };
}

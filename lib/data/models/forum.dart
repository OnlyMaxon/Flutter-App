class Forum {
  final String id;
  final String title;
  final String? description;
  final String ownerId;
  final String visibility; // public | private
  final List<String> tags;
  final DateTime createdAt;

  Forum({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    required this.visibility,
    required this.tags,
    required this.createdAt,
  });

  factory Forum.fromJson(Map<String, dynamic> j) => Forum(
    id: j['id'],
    title: j['title'],
    description: j['description'],
    ownerId: j['ownerId'],
    visibility: j['visibility'],
    tags: (j['tags'] as List?)?.map((e) => e as String).toList() ?? [],
    createdAt: DateTime.parse(j['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'ownerId': ownerId,
    'visibility': visibility,
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
  };
}

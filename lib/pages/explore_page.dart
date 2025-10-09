import 'package:flutter/material.dart';
import '../data/models/post.dart';
import '../data/repositories/post_repository.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'package:apps/services/user_storage.dart';
import 'create_post_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _postsRepo = PostRepository();

  List<Post> _posts = [];
  Map<String, UserRegistrationData> _authorsById = {};
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);

    final posts = await _postsRepo.list(); // все посты
    final users = await loadUsers();

    final Map<String, UserRegistrationData> map = {
      for (final u in users) u.email: u,
    };

    setState(() {
      _posts = posts;
      _authorsById = map;
      _loading = false;
    });
  }

  List<Post> _filteredPosts() {
    if (_query.trim().isEmpty) return _posts;
    final q = _query.toLowerCase();
    return _posts.where((p) {
      final author = _authorsById[p.authorId];
      final authorName = author?.nickname ?? author?.email ?? '';
      return p.title.toLowerCase().contains(q) ||
          p.content.toLowerCase().contains(q) ||
          authorName.toLowerCase().contains(q);
    }).toList();
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Поиск по постам и авторам',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Создать пост',
            icon: const Icon(Icons.add, color: Colors.grey),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostPage()),
              );
              _loadAll();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredPosts();

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadAll,
        child: items.isEmpty
            ? ListView(
          children: [
            SizedBox(height: 200),
            Center(child: Text('Постов пока нет')),
          ],
        )
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final post = items[index];
            final author = _authorsById[post.authorId];
            final authorInitial = (author?.nickname?.isNotEmpty == true
                ? author!.nickname![0]
                : (author?.email.isNotEmpty == true
                ? author!.email[0]
                : '?'))
                .toUpperCase();

            return Card(
              color: const Color(0xFF1E1E1E),
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: Text(authorInitial),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              author?.nickname ??
                                  author?.email ??
                                  'Автор',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if ((author?.country?.isNotEmpty ??
                                false))
                              Text(
                                author!.country!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (post.title.isNotEmpty)
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // TODO: открыть детали поста или профиль автора
                          },
                          icon: const Icon(Icons.visibility,
                              color: Colors.blueAccent),
                          label: const Text(
                            'View',
                            style: TextStyle(
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

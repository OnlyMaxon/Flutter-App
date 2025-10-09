import 'package:flutter/material.dart';
import '../data/models/post.dart';
import '../data/repositories/post_repository.dart';
import 'create_post_page.dart';

class ForumChatPage extends StatefulWidget {
  final String forumId;
  final String forumTitle;

  const ForumChatPage({
    super.key,
    required this.forumId,
    required this.forumTitle,
  });

  @override
  State<ForumChatPage> createState() => _ForumChatPageState();
}

class _ForumChatPageState extends State<ForumChatPage> {
  final _postsRepo = PostRepository();
  List<Post> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final list = await _postsRepo.list(forumId: widget.forumId);
    setState(() {
      _posts = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.forumTitle)),
      body: _posts.isEmpty
          ? const Center(child: Text("Постов пока нет"))
          : RefreshIndicator(
        onRefresh: _loadPosts,
        child: ListView.separated(
          itemCount: _posts.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final p = _posts[i];
            return ListTile(
              title: Text(p.title),
              subtitle: Text(
                p.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreatePostPage(forumId: widget.forumId),
            ),
          );
          _loadPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

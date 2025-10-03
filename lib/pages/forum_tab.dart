
// ЕСТЬ ЗАГЛУШКИ !!!!!!!!!!!!!!!!!!!!!!!!!!!!

import 'package:flutter/material.dart';
import 'forum_chat_page.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'package:apps/services/user_storage.dart';

class ForumTab extends StatefulWidget {
  const ForumTab({super.key});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  List<UserRegistrationData> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final loaded = await loadUsers();
    setState(() {
      users = loaded;
      loading = false;
    });
  }

  UserRegistrationData _findAuthor(String nickname) {
    return users.firstWhere(
          (u) => u.nickname == nickname,
      orElse: () => UserRegistrationData(
        email: "unknown@example.com",
        password: "",
        firstName: "Unknown",
        lastName: "",
        nickname: "Unknown",
        country: "",
        nationality: "",
        languages: [],
        interests: [],
        isStudent: false,
        isLoggedIn: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 👇 демо-посты, теперь автор ищется безопасно
    final forumPosts = [
      {
        "author": _findAuthor("Maxon"), // например твой тестовый ник
        "question": "Где купить магнитные наклейки?",
        "tag": "#taxi@Vistula",
      },
      {
        "author": _findAuthor("Maxon"),
        "question": "Кто идёт на встречу в субботу?",
        "tag": "#meetup",
      },
    ];

    return ListView.builder(
      itemCount: forumPosts.length,
      itemBuilder: (context, index) {
        final post = forumPosts[index];
        final author = post["author"] as UserRegistrationData;

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                author.nickname?.isNotEmpty == true
                    ? author.nickname![0].toUpperCase()
                    : "?",
              ),
            ),
            title: Text("${author.nickname}, ${post["tag"]}"),
            subtitle: Text(post["question"] as String),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForumChatPage(
                      topic: post["question"] as String,
                      author: author.nickname ?? "Без имени",
                    ),
                  ),
                );
              },
              child: const Text("View"),
            ),
          ),
        );
      },
    );
  }
}

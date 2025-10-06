import 'package:flutter/material.dart';
import 'forum_chat_page.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'package:apps/services/user_storage.dart';
import 'package:apps/services/message_storage.dart';
import 'package:apps/services/message.dart';

class ForumTab extends StatefulWidget {
  const ForumTab({super.key});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  List<UserRegistrationData> users = [];
  List<Message> forumMessages = [];
  bool loading = true;

  final MessageStorage _messageStorage = MessageStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedUsers = await loadUsers();
    final msgs = await _messageStorage.loadMessages();

    // берём только форумные сообщения (у которых есть topic)
    final forumMsgs = msgs.where((m) => m.topic != null && m.topic!.isNotEmpty).toList();

    setState(() {
      users = loadedUsers;
      forumMessages = forumMsgs;
      loading = false;
    });
  }

  UserRegistrationData? _findAuthor(String email) {
    try {
      return users.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (forumMessages.isEmpty) {
      return const Center(child: Text("Нет тем на форуме"));
    }

    // группируем сообщения по topic → берём последнее сообщение как превью
    final Map<String, Message> lastByTopic = {};
    for (final msg in forumMessages) {
      if (!lastByTopic.containsKey(msg.topic!) ||
          msg.timestamp.isAfter(lastByTopic[msg.topic!]!.timestamp)) {
        lastByTopic[msg.topic!] = msg;
      }
    }

    final topics = lastByTopic.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final msg = topics[index];
        final author = _findAuthor(msg.sender);

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                (author?.nickname?.isNotEmpty == true
                    ? author!.nickname![0].toUpperCase()
                    : "?"),
              ),
            ),
            title: Text(msg.topic ?? "Без темы"),
            subtitle: Text(
              msg.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForumChatPage(
                      topic: msg.topic ?? "Без темы",
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

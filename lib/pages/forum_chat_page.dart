import 'package:flutter/material.dart';
import 'profile_pagedemo.dart';
import 'registration/registration_data.dart';
import 'package:apps/services/user_storage.dart'; // 👈 подтягиваем сохранённых юзеров


class ForumChatPage extends StatefulWidget {
  final String topic;
  final String author; // сюда приходит nickname автора

  const ForumChatPage({super.key, required this.topic, required this.author});

  @override
  State<ForumChatPage> createState() => _ForumChatPageState();
}

class _ForumChatPageState extends State<ForumChatPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages = [
    {"user": "TestUser", "text": "Где купить магнитные наклейки?"},
    {"user": "Rauf", "text": "Я тоже ищу, подскажите!"},
    {"user": "You", "text": "Можно попробовать в OBI или Leroy Merlin."},
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"user": "You", "text": _controller.text.trim()});
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openAuthorProfile() async {
    final users = await loadUsers();

    // 👇 ищем автора по нику среди сохранённых
    final authorUser = users.firstWhere(
          (u) => u.nickname == widget.author,
      orElse: () {
        // fallback если такого юзера нет в базе
        return UserRegistrationData(
          email: "-",
          nickname: widget.author,
          firstName: widget.author,
          lastName: "",
          country: "-",
          nationality: "-",
        );
      },
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePageDemo(user: authorUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Профиль автора",
            onPressed: _openAuthorProfile,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final user = msg["user"] ?? "Unknown";
                final text = msg["text"] ?? "";

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      user.isNotEmpty ? user[0].toUpperCase() : "?",
                    ),
                  ),
                  title: Text(user),
                  subtitle: Text(text, softWrap: true),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Напишите сообщение...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

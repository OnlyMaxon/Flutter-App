
//ЕСТЬ ЗАГЛУШКА !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

import 'package:flutter/material.dart';
import 'profile_pagedemo.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'package:apps/services/user_storage.dart';
import 'package:apps/services/message_storage.dart'; // 👈 хранилище сообщений

class ForumChatPage extends StatefulWidget {
  final String topic;
  final String author; // сюда приходит nickname автора

  const ForumChatPage({super.key, required this.topic, required this.author});

  @override
  State<ForumChatPage> createState() => _ForumChatPageState();
}

class _ForumChatPageState extends State<ForumChatPage> {
  final TextEditingController _controller = TextEditingController();
  final MessageStorage _messageStorage = MessageStorage();

  List<Message> _messages = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final msgs = await _messageStorage.loadMessages();
    setState(() {
      // фильтруем сообщения по теме форума
      _messages = msgs.where((m) => m.topic == widget.topic).toList();
      loading = false;
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    // 👇 загружаем текущего пользователя
    UserRegistrationData? currentUser = await loadCurrentUser();
    if (currentUser == null) return;

    final newMsg = Message(
      authorEmail: currentUser.email,
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
      topic: widget.topic,
    );

    await _messageStorage.addMessage(newMsg);

    setState(() {
      _messages.add(newMsg);
      _controller.clear();
    });
  }

  Future<void> _openAuthorProfile() async {
    final users = await loadUsers();
    final authorUser = users.firstWhere(
          (u) => u.nickname == widget.author,
      orElse: () => UserRegistrationData(
        email: "-",
        password: "-",              // 👈 обязательное поле
        nickname: widget.author,
        firstName: widget.author,
        lastName: "",
        country: "-",
        nationality: "-",
      ),

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
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                final userEmail = msg.authorEmail;

                return FutureBuilder<List<UserRegistrationData>>(
                  future: loadUsers(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile(title: Text("Загрузка..."));
                    }
                    final users = snapshot.data!;
                    final author = users.firstWhere(
                          (u) => u.email == userEmail,
                      orElse: () => UserRegistrationData(
                        email: userEmail,
                        password: "-",              // 👈 обязательное поле
                        nickname: "Unknown",
                        firstName: "Unknown",
                        lastName: "",
                        country: "-",
                        nationality: "-",
                      ),

                    );

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          author.nickname?.isNotEmpty == true
                              ? author.nickname![0].toUpperCase()
                              : "?",
                        ),
                      ),
                      title: Text(author.nickname ?? "Unknown"),
                      subtitle: Text(msg.text, softWrap: true),
                      trailing: Text(
                        "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
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

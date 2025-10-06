import 'package:flutter/material.dart';
import 'profile_pagedemo.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'package:apps/services/user_storage.dart';
import 'package:apps/services/message_storage.dart'; // хранилище сообщений
import 'package:apps/services/message.dart'; // модель сообщения

class ForumChatPage extends StatefulWidget {
  final String topic;

  const ForumChatPage({super.key, required this.topic});

  @override
  State<ForumChatPage> createState() => _ForumChatPageState();
}

class _ForumChatPageState extends State<ForumChatPage> {
  final TextEditingController _controller = TextEditingController();
  final MessageStorage _messageStorage = MessageStorage();

  List<Message> _messages = [];
  List<UserRegistrationData> _users = [];
  UserRegistrationData? _currentUser;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final msgs = await _messageStorage.loadMessages();
    final users = await loadUsers();
    final current = await loadCurrentUser();

    setState(() {
      _messages = msgs.where((m) => m.topic == widget.topic).toList();
      _users = users;
      _currentUser = current;
      loading = false;
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _currentUser == null) return;

    final newMsg = Message(
      sender: _currentUser!.email,
      recipient: "", // форумное сообщение — не личное
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

  UserRegistrationData? _findUserByEmail(String email) {
    try {
      return _users.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  void _openAuthorProfile(UserRegistrationData user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePageDemo(user: user),
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
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("Нет сообщений в этой теме"))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final author = _findUserByEmail(msg.sender);

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (author?.nickname?.isNotEmpty == true
                          ? author!.nickname![0].toUpperCase()
                          : "?"),
                    ),
                  ),
                  title: Text(author?.nickname ?? msg.sender),
                  subtitle: Text(msg.text, softWrap: true),
                  trailing: Text(
                    "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: author != null
                      ? () => _openAuthorProfile(author)
                      : null,
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

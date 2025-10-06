import 'package:flutter/material.dart';
import 'profile_pagedemo.dart';
import 'package:apps/pages/registration/registration_data.dart';
import '../services/message_storage.dart';
import '../services/user_storage.dart';
import '../services/message.dart'; // 👈 правильный импорт

class ChatPage extends StatefulWidget {
  final UserRegistrationData otherUser;

  const ChatPage({super.key, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  UserRegistrationData? _currentUser;
  final MessageStorage _storage = MessageStorage(); // 👈 экземпляр хранилища

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    final current = await loadCurrentUser();
    final allMessages = await _storage.loadMessages();

    setState(() {
      _currentUser = current;
      _messages = allMessages.where((m) =>
      (m.sender == current?.email && m.recipient == widget.otherUser.email) ||
          (m.sender == widget.otherUser.email && m.recipient == current?.email)
      ).toList();
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _currentUser == null) return;

    final newMsg = Message(
      sender: _currentUser!.email,
      recipient: widget.otherUser.email,
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
    );

    await _storage.addMessage(newMsg); // 👈 сохраняем через storage

    setState(() {
      _messages.add(newMsg);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.nickname ?? widget.otherUser.email),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePageDemo(user: widget.otherUser),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("Нет сообщений"))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.sender == _currentUser?.email;
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blueAccent
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
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

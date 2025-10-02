import 'package:flutter/material.dart';
import 'profile_pagedemo.dart';
import 'package:apps/pages/registration/registration_data.dart';


class ChatPage extends StatefulWidget {
  final UserRegistrationData otherUser;

  const ChatPage({super.key, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = ["TestUser: Привет!"];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add("Я: ${_controller.text.trim()}");
      _controller.clear();
      // 👇 имитация ответа тестового пользователя
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add("${widget.otherUser.nickname}: Я тестовый, привет 👋");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.nickname ?? "Чат"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePageDemo(user: widget.otherUser), // 👈 заменили
                ),
              );

            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
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

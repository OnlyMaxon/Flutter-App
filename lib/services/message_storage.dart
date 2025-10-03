import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Message {
  final String authorEmail;
  final String text;
  final DateTime timestamp;
  final String topic; // 👈 добавляем тему, чтобы фильтровать по форумам/чатам

  Message({
    required this.authorEmail,
    required this.text,
    required this.timestamp,
    required this.topic,
  });

  Map<String, dynamic> toJson() => {
    'authorEmail': authorEmail,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
    'topic': topic,
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    authorEmail: json['authorEmail'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
    topic: json['topic'] ?? "", // fallback для старых данных
  );
}

class MessageStorage {
  Future<File> _getMessagesFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/messages.json');
  }

  Future<List<Message>> loadMessages() async {
    final file = await _getMessagesFile();
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((j) => Message.fromJson(j)).toList();
    }
    return [];
  }

  Future<void> saveMessages(List<Message> messages) async {
    final file = await _getMessagesFile();
    final jsonList = messages.map((m) => m.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> addMessage(Message message) async {
    final messages = await loadMessages();
    messages.add(message);
    await saveMessages(messages);
  }
}

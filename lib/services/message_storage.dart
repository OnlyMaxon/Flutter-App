import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/message.dart'; // 👈 теперь импортируем модель из отдельного файла

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

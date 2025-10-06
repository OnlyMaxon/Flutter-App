class Message {
  final String sender;       // email отправителя
  final String recipient;    // email получателя (для личных чатов)
  final String text;         // текст сообщения
  final DateTime timestamp;  // время отправки
  final String? topic;       // опционально: для форумов

  Message({
    required this.sender,
    required this.recipient,
    required this.text,
    required this.timestamp,
    this.topic,
  });

  /// Сериализация в JSON
  Map<String, dynamic> toJson() => {
    'sender': sender,
    'recipient': recipient,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
    'topic': topic,
  };

  /// Десериализация из JSON
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    sender: json['sender'],
    recipient: json['recipient'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
    topic: json['topic'],
  );
}

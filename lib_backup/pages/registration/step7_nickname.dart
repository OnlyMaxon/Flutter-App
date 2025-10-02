import 'package:flutter/material.dart';
import 'registration_data.dart';

class Step7Nickname extends StatefulWidget {
  final UserRegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step7Nickname({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step7Nickname> createState() => _Step7NicknameState();
}

class _Step7NicknameState extends State<Step7Nickname> {
  final _formKey = GlobalKey<FormState>();
  final _nick = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nick.text = widget.data.nickname ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nick,
              decoration: const InputDecoration(
                labelText: 'Никнейм (пример: @Person)',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Введите никнейм';
                if (!v.startsWith('@')) return 'Ник должен начинаться с @';
                if (v.length < 3) return 'Слишком короткий ник';
                // Здесь можно добавить проверку уникальности на сервере
                return null;
              },
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(onPressed: widget.onBack, child: const Text('Назад')),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.data.nickname = _nick.text.trim();
                      widget.onNext();
                    }
                  },
                  child: const Text('Далее'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

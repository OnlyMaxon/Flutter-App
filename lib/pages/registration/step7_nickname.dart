import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart';

class Step7Nickname extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step7Nickname({
    super.key,
    required this.draft,
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
    _nick.text = widget.draft.nickname ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Придумайте никнейм',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nick,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Никнейм (пример: @Person)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Введите никнейм';
                    if (!v.startsWith('@')) return 'Ник должен начинаться с @';
                    if (v.length < 3) return 'Слишком короткий ник';
                    return null;
                  },
                ),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: widget.onBack,
                      child: const Text('Назад'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.draft.nickname = _nick.text.trim();
                          widget.onNext();
                        }
                      },
                      child: const Text(
                        'Далее',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart';
import 'registration_data.dart';// 👈 подключаем черновик

class Step1EmailPassword extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;

  const Step1EmailPassword({
    super.key,
    required this.draft,
    required this.onNext,
  });

  @override
  State<Step1EmailPassword> createState() => _Step1EmailPasswordState();
}

class _Step1EmailPasswordState extends State<Step1EmailPassword> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // draft всегда есть, даже если пустой
    _email.text = widget.draft.email;
    _password.text = widget.draft.password;
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
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Gmail'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Введите email';
                if (!v.contains('@')) return 'Некорректный email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Пароль',
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Введите пароль';
                if (v.length < 6) return 'Минимум 6 символов';
                return null;
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // сохраняем введённые данные в draft
                  widget.draft.email = _email.text.trim();
                  widget.draft.password = _password.text;
                  widget.onNext();
                }
              },
              child: const Text('Далее'),
            ),
          ],
        ),
      ),
    );
  }
}

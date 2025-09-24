import 'package:flutter/material.dart';
import 'registration_data.dart';

class Step1EmailPassword extends StatefulWidget {
  final UserRegistrationData data;
  final VoidCallback onNext;

  const Step1EmailPassword({super.key, required this.data, required this.onNext});

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
    _email.text = widget.data.email ?? '';
    _password.text = widget.data.password ?? '';
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
                  widget.data.email = _email.text.trim();
                  widget.data.password = _password.text;
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

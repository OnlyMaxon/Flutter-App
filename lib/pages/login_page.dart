import 'package:flutter/material.dart';
import '../services/user_storage.dart';
import 'registration/registration_data.dart';
import '../main.dart'; // чтобы перейти на MainPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  Future<void> _login() async {
    final data = await loadUserData();
    if (data == null) {
      setState(() => _error = "Пользователь не найден. Зарегистрируйтесь.");
      return;
    }

    if (data.email == _emailController.text.trim() &&
        data.password == _passwordController.text.trim()) {
      data.isLoggedIn = true;
      await saveUserData(data);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainPage()),
            (route) => false,
      );
    } else {
      setState(() => _error = "Неверный email или пароль");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Вход"),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Пароль"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Войти"),
            ),
          ],
        ),
      ),
    );
  }
}

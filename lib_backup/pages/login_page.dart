import 'package:flutter/material.dart';
import '../services/user_storage.dart';
import 'package:apps/pages/registration/registration_data.dart';
import '../main.dart';

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
    final users = await loadUsers();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();


    final user = users.firstWhere(
          (u) => u.email == email && u.password == password,
      orElse: () => UserRegistrationData(),
    );

    if (user.email == null) {
      setState(() => _error = "Пользователь не найден. Зарегистрируйтесь.");
      return;
    }


    user.isLoggedIn = true;
    await saveCurrentUser(user);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainPage()),
          (route) => false,
    );
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

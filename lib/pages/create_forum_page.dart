import 'package:flutter/material.dart';
import '../data/repositories/forum_repository.dart';
import '../services/user_storage.dart'; // ✅ используем твой user_storage

class CreateForumPage extends StatefulWidget {
  const CreateForumPage({super.key});

  @override
  State<CreateForumPage> createState() => _CreateForumPageState();
}

class _CreateForumPageState extends State<CreateForumPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _tags = TextEditingController();
  bool _loading = false;

  final _forums = ForumRepository();

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      // ✅ Берём текущего пользователя из user_storage
      final user = await loadCurrentUser();
      if (user == null) throw StateError('Пользователь не авторизован');

      final tags = _tags.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // ✅ ownerId = email (или можно user.id, если он есть в UserRegistrationData)
      await _forums.create(
        title: _title.text,
        description: _desc.text,
        ownerId: user.email, // 👈 ключевая связь
        tags: tags,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Форум создан')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создать форум')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tags,
              decoration: const InputDecoration(labelText: 'Теги (через запятую)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}

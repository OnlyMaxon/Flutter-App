import 'package:flutter/material.dart';
import '../services/user_storage.dart';
import '../pages/registration/registration_data.dart';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserRegistrationData? _user;
  Color _coverColor = Colors.grey[800]!;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await loadUserData();
    if (data != null && data.photoPath != null && File(data.photoPath!).existsSync()) {
      final dominant = await _getDominantColor(data.photoPath!);
      setState(() {
        _coverColor = dominant;
        _user = data;
      });
    } else {
      setState(() => _user = data);
    }
  }

  Future<Color> _getDominantColor(String imagePath) async {
    final palette = await PaletteGenerator.fromImageProvider(
      FileImage(File(imagePath)),
    );
    return palette.dominantColor?.color ?? Colors.grey[800]!;
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: ListView(
        children: [
          // Верхняя часть с фоном и аватаром
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: _coverColor,
              ),
              Positioned(
                bottom: -50,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(3), // толщина обводки
                  decoration: BoxDecoration(
                    color: Colors.white, // цвет рамки
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: _user!.photoPath != null &&
                        File(_user!.photoPath!).existsSync()
                        ? FileImage(File(_user!.photoPath!))
                        : null,
                    child: _user!.photoPath == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),

          // Имя, фамилия, ник, бейдж
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Имя + фамилия
                Text(
                  '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}'.trim().isEmpty
                      ? '—'
                      : '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Никнейм с @
                Text(
                  _user!.nickname != null && _user!.nickname!.startsWith('@')
                      ? _user!.nickname!
                      : '@${_user!.nickname ?? 'username'}',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                if (_user!.isStudent == true)
                  Chip(
                    label: const Text('Student'),
                    backgroundColor: Colors.blue.shade100,
                  ),

                const SizedBox(height: 8),

                Text(
                  '${_user!.country ?? '—'}, ${_user!.nationality ?? '—'}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Интересы
          if (_user!.interests.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: _user!.interests
                    .map((i) => Chip(label: Text('#$i')))
                    .toList(),
              ),
            ),

          // Языки
          if (_user!.languages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: _user!.languages
                    .map((l) => Chip(label: Text(l)))
                    .toList(),
              ),
            ),

          const SizedBox(height: 16),

          // Статистика
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: const [
                Text('0',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Followers', style: TextStyle(color: Colors.grey)),
              ]),
              Column(children: const [
                Text('0',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Following', style: TextStyle(color: Colors.grey)),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          // Кнопки
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Text')),
                ElevatedButton(onPressed: () {}, child: const Text('Subscribe')),
                ElevatedButton(onPressed: () {}, child: const Text('Edit')),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Плейсхолдер контента
          Center(
            child: Column(
              children: const [
                Icon(Icons.image_not_supported,
                    size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Нет загруженного контента',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

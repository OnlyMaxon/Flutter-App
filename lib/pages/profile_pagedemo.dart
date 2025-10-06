import 'package:flutter/material.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';
import 'chat_page.dart'; // 👈 подключаем чат

class ProfilePageDemo extends StatefulWidget {
  final UserRegistrationData user;

  const ProfilePageDemo({super.key, required this.user});

  @override
  State<ProfilePageDemo> createState() => _ProfilePageDemoState();
}

class _ProfilePageDemoState extends State<ProfilePageDemo> {
  late UserRegistrationData _user;
  Color _coverColor = Colors.grey[800]!;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _initCoverColor();
  }

  Future<void> _initCoverColor() async {
    if (_user.photoPath != null && File(_user.photoPath!).existsSync()) {
      final dominant = await _getDominantColor(_user.photoPath!);
      setState(() => _coverColor = dominant);
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(_user.nickname ?? "Профиль"),
      ),
      body: ListView(
        children: [
          // Cover / dominant color
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: (_user.coverPath != null && File(_user.coverPath!).existsSync())
                    ? BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(_user.coverPath!)),
                    fit: BoxFit.cover,
                  ),
                )
                    : BoxDecoration(
                  color: _coverColor,
                ),
              ),
              // Avatar
              Positioned(
                bottom: -50,
                left: 16,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: _user.photoPath != null &&
                        File(_user.photoPath!).existsSync()
                        ? FileImage(File(_user.photoPath!))
                        : null,
                    child: _user.photoPath == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),

          // Name, nickname, country/nationality
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user.firstName ?? ''} ${_user.lastName ?? ''}'.trim().isEmpty
                      ? '—'
                      : '${_user.firstName ?? ''} ${_user.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.nickname != null && _user.nickname!.startsWith('@')
                      ? _user.nickname!
                      : '@${_user.nickname ?? 'username'}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                if (_user.isStudent == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Student',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Interests
          if (_user.interests.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Интересы",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _user.interests
                        .map((i) => Chip(
                      avatar: const Icon(Icons.tag, size: 16, color: Colors.white),
                      label: Text(i.startsWith('#') ? i : '#$i'),
                      backgroundColor: Colors.blueGrey.shade700,
                      labelStyle: const TextStyle(color: Colors.white),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),

          // Languages
          if (_user.languages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Языки",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _user.languages
                        .map((l) => Chip(
                      avatar: const Icon(Icons.language, size: 16, color: Colors.white),
                      label: Text(l),
                      backgroundColor: Colors.teal.shade700,
                      labelStyle: const TextStyle(color: Colors.white),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // 👇 Кнопка "Написать"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatPage(otherUser: _user)),
                );
              },
              icon: const Icon(Icons.chat),
              label: const Text("Написать"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Content placeholder
          Center(
            child: Column(
              children: const [
                Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Нет загруженного контента', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

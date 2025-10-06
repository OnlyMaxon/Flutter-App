import 'package:flutter/material.dart';
import '../services/user_storage.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';
import 'edit_profile_page.dart';

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
    final data = await loadCurrentUser();
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

          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: (_user!.coverPath != null && File(_user!.coverPath!).existsSync())
                    ? BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(_user!.coverPath!)),
                    fit: BoxFit.cover,
                  ),
                )
                    : BoxDecoration(
                  color: _coverColor, // по умолчанию цвет из аватарки
                ),
              ),


              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfilePage()),
                    );
                    _loadUser(); // обновляем данные после возврата
                  },
                ),
              ),

              Positioned(
                bottom: -50,
                left: 16,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
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


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}'.trim().isEmpty
                      ? '—'
                      : '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user!.nickname != null && _user!.nickname!.startsWith('@')
                      ? _user!.nickname!
                      : '@${_user!.nickname ?? 'username'}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),


                if (_user!.isStudent == true)
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

                const SizedBox(height: 8),
                Row(
                  children: [
                    if (_user!.country != null && _user!.country!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flag, size: 16, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              _user!.country!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    if (_user!.nationality != null && _user!.nationality!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.public, size: 16, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              _user!.nationality!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

              ],
            ),
          ),

          const SizedBox(height: 16),


          if (_user!.interests.isNotEmpty)
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
                    children: _user!.interests
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


          if (_user!.languages.isNotEmpty)
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
                    children: _user!.languages
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

          const SizedBox(height: 16),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: const [
                Text('122',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Followers', style: TextStyle(color: Colors.grey)),
              ]),
              Column(children: const [
                Text('67',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Following', style: TextStyle(color: Colors.grey)),
              ]),
            ],
          ),

          const SizedBox(height: 16),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Text'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Subscribe'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),


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

import 'package:flutter/material.dart';
import 'registration/registration_data.dart';

class ProfilePageDemo extends StatelessWidget {
  final UserRegistrationData user;

  const ProfilePageDemo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.nickname ?? "Профиль")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 40, child: Text(user.nickname?[0] ?? "?")),
            const SizedBox(height: 16),
            Text("Email: ${user.email ?? "-"}"),
            Text("Имя: ${user.firstName ?? "-"}"),
            Text("Фамилия: ${user.lastName ?? "-"}"),
            Text("Страна: ${user.country ?? "-"}"),
            Text("Национальность: ${user.nationality ?? "-"}"),
          ],
        ),
      ),
    );
  }
}


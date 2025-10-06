// lib/services/user_storage.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:apps/pages/registration/registration_data.dart';


Future<File> _getUsersFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/users.json');
}

Future<void> saveUsers(List<UserRegistrationData> users) async {
  final file = await _getUsersFile();
  final jsonList = users.map((u) => u.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList));
}

Future<List<UserRegistrationData>> loadUsers() async {
  final file = await _getUsersFile();
  if (await file.exists()) {
    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((j) => UserRegistrationData.fromJson(j)).toList();
  }
  return [];
}

Future<void> addUser(UserRegistrationData user) async {
  final users = await loadUsers();
  users.add(user);
  await saveUsers(users);
}

Future<UserRegistrationData?> loadCurrentUser() async {
  final users = await loadUsers();
  try {
    return users.firstWhere((u) => u.isLoggedIn == true);
  } catch (_) {
    return null;
  }
}


Future<void> saveCurrentUser(UserRegistrationData user) async {
  final users = await loadUsers();

  for (var u in users) {
    u.isLoggedIn = false;
  }

  final index = users.indexWhere((u) => u.email == user.email);
  if (index != -1) {
    users[index] = user..isLoggedIn = true;
  } else {
    users.add(user..isLoggedIn = true);
  }
  await saveUsers(users);
}


Future<void> deleteAllUsers() async {
  final file = await _getUsersFile();
  if (await file.exists()) {
    await file.delete();
  }
}


Future<void> initTestUser() async {
  final users = await loadUsers();
  final exists = users.any((u) => u.email == "test@example.com");
  if (!exists) {
    final testUser = UserRegistrationData(
      email: "test@example.com",
      password: "123456",
      firstName: "Test",
      lastName: "User",
      nickname: "TestUser",
      country: "Польша",
      nationality: "Русский",
      languages: ["Русский", "Английский"],
      interests: ["Flutter", "UI/UX", "Стартапы"],
      isStudent: false,
      isLoggedIn: false,
    );
    users.add(testUser);
    await saveUsers(users);
  }
}
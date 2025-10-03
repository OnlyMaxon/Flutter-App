// lib/services/user_storage.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:apps/pages/registration/registration_data.dart';

/// Получаем путь к файлу со всеми пользователями
Future<File> _getUsersFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/users.json');
}

/// Получаем путь к файлу текущего пользователя
Future<File> _getCurrentUserFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/current_user.json');
}

/// Сохраняем список пользователей
Future<void> saveUsers(List<UserRegistrationData> users) async {
  final file = await _getUsersFile();
  final jsonList = users.map((u) => u.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList));
}

/// Загружаем список пользователей
Future<List<UserRegistrationData>> loadUsers() async {
  final file = await _getUsersFile();
  if (await file.exists()) {
    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((j) => UserRegistrationData.fromJson(j)).toList();
  }
  return [];
}

/// Добавляем нового пользователя (если email уникален)
Future<void> addUser(UserRegistrationData user) async {
  final users = await loadUsers();
  final exists = users.any((u) => u.email == user.email);
  if (!exists) {
    users.add(user);
    await saveUsers(users);
  }
}

/// Загружаем текущего залогиненного пользователя
Future<UserRegistrationData?> loadCurrentUser() async {
  final file = await _getCurrentUserFile();
  if (await file.exists()) {
    final contents = await file.readAsString();
    return UserRegistrationData.fromJson(jsonDecode(contents));
  }
  return null;
}

/// Сохраняем/обновляем текущего пользователя
Future<void> saveCurrentUser(UserRegistrationData user) async {
  // сохраняем в отдельный файл
  final file = await _getCurrentUserFile();
  await file.writeAsString(jsonEncode(user.toJson()));

  // обновляем список пользователей
  final users = await loadUsers();
  final index = users.indexWhere((u) => u.email == user.email);
  if (index != -1) {
    users[index] = user;
  } else {
    users.add(user);
  }
  await saveUsers(users);
}

/// Удаляем всех пользователей (очистка базы)
Future<void> deleteAllUsers() async {
  final file = await _getUsersFile();
  if (await file.exists()) {
    await file.delete();
  }
  final currentFile = await _getCurrentUserFile();
  if (await currentFile.exists()) {
    await currentFile.delete();
  }
}

// lib/services/user_storage.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../pages/registration/registration_data.dart';

/// Получаем путь к файлу, где будут храниться данные пользователя
Future<File> _getUserFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/user_registration.json');
}

/// Сохраняем данные пользователя в JSON
Future<void> saveUserData(UserRegistrationData data) async {
  final file = await _getUserFile();
  await file.writeAsString(jsonEncode(data.toJson()));
}

/// Загружаем данные пользователя из JSON
Future<UserRegistrationData?> loadUserData() async {
  final file = await _getUserFile();
  if (await file.exists()) {
    final contents = await file.readAsString();
    return UserRegistrationData.fromJson(jsonDecode(contents));
  }
  return null;
}

/// Удаляем сохранённые данные пользователя
Future<void> deleteUserData() async {
  final file = await _getUserFile();
  if (await file.exists()) {
    await file.delete();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import '../pages/registration/registration_data.dart';





/// Получаем путь к файлу, где будут храниться данные пользователей
Future<File> _getUsersFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/users.json');
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
    if (contents.trim().isEmpty) return []; // 👈 защита от пустого файла
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((j) => UserRegistrationData.fromJson(j)).toList();
  }
  return [];
}

/// Добавляем нового пользователя
Future<void> addUser(UserRegistrationData user) async {
  final users = await loadUsers();
  users.add(user);
  await saveUsers(users);
}

/// Загружаем текущего залогиненного пользователя
Future<UserRegistrationData?> loadCurrentUser() async {
  final users = await loadUsers();
  return users.firstWhereOrNull((u) => u.isLoggedIn == true);
}

/// Сохраняем/обновляем текущего пользователя
Future<void> saveCurrentUser(UserRegistrationData user) async {
  final users = await loadUsers();

  // Сбрасываем флаг у всех
  for (var u in users) {
    u.isLoggedIn = false;
  }

  // Если юзер уже есть — обновляем, иначе добавляем
  final index = users.indexWhere((u) => u.email == user.email);
  user.isLoggedIn = true;
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
}

/// Создаём тестового пользователя, если его ещё нет
Future<void> initTestUser() async {
  final users = await loadUsers();
  final exists = users.any((u) => u.email == "test@email.com");
  if (!exists) {
    final testUser = UserRegistrationData(
      email: "test@email.com", // 👈 синхронизировано с проверкой
      password: "123456",
      firstName: "Orucov",
      lastName: "Max",
      nickname: "Maxon",
      country: "Польша",
      nationality: "Русский",
      languages: ["Русский", "Английский"],
      interests: ["Flutter", "UI/UX", "Стартапы"],
      isStudent: false,
      isLoggedIn: false, // 👈 он не активный
    );
    users.add(testUser);
    await saveUsers(users);
  }
}

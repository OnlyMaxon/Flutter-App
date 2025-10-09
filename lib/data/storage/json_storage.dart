import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorage {
  JsonStorage._();
  static final JsonStorage instance = JsonStorage._();

  late final Directory _dir;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    _dir = await getApplicationDocumentsDirectory();
    _ready = true;
  }

  Future<File> _file(String name) async {
    await init();
    final f = File('${_dir.path}/$name');
    if (!await f.exists()) {
      await f.create(recursive: true);
      await f.writeAsString('{}');
    }
    return f;
  }

  Future<Map<String, dynamic>> readJson(String name) async {
    final f = await _file(name);
    final raw = await f.readAsString();
    return (jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> writeJson(String name, Map<String, dynamic> data) async {
    final f = await _file(name);
    final raw = const JsonEncoder.withIndent('  ').convert(data);
    await f.writeAsString(raw);
  }
}

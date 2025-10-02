import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../services/user_storage.dart';
import '../pages/registration/registration_data.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController nicknameCtrl;

  bool isStudent = false;
  List<String> interests = [];
  List<String> languages = [];
  String? photoPath;
  String? coverPath;
  String? selectedNationality;
  String? selectedCountry;

  final List<String> nationalities = const [
    'Русский',
    'Украинец',
    'Поляк',
    'Белорус',
    'Казах',
    'Азербайджанец',
    'Армянин',
    'Грузин',
    'Немец',
    'Француз',
    'Англичанин',
    'Американец',
    'Турок',
    'Китаец',
    'Японец',
    'Кореец',
    'Индиец',
    'Другое',
  ];

  final List<String> countries = const [
    'Польша',
    'Россия',
    'Украина',
    'Беларусь',
    'Казахстан',
    'Азербайджан',
    'Армения',
    'Грузия',
    'Латвия',
    'Литва',
    'Эстония',
    'Германия',
    'Франция',
    'Италия',
    'Испания',
    'Великобритания',
    'США',
    'Канада',
    'Турция',
    'Китай',
    'Япония',
    'Корея',
    'Индия',
    'Другое',
  ];

  final List<String> availableLanguages = const [
    'Русский',
    'Украинский',
    'Польский',
    'Английский',
    'Немецкий',
    'Французский',
    'Испанский',
    'Итальянский',
    'Китайский',
    'Японский',
    'Корейский',
    'Турецкий',
    'Арабский',
    'Индийский',
  ];

  final List<String> popularLanguages = const [
    'Английский',
    'Русский',
    'Польский',
    'Немецкий',
    'Французский',
    'Испанский',
  ];

  DateTime? lastNationalityChange;

  @override
  void initState() {
    super.initState();
    firstNameCtrl = TextEditingController();
    lastNameCtrl = TextEditingController();
    nicknameCtrl = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await loadCurrentUser(); // 👈 заменили на новый метод
    if (user != null) {
      setState(() {
        firstNameCtrl.text = user.firstName ?? "";
        lastNameCtrl.text = user.lastName ?? "";
        nicknameCtrl.text = user.nickname ?? "";
        isStudent = user.isStudent ?? false;
        interests = List.from(user.interests);
        languages = List.from(user.languages);
        photoPath = user.photoPath;
        coverPath = user.coverPath;
        selectedNationality = user.nationality;
        selectedCountry = user.country;
        lastNationalityChange = user.lastNationalityChange;
      });
    }
  }


  Future<void> _pickImage(bool isCover) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isCover) {
          coverPath = picked.path;
        } else {
          photoPath = picked.path;
        }
      });
    }
  }

  Future<void> _save() async {
    final oldUser = await loadCurrentUser(); // 👈 заменили

    // Ограничение смены национальности
    if (oldUser?.lastNationalityChange != null &&
        selectedNationality != oldUser?.nationality) {
      final diff = DateTime.now().difference(oldUser!.lastNationalityChange!);
      if (diff.inDays < 30) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Национальность можно менять только раз в месяц"),
          ),
        );
        return;
      }
    }

    final user = UserRegistrationData(
      firstName: firstNameCtrl.text,
      lastName: lastNameCtrl.text,
      nickname: nicknameCtrl.text,
      isStudent: isStudent,
      interests: interests,
      languages: languages,
      photoPath: photoPath,
      coverPath: coverPath,
      country: selectedCountry ?? oldUser?.country,
      nationality: selectedNationality ?? oldUser?.nationality,
      lastNationalityChange: (selectedNationality != oldUser?.nationality)
          ? DateTime.now()
          : oldUser?.lastNationalityChange,
      isLoggedIn: true,
    );

    await saveCurrentUser(user); // 👈 заменили
    if (mounted) Navigator.pop(context);
  }


  Future<String?> _showInputDialog(String title) async {
    String value = "";
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(onChanged: (v) => value = v),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
          TextButton(onPressed: () => Navigator.pop(context, value), child: const Text("OK")),
        ],
      ),
    );
  }

  Future<void> _openLanguageSelector() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => LanguageSelector(
        selected: languages,
        available: availableLanguages,
        popular: popularLanguages,
      ),
    );
    if (result != null) {
      setState(() => languages = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактировать профиль"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Аватар
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: photoPath != null ? FileImage(File(photoPath!)) : null,
                child: photoPath == null ? const Icon(Icons.person, size: 40) : null,
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _pickImage(false),
                child: const Text("Сменить фото"),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Обложка
          ElevatedButton.icon(
            onPressed: () => _pickImage(true),
            icon: const Icon(Icons.image),
            label: const Text("Сменить обложку"),
          ),
          const SizedBox(height: 16),

          // Имя, фамилия, ник
          TextField(controller: firstNameCtrl, decoration: const InputDecoration(labelText: "Имя")),
          TextField(controller: lastNameCtrl, decoration: const InputDecoration(labelText: "Фамилия")),
          TextField(controller: nicknameCtrl, decoration: const InputDecoration(labelText: "Никнейм")),

          const SizedBox(height: 16),

          // Страна (Dropdown)
          DropdownButtonFormField<String>(
            value: selectedCountry,
            decoration: const InputDecoration(labelText: "Страна"),
            items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => selectedCountry = val),
          ),

          const SizedBox(height: 16),

          // Национальность (Dropdown)
          DropdownButtonFormField<String>(
            value: selectedNationality,
            decoration: InputDecoration(
              labelText: "Национальность",
              helperText: lastNationalityChange == null
                  ? "Можно изменить сейчас"
                  : "Последнее изменение: ${_formatDate(lastNationalityChange!)}",
              helperStyle: subtitleStyle,
            ),
            items: nationalities.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
            onChanged: (val) => setState(() => selectedNationality = val),
          ),

          const SizedBox(height: 16),

          // Студент
          SwitchListTile(
            title: const Text("Студент"),
            value: isStudent,
            onChanged: (val) => setState(() => isStudent = val),
          ),

          const SizedBox(height: 16),

          // Интересы
          const Text("Интересы", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: interests
                .map((i) => Chip(
              label: Text(i),
              onDeleted: () => setState(() => interests.remove(i)),
            ))
                .toList(),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final newInterest = await _showInputDialog("Добавить интерес");
              if (newInterest != null && newInterest.isNotEmpty) {
                setState(() => interests.add(newInterest));
              }
            },
            child: const Text("Добавить интерес"),
          ),

          const SizedBox(height: 16),

          // Языки: чипы + кнопка выбора (модальное окно с поиском)
          const Text("Языки", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: languages
                .map((l) => Chip(
              label: Text(l),
              onDeleted: () => setState(() => languages.remove(l)),
            ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _openLanguageSelector,
                icon: const Icon(Icons.translate),
                label: const Text("Выбрать языки"),
              ),
              const SizedBox(width: 12),
              if (languages.isNotEmpty)
                Text("Выбрано: ${languages.length}", style: subtitleStyle),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    // Короткий DD.MM.YYYY
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return "$day.$month.$year";
  }
}

// ---- Модальное окно выбора языков с поиском и улучшенным UX ----

class LanguageSelector extends StatefulWidget {
  final List<String> selected;
  final List<String> available;
  final List<String> popular;

  const LanguageSelector({
    super.key,
    required this.selected,
    required this.available,
    required this.popular,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late List<String> filtered;
  late List<String> chosen;
  String query = "";

  @override
  void initState() {
    super.initState();
    filtered = widget.available;
    chosen = List.from(widget.selected);
  }

  void _filter(String text) {
    setState(() {
      query = text;
      filtered = widget.available
          .where((lang) => lang.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _toggle(String lang, bool? val) {
    setState(() {
      if (val == true) {
        if (!chosen.contains(lang)) chosen.add(lang);
      } else {
        chosen.remove(lang);
      }
    });
  }

  void _clearAll() {
    setState(() => chosen.clear());
  }

  @override
  Widget build(BuildContext context) {
    final subtitleStyle =
    Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grabber
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with count and clear
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Выбор языков",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text("Выбрано: ${chosen.length}/${widget.available.length}",
                    style: subtitleStyle),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear),
                  label: const Text("Очистить"),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Search
            TextField(
              decoration: const InputDecoration(
                labelText: "Поиск языка",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filter,
            ),

            const SizedBox(height: 12),

            // Popular section (only when no query)
            if (query.isEmpty) ...[
              Text("Популярные", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.popular.map((lang) {
                  final active = chosen.contains(lang);
                  return FilterChip(
                    label: Text(lang),
                    selected: active,
                    onSelected: (val) => _toggle(lang, val),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // List
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final lang = filtered[i];
                  final isSelected = chosen.contains(lang);
                  return CheckboxListTile(
                    title: Text(lang),
                    value: isSelected,
                    onChanged: (val) => _toggle(lang, val),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Footer actions
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, widget.selected),
                  child: const Text("Отмена"),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, chosen),
                  icon: const Icon(Icons.check),
                  label: const Text("Готово"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

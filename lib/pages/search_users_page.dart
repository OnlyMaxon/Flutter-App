import 'package:flutter/material.dart';
import 'package:apps/services/user_storage.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'profile_pagedemo.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  State<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final TextEditingController _controller = TextEditingController();

  List<UserRegistrationData> allUsers = [];
  List<UserRegistrationData> results = [];
  List<UserRegistrationData> _recommendations = [];
  UserRegistrationData? me;

  String? selectedCountry;
  String? selectedNationality;
  bool? isStudent;
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final users = await loadUsers();
    final current = await loadCurrentUser();

    me = current;
    allUsers = users.where((u) => u.email != current?.email).toList();

    _buildRecommendationsFromProfile();
    _resetToRecommendations();
    setState(() {});
  }

  // Рекомендации по профилю
  void _buildRecommendationsFromProfile() {
    if (me == null) {
      _recommendations = List.of(allUsers);
      return;
    }

    final meInterests = me!.interests.map((i) => i.toLowerCase()).toSet();
    final meLangs = me!.languages.toSet();
    final meCountry = (me!.country ?? "").toLowerCase();
    final meNat = (me!.nationality ?? "").toLowerCase();
    final meIsStudent = me!.isStudent == true;

    List<MapEntry<UserRegistrationData, int>> scored = allUsers.map((u) {
      int score = 0;

      final uInterests = u.interests.map((i) => i.toLowerCase()).toSet();
      score += meInterests.intersection(uInterests).length * 2;

      final uLangs = u.languages.toSet();
      score += meLangs.intersection(uLangs).length * 2;

      if ((u.country ?? "").toLowerCase() == meCountry && meCountry.isNotEmpty) score += 3;
      if ((u.nationality ?? "").toLowerCase() == meNat && meNat.isNotEmpty) score += 1;
      if ((u.isStudent == true) == meIsStudent) score += 1;

      return MapEntry(u, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    _recommendations = scored.map((e) => e.key).toList();
  }

  void _apply() {
    final q = _controller.text.trim().toLowerCase();
    final hasFilters = selectedCountry != null ||
        selectedNationality != null ||
        isStudent != null ||
        selectedLanguage != null;

    if (q.isEmpty && !hasFilters) {
      _resetToRecommendations();
      return;
    }

    results = allUsers.where((u) {
      final byQuery = q.isEmpty
          || (u.nickname?.toLowerCase().contains(q) ?? false)
          || u.interests.any((i) => i.toLowerCase().contains(q));

      final byCountry = selectedCountry == null || u.country == selectedCountry;
      final byNationality = selectedNationality == null || u.nationality == selectedNationality;
      final byStudent = isStudent == null || u.isStudent == isStudent;
      final byLanguage = selectedLanguage == null || u.languages.contains(selectedLanguage);

      return byQuery && byCountry && byNationality && byStudent && byLanguage;
    }).toList();

    setState(() {});
  }

  void _resetToRecommendations() {
    results = List.of(_recommendations);
    setState(() {});
  }

  List<String> _countries() =>
      allUsers.map((u) => u.country ?? "")
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  List<String> _nationalities() =>
      allUsers.map((u) => u.nationality ?? "")
          .where((n) => n.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  List<String> _languages() =>
      allUsers.expand((u) => u.languages)
          .where((l) => l.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  @override
  Widget build(BuildContext context) {
    final countries = _countries();
    final nationalities = _nationalities();
    final languages = _languages();

    final countryValue = countries.contains(selectedCountry) ? selectedCountry : null;
    final nationalityValue = nationalities.contains(selectedNationality) ? selectedNationality : null;
    final languageValue = languages.contains(selectedLanguage) ? selectedLanguage : null;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Поиск",
            border: InputBorder.none,
          ),
          onChanged: (_) => _apply(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Выберите человека и начните диалог")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Фильтры
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                DropdownButton<String>(
                  hint: const Text("Страна"),
                  value: countryValue,
                  items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) { setState(() => selectedCountry = v); _apply(); },
                ),
                DropdownButton<String>(
                  hint: const Text("Национальность"),
                  value: nationalityValue,
                  items: nationalities.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                  onChanged: (v) { setState(() => selectedNationality = v); _apply(); },
                ),
                DropdownButton<bool>(
                  hint: const Text("Студент"),
                  value: isStudent,
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Да")),
                    DropdownMenuItem(value: false, child: Text("Нет")),
                  ],
                  onChanged: (v) { setState(() => isStudent = v); _apply(); },
                ),
                DropdownButton<String>(
                  hint: const Text("Язык"),
                  value: languageValue,
                  items: languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) { setState(() => selectedLanguage = v); _apply(); },
                ),
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    selectedCountry = null;
                    selectedNationality = null;
                    isStudent = null;
                    selectedLanguage = null;
                    _resetToRecommendations();
                  },
                  child: const Text("Сброс"),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Результаты
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text("Нет совпадений"))
                : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                final u = results[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(u.nickname?.isNotEmpty == true
                        ? u.nickname![0].toUpperCase()
                        : "?"),
                  ),
                  title: Text(u.nickname ?? u.email),
                  subtitle: Text(
                    "${u.country ?? ""}"
                        "${u.languages.isNotEmpty ? " • ${u.languages.join(", ")}" : ""}",
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePageDemo(user: u)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

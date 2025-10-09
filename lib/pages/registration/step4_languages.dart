import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart';

class Step4Languages extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Languages({
    super.key,
    required this.draft,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Languages> createState() => _Step4LanguagesState();
}

class _Step4LanguagesState extends State<Step4Languages> {
  final List<String> allLanguages = const [
    'Русский', 'Польский', 'Английский', 'Украинский', 'Немецкий',
    'Азербайджанский', 'Французский', 'Испанский', 'Итальянский', 'Китайский',
    'Японский', 'Корейский', 'Чешский', 'Словацкий', 'Литовский', 'Латышский',
    'Эстонский', 'Турецкий', 'Арабский', 'Португальский', 'Греческий',
    'Венгерский', 'Финский', 'Шведский', 'Норвежский', 'Датский', 'Хинди',
    'Бенгальский', 'Тайский', 'Вьетнамский', 'Иврит', 'Персидский', 'Узбекский',
    'Таджикский', 'Армянский', 'Грузинский', 'Белорусский', 'Сербский',
    'Хорватский', 'Болгарский', 'Румынский', 'Албанский', 'Македонский',
  ];

  late List<String> filteredLanguages;
  late List<String> selected;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selected = [...widget.draft.languages];
    filteredLanguages = List.from(allLanguages);

    searchCtrl.addListener(() {
      final query = searchCtrl.text.toLowerCase();
      setState(() {
        filteredLanguages = allLanguages
            .where((lang) => lang.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void toggle(String lang) {
    setState(() {
      if (selected.contains(lang)) {
        selected.remove(lang);
      } else {
        selected.add(lang);
      }
      widget.draft.languages = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Какие языки вы знаете?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: searchCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск языка...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = filteredLanguages[index];
                    final isSelected = selected.contains(lang);
                    return ListTile(
                      title: Text(
                        lang,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? const Color(0xFF1E88E5) : Colors.grey,
                      ),
                      onTap: () => toggle(lang),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: widget.onBack,
                    child: const Text('Назад'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: selected.isEmpty ? null : widget.onNext,
                    child: const Text(
                      'Далее',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

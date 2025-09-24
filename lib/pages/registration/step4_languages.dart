import 'package:flutter/material.dart';
import 'registration_data.dart';

class Step4Languages extends StatefulWidget {
  final UserRegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Languages({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Languages> createState() => _Step4LanguagesState();
}

class _Step4LanguagesState extends State<Step4Languages> {
  // Большой список языков
  final List<String> allLanguages = const [
    'Русский',
    'Польский',
    'Английский',
    'Украинский',
    'Немецкий',
    'Азербайджанский',
    'Французский',
    'Испанский',
    'Итальянский',
    'Китайский',
    'Японский',
    'Корейский',
    'Чешский',
    'Словацкий',
    'Литовский',
    'Латышский',
    'Эстонский',
    'Турецкий',
    'Арабский',
    'Португальский',
    'Греческий',
    'Венгерский',
    'Финский',
    'Шведский',
    'Норвежский',
    'Датский',
    'Хинди',
    'Бенгальский',
    'Тайский',
    'Вьетнамский',
    'Иврит',
    'Персидский',
    'Узбекский',
    'Таджикский',
    'Армянский',
    'Грузинский',
    'Белорусский',
    'Сербский',
    'Хорватский',
    'Болгарский',
    'Румынский',
    'Албанский',
    'Македонский',
  ];

  late List<String> filteredLanguages;
  late List<String> selected;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selected = [...widget.data.languages];
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Поле поиска
          TextField(
            controller: searchCtrl,
            decoration: const InputDecoration(
              hintText: 'Поиск языка...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),

          // Список языков с прокруткой
          Expanded(
            child: ListView.builder(
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                final lang = filteredLanguages[index];
                final isSelected = selected.contains(lang);
                return ListTile(
                  title: Text(lang),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : const Icon(Icons.circle_outlined),
                  onTap: () => toggle(lang),
                );
              },
            ),
          ),

          // Кнопки навигации
          Row(
            children: [
              TextButton(onPressed: widget.onBack, child: const Text('Назад')),
              const Spacer(),
              ElevatedButton(
                onPressed: selected.isEmpty
                    ? null
                    : () {
                  widget.data.languages = selected;
                  widget.onNext();
                },
                child: const Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

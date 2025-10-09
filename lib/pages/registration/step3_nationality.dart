import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart';

class Step3Nationality extends StatefulWidget {
  final RegistrationDraft draft;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Nationality({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Nationality> createState() => _Step3NationalityState();
}

class _Step3NationalityState extends State<Step3Nationality> {
  String? selected;

  final List<String> nationalities = const [
    'Русский', 'Украинский', 'Польский', 'Белорусский', 'Казахский',
    'Азербайджанский', 'Армянский', 'Грузинский', 'Латышский', 'Литовский',
    'Эстонский', 'Немецкий', 'Французский', 'Итальянский', 'Испанский',
    'Английский', 'Американский', 'Канадский', 'Турецкий', 'Китайский',
    'Японский', 'Корейский', 'Индийский', 'Другое',
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.draft.nationality;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Выберите национальность',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField<String>(
                value: selected,
                dropdownColor: const Color(0xFF1A1A1A),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Национальность',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: nationalities
                    .map((n) => DropdownMenuItem(
                  value: n,
                  child: Text(n, style: const TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (v) => setState(() => selected = v),
                validator: (v) => v == null ? 'Выберите национальность' : null,
              ),
              const Spacer(),
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
                    onPressed: () {
                      if (selected == null) return;
                      widget.draft.nationality = selected!;
                      widget.onChanged(selected!);
                      widget.onNext();
                    },
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

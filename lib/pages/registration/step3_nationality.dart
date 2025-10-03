import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart'; // 👈 теперь используем draft

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
    'Русский',
    'Украинский',
    'Польский',
    'Белорусский',
    'Казахский',
    'Азербайджанский',
    'Армянский',
    'Грузинский',
    'Латышский',
    'Литовский',
    'Эстонский',
    'Немецкий',
    'Французский',
    'Итальянский',
    'Испанский',
    'Английский',
    'Американский',
    'Канадский',
    'Турецкий',
    'Китайский',
    'Японский',
    'Корейский',
    'Индийский',
    'Другое',
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.draft.nationality; // 👈 берём из draft
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selected,
            decoration: const InputDecoration(labelText: 'Национальность'),
            items: nationalities
                .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                .toList(),
            onChanged: (v) => setState(() => selected = v),
            validator: (v) => v == null ? 'Выберите национальность' : null,
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(onPressed: widget.onBack, child: const Text('Назад')),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (selected == null) return;
                  widget.draft.nationality = selected; // 👈 сохраняем в draft
                  widget.onChanged(selected!);          // 👈 уведомляем flow
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

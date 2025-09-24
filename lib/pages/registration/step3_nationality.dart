import 'package:flutter/material.dart';
import 'registration_data.dart';

class Step3Nationality extends StatefulWidget {
  final UserRegistrationData data;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Nationality({
    super.key,
    required this.data,
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
    'Польский',
    'Украинский',
    'Азербайджанский',
    'Казахский',
    'Немецкий',
    'Английский',
    'Другое',
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.data.nationality;
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
                  widget.onChanged(selected!);
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

import 'package:flutter/material.dart';
import 'registration_data.dart';
class Step5Interests extends StatefulWidget {
  final UserRegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Interests({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step5Interests> createState() => _Step5InterestsState();
}

class _Step5InterestsState extends State<Step5Interests> {
  final List<String> base = const ['#taxi', '#student', '#life', '#bmw', '#tech', '#music'];
  late List<String> selected;
  final customCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selected = [...widget.data.interests];
  }

  void toggle(String tag) {
    setState(() {
      if (selected.contains(tag)) {
        selected.remove(tag);
      } else {
        selected.add(tag);
      }
    });
  }

  void addCustom() {
    var v = customCtrl.text.trim();
    if (v.isEmpty) return;
    if (!v.startsWith('#')) v = '#$v';
    setState(() {
      if (!selected.contains(v)) selected.add(v);
      customCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = {...base, ...selected}.toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: display.map((t) {
              final act = selected.contains(t);
              return ChoiceChip(
                label: Text(t),
                selected: act,
                onSelected: (_) => toggle(t),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: customCtrl,
                  decoration: const InputDecoration(hintText: 'Добавить интерес'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: addCustom, child: const Text('Добавить')),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(onPressed: widget.onBack, child: const Text('Назад')),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  widget.data.interests = selected;
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

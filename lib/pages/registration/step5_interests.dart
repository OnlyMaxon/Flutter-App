import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart';

class Step5Interests extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Interests({
    super.key,
    required this.draft,
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
    selected = [...widget.draft.interests];
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
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Выберите интересы',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: display.map((t) {
                  final act = selected.contains(t);
                  return ChoiceChip(
                    label: Text(
                      t,
                      style: TextStyle(
                        color: act ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: act,
                    selectedColor: const Color(0xFF1E88E5),
                    backgroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (_) => toggle(t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Добавить интерес',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: addCustom,
                    child: const Text(
                      'Добавить',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
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
                      widget.draft.interests = selected;
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

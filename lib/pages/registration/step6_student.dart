import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart';

class Step6Student extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step6Student({
    super.key,
    required this.draft,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step6Student> createState() => _Step6StudentState();
}

class _Step6StudentState extends State<Step6Student> {
  bool? isStudent;

  @override
  void initState() {
    super.initState();
    isStudent = widget.draft.isStudent;
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
                'Вы студент?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              RadioListTile<bool>(
                value: true,
                groupValue: isStudent,
                onChanged: (v) => setState(() => isStudent = v),
                title: const Text('Я студент', style: TextStyle(color: Colors.white)),
                activeColor: const Color(0xFF1E88E5),
                tileColor: const Color(0xFF1A1A1A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 12),
              RadioListTile<bool>(
                value: false,
                groupValue: isStudent,
                onChanged: (v) => setState(() => isStudent = v),
                title: const Text('Я не студент', style: TextStyle(color: Colors.white)),
                activeColor: const Color(0xFF1E88E5),
                tileColor: const Color(0xFF1A1A1A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    onPressed: isStudent == null
                        ? null
                        : () {
                      widget.draft.isStudent = isStudent!;
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

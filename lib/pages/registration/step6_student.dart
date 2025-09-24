import 'package:flutter/material.dart';
import 'registration_data.dart';

class Step6Student extends StatefulWidget {
  final UserRegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step6Student({
    super.key,
    required this.data,
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
    isStudent = widget.data.isStudent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          RadioListTile<bool>(
            value: true,
            groupValue: isStudent,
            onChanged: (v) => setState(() => isStudent = v),
            title: const Text('Я студент'),
          ),
          RadioListTile<bool>(
            value: false,
            groupValue: isStudent,
            onChanged: (v) => setState(() => isStudent = v),
            title: const Text('Я не студент'),
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(onPressed: widget.onBack, child: const Text('Назад')),
              const Spacer(),
              ElevatedButton(
                onPressed: isStudent == null
                    ? null
                    : () {
                  widget.data.isStudent = isStudent;
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

import 'package:flutter/material.dart';
import 'package:apps/services/registration_draft.dart'; // 👈 теперь используем draft

class StepAddNameSurname extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepAddNameSurname({
    super.key,
    required this.draft,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<StepAddNameSurname> createState() => _StepAddNameSurnameState();
}

class _StepAddNameSurnameState extends State<StepAddNameSurname> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameCtrl.text = widget.draft.firstName ?? '';
    _lastNameCtrl.text = widget.draft.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameCtrl,
              decoration: const InputDecoration(labelText: 'Имя'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Введите имя';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(labelText: 'Фамилия'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Введите фамилию';
                return null;
              },
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: widget.onBack,
                  child: const Text('Назад'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.draft.firstName = _firstNameCtrl.text.trim();
                      widget.draft.lastName = _lastNameCtrl.text.trim();
                      widget.onNext();
                    }
                  },
                  child: const Text('Далее'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

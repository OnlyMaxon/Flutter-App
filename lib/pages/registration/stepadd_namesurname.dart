import 'package:flutter/material.dart';
import '../../services/user_storage.dart';
import 'registration_data.dart';


class StepAddNameSurname extends StatefulWidget {
  final UserRegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepAddNameSurname({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<StepAddNameSurname> createState() => _StepAddNameSurnameState();
}

class _StepAddNameSurnameState extends State<StepAddNameSurname> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _saving = false;

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    widget.data.firstName = _firstNameController.text.trim();
    widget.data.lastName = _lastNameController.text.trim();

    // 👇 сохраняем как текущего пользователя (обновляем список)
    await saveCurrentUser(widget.data);

    if (!mounted) return;
    setState(() => _saving = false);

    widget.onNext();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "Имя",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Введите имя" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Фамилия",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Введите фамилию" : null,
              ),
              const SizedBox(height: 24),
              _saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveAndContinue,
                child: const Text("Далее"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

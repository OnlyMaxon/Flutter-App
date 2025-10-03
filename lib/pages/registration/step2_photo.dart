import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apps/services/registration_draft.dart'; // 👈 теперь используем draft

class Step2Photo extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const Step2Photo({
    super.key,
    required this.draft,
    required this.onSkip,
    required this.onNext,
  });

  @override
  State<Step2Photo> createState() => _Step2PhotoState();
}

class _Step2PhotoState extends State<Step2Photo> {
  File? _file;

  Future<void> _pick() async {
    final picker = ImagePicker();
    final res = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (res != null) {
      setState(() => _file = File(res.path));
      widget.draft.photoPath = res.path; // 👈 сохраняем в draft
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.draft.photoPath != null) {
      _file = File(widget.draft.photoPath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _file != null ? FileImage(_file!) : null,
            child: _file == null ? const Icon(Icons.person, size: 48) : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pick,
            icon: const Icon(Icons.photo),
            label: const Text('Добавить фото'),
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: const Text('Пропустить'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: widget.onNext,
                child: const Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

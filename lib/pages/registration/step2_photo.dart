import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apps/services/registration_draft.dart';

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
      widget.draft.photoPath = res.path;
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
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Добавьте фото профиля',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF1A1A1A),
                backgroundImage: _file != null ? FileImage(_file!) : null,
                child: _file == null
                    ? const Icon(Icons.person, size: 48, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _pick,
                icon: const Icon(Icons.photo, color: Colors.white),
                label: const Text(
                  'Добавить фото',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: widget.onSkip,
                    child: const Text('Пропустить'),
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
                    onPressed: widget.onNext,
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

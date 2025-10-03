import 'package:flutter/material.dart';
import 'package:apps/services/user_storage.dart';
import 'package:apps/services/registration_draft.dart'; // 👈 новый импорт

import 'registration_data.dart';
import 'step1_email_password.dart';
import 'step2_photo.dart';
import 'step3_nationality.dart';
import 'step4_languages.dart';
import 'step5_interests.dart';
import 'step6_student.dart';
import 'step7_nickname.dart';
import 'step8_status_country.dart';
import 'stepadd_namesurname.dart';

import 'package:apps/main.dart';

class RegistrationFlow extends StatefulWidget {
  const RegistrationFlow({super.key});

  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends State<RegistrationFlow> {
  final PageController _controller = PageController();

  // 👇 теперь используем черновик
  final RegistrationDraft draft = RegistrationDraft();

  int current = 0;

  void next() {
    if (current < steps.length - 1) {
      setState(() => current++);
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void back() {
    if (current > 0) {
      setState(() => current--);
      _controller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _finish() async {
    // 👇 собираем финального пользователя из draft
    final user = UserRegistrationData(
      email: draft.email,
      password: draft.password,
      photoPath: draft.photoPath,
      coverPath: draft.coverPath,
      nationality: draft.nationality,
      languages: draft.languages,
      interests: draft.interests,
      isStudent: draft.isStudent,
      nickname: draft.nickname,
      status: draft.status,
      country: draft.country,
      firstName: draft.firstName,
      lastName: draft.lastName,
      isLoggedIn: true,
    );

    // сохраняем в список пользователей (если новый)
    await addUser(user);

    // сохраняем как текущего
    await saveCurrentUser(user);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainPage()),
          (route) => false,
    );
  }

  void onNationalityChanged(String nationality) {
    draft.nationality = nationality;

    final Map<String, List<String>> defaultLanguagesByNationality = {
      'Русский': ['Русский', 'Английский'],
      'Украинский': ['Украинский', 'Русский', 'Английский'],
      'Польский': ['Польский', 'Английский'],
      'Казахский': ['Казахский', 'Русский', 'Английский'],
      'Азербайджанский': ['Азербайджанский', 'Русский'],
      'Немецкий': ['Немецкий', 'Английский'],
      'Английский': ['Английский'],
      'Армянский': ['Армянский', 'Русский'],
      'Грузинский': ['Грузинский', 'Русский'],
      'Белорусский': ['Белорусский', 'Русский', 'Английский'],
    };

    final suggested = defaultLanguagesByNationality[nationality];
    draft.languages = suggested ?? [];

    setState(() {});
  }

  late final List<Widget> steps = [
    Step1EmailPassword(draft: draft, onNext: next),
    StepAddNameSurname(draft: draft, onNext: next, onBack: back),
    Step2Photo(draft: draft, onSkip: next, onNext: next),
    Step3Nationality(draft: draft, onChanged: onNationalityChanged, onNext: next, onBack: back),
    Step4Languages(draft: draft, onNext: next, onBack: back),
    Step5Interests(draft: draft, onNext: next, onBack: back),
    Step6Student(draft: draft, onNext: next, onBack: back),
    Step7Nickname(draft: draft, onNext: next, onBack: back),
    Step8StatusCountry(draft: draft, onNext: next, onBack: back),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: current > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: back)
            : null,
      ),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: steps,
      ),
    );
  }
}

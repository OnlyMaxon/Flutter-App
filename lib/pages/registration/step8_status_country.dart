import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:apps/services/registration_draft.dart'; // 👈 теперь используем draft

class Step8StatusCountry extends StatefulWidget {
  final RegistrationDraft draft;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step8StatusCountry({
    super.key,
    required this.draft,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step8StatusCountry> createState() => _Step8StatusCountryState();
}

class _Step8StatusCountryState extends State<Step8StatusCountry> {
  String? selectedCountry;
  bool _loading = false;
  String? _error;

  final List<String> countries = [
    'Россия', 'Польша', 'Украина', 'Беларусь', 'Казахстан',
    'Азербайджан', 'Армения', 'Грузия', 'Литва', 'Латвия', 'Эстония',
    'Германия', 'Франция', 'Италия', 'Испания', 'Португалия',
    'Великобритания', 'США', 'Канада', 'Мексика', 'Бразилия',
    'Аргентина', 'Китай', 'Япония', 'Корея Южная', 'Индия',
    'Турция', 'Израиль', 'Египет', 'ОАЭ', 'Австралия', 'Новая Зеландия',
  ];

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.draft.country;
    _autoFillCountry();
  }

  Future<void> _autoFillCountry() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Службы геолокации отключены';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Разрешение на геолокацию отклонено';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Разрешение навсегда отклонено. Включите его вручную.';
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw 'Таймаут при получении координат';
      });

      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isEmpty) throw 'Не удалось определить страну';

      final c = placemarks.first.country;
      if (c == null || c.isEmpty) throw 'Страна не найдена';

      debugPrint("Определена страна по GPS: $c");

      if (!countries.contains(c)) {
        countries.add(c);
      }

      if (!mounted) return;
      setState(() {
        selectedCountry = c;
        widget.draft.country = c; // 👈 сохраняем в draft
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedCountry,
            decoration: const InputDecoration(labelText: 'Страна'),
            items: countries
                .map((country) => DropdownMenuItem(
              value: country,
              child: Text(country),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCountry = value;
                widget.draft.country = value; // 👈 сохраняем в draft
              });
            },
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _autoFillCountry,
              child: const Text("Повторить определение страны"),
            ),
          ],
          const Spacer(),
          Row(
            children: [
              TextButton(onPressed: widget.onBack, child: const Text('Назад')),
              const Spacer(),
              ElevatedButton(
                onPressed: selectedCountry == null ? null : widget.onNext,
                child: const Text('Завершить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

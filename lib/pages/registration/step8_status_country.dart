import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:apps/services/registration_draft.dart';

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
        widget.draft.country = c;
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Выберите страну проживания',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                dropdownColor: const Color(0xFF1A1A1A),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Страна',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: countries
                    .map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country, style: const TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    widget.draft.country = value;
                  });
                },
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _autoFillCountry,
                  child: const Text('Повторить определение страны'),
                ),
              ],
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
                    onPressed: selectedCountry == null ? null : widget.onNext,
                    child: const Text(
                      'Завершить',
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

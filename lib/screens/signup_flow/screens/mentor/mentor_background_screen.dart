import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../models/signup_data_new.dart';

class MentorBackgroundScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MentorBackgroundScreen({
    super.key,
    required this.signUpData,
  });

  @override
  State<MentorBackgroundScreen> createState() => _MentorBackgroundScreenState();
}

class _MentorBackgroundScreenState extends State<MentorBackgroundScreen> {
  final _ageController = TextEditingController();
  final _hometownCityController = TextEditingController();
  final _hometownStateController = TextEditingController();
  String? _ageError;
  String? _hometownCityError;
  String? _hometownStateError;

  @override
  void initState() {
    super.initState();
    _ageController.text =
        widget.signUpData.mentorAge?.toString() ?? '';
    _hometownCityController.text = widget.signUpData.mentorHometownCity ?? '';
    _hometownStateController.text = widget.signUpData.mentorHometownState ?? '';
  }

  @override
  void dispose() {
    _ageController.dispose();
    _hometownCityController.dispose();
    _hometownStateController.dispose();
    super.dispose();
  }

  void _validateAge() {
    setState(() {
      if (_ageController.text.isEmpty) {
        _ageError = 'Age is required';
      } else {
        final age = int.tryParse(_ageController.text);
        if (age == null) {
          _ageError = 'Please enter a valid number';
        } else if (age < 18 || age > 100) {
          _ageError = 'Age must be between 18 and 100';
        } else {
          _ageError = null;
        }
      }
    });
  }

  void _validateHometownCity() {
    setState(() {
      if (_hometownCityController.text.isEmpty) {
        _hometownCityError = 'Hometown city is required';
      } else {
        _hometownCityError = null;
      }
    });
  }

  void _validateHometownState() {
    setState(() {
      if (_hometownStateController.text.isEmpty) {
        _hometownStateError = 'Hometown state is required';
      } else {
        _hometownStateError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Background',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us about yourself',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Age
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            labelText: 'Age',
            hintText: '25',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.cake),
            errorText: _ageError,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            widget.signUpData.mentorAge = int.tryParse(value);
            if (_ageError != null) {
              _validateAge();
            }
          },
          onTap: () {
            setState(() {
              _ageError = null;
            });
          },
          onEditingComplete: _validateAge,
        ),
        const SizedBox(height: 16),

        // Hometown City
        TextField(
          controller: _hometownCityController,
          decoration: InputDecoration(
            labelText: 'Hometown City',
            hintText: 'Fortaleza',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_city),
            errorText: _hometownCityError,
          ),
          onChanged: (value) {
            widget.signUpData.mentorHometownCity = value;
            if (_hometownCityError != null) {
              _validateHometownCity();
            }
          },
          onTap: () {
            setState(() {
              _hometownCityError = null;
            });
          },
          onEditingComplete: _validateHometownCity,
        ),
        const SizedBox(height: 16),

        // Hometown State
        TextField(
          controller: _hometownStateController,
          decoration: InputDecoration(
            labelText: 'Hometown State',
            hintText: 'CE',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.map),
            errorText: _hometownStateError,
          ),
          onChanged: (value) {
            widget.signUpData.mentorHometownState = value;
            if (_hometownStateError != null) {
              _validateHometownState();
            }
          },
          onTap: () {
            setState(() {
              _hometownStateError = null;
            });
          },
          onEditingComplete: _validateHometownState,
        ),
      ],
    );
  }
}


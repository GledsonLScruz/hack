import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MenteeIdentityScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MenteeIdentityScreen({super.key, required this.signUpData});

  @override
  State<MenteeIdentityScreen> createState() => _MenteeIdentityScreenState();
}

class _MenteeIdentityScreenState extends State<MenteeIdentityScreen> {
  final _genderController = TextEditingController();
  final _colorRaceController = TextEditingController();
  String? _selectedGenderOption;
  String? _selectedColorRaceOption;
  String? _selectedDisabilityOption;
  String? _genderError;
  String? _colorRaceError;
  String? _disabilityError;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
    'Self-describe',
  ];

  final List<String> _colorRaceOptions = [
    'White',
    'Black',
    'Asian',
    'Indigenous',
    'Mixed',
    'Prefer not to say',
    'Self-describe',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.signUpData.menteeGender != null) {
      if (_genderOptions.contains(widget.signUpData.menteeGender)) {
        _selectedGenderOption = widget.signUpData.menteeGender;
      } else {
        _selectedGenderOption = 'Self-describe';
        _genderController.text = widget.signUpData.menteeGender!;
      }
    }
    if (widget.signUpData.menteeColorRace != null) {
      if (_colorRaceOptions.contains(widget.signUpData.menteeColorRace)) {
        _selectedColorRaceOption = widget.signUpData.menteeColorRace;
      } else {
        _selectedColorRaceOption = 'Self-describe';
        _colorRaceController.text = widget.signUpData.menteeColorRace!;
      }
    }
    if (widget.signUpData.menteeIsDisabled != null) {
      _selectedDisabilityOption = widget.signUpData.menteeIsDisabled!
          ? 'Yes'
          : 'No';
    }
  }

  @override
  void dispose() {
    _genderController.dispose();
    _colorRaceController.dispose();
    super.dispose();
  }

  void _validateGender() {
    setState(() {
      if (_selectedGenderOption == null) {
        _genderError = 'Gender is required';
      } else if (_selectedGenderOption == 'Self-describe' &&
          _genderController.text.isEmpty) {
        _genderError = 'Please describe your gender';
      } else {
        _genderError = null;
      }
    });
  }

  void _validateColorRace() {
    setState(() {
      if (_selectedColorRaceOption == null) {
        _colorRaceError = 'Color/Race is required';
      } else if (_selectedColorRaceOption == 'Self-describe' &&
          _colorRaceController.text.isEmpty) {
        _colorRaceError = 'Please describe your color/race';
      } else {
        _colorRaceError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Identity',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Help us understand your background',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Gender
        const Text(
          'Gender',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGenderOption,
          decoration: InputDecoration(
            hintText: 'Select your gender',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person_outline),
            errorText: _genderError,
          ),
          items: _genderOptions.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGenderOption = value;
              _genderError = null;
              if (value != 'Self-describe') {
                widget.signUpData.menteeGender = value;
                _genderController.clear();
              }
            });
          },
        ),
        if (_selectedGenderOption == 'Self-describe') ...[
          const SizedBox(height: 12),
          TextField(
            controller: _genderController,
            decoration: const InputDecoration(
              labelText: 'Please describe',
              hintText: 'Enter your gender',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              widget.signUpData.menteeGender = value;
              if (_genderError != null) {
                _validateGender();
              }
            },
            onEditingComplete: _validateGender,
          ),
        ],
        const SizedBox(height: 24),

        // Color/Race
        const Text(
          'Color/Race',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedColorRaceOption,
          decoration: InputDecoration(
            hintText: 'Select your color/race',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.people_outline),
            errorText: _colorRaceError,
          ),
          items: _colorRaceOptions.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedColorRaceOption = value;
              _colorRaceError = null;
              if (value != 'Self-describe') {
                widget.signUpData.menteeColorRace = value;
                _colorRaceController.clear();
              }
            });
          },
        ),
        if (_selectedColorRaceOption == 'Self-describe') ...[
          const SizedBox(height: 12),
          TextField(
            controller: _colorRaceController,
            decoration: const InputDecoration(
              labelText: 'Please describe',
              hintText: 'Enter your color/race',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              widget.signUpData.menteeColorRace = value;
              if (_colorRaceError != null) {
                _validateColorRace();
              }
            },
            onEditingComplete: _validateColorRace,
          ),
        ],
        const SizedBox(height: 24),

        // Disability
        const Text(
          'Person with disability',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDisabilityOption,
          decoration: InputDecoration(
            hintText: 'Select an option',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.accessible),
            errorText: _disabilityError,
          ),
          items: const [
            DropdownMenuItem(value: 'Yes', child: Text('Yes')),
            DropdownMenuItem(value: 'No', child: Text('No')),
            DropdownMenuItem(
              value: 'Prefer not to say',
              child: Text('Prefer not to say'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDisabilityOption = value;
              _disabilityError = null;
              if (value == 'Yes') {
                widget.signUpData.menteeIsDisabled = true;
              } else if (value == 'No') {
                widget.signUpData.menteeIsDisabled = false;
              } else {
                widget.signUpData.menteeIsDisabled = null;
              }
            });
          },
        ),
      ],
    );
  }
}

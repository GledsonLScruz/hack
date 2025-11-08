import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MentorEducationScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MentorEducationScreen({
    super.key,
    required this.signUpData,
  });

  @override
  State<MentorEducationScreen> createState() => _MentorEducationScreenState();
}

class _MentorEducationScreenState extends State<MentorEducationScreen> {
  final _highSchoolNameController = TextEditingController();
  final _highSchoolLocationController = TextEditingController();
  String? _selectedFamilyIncome;
  String? _selectedEducationLevel;
  String? _familyIncomeError;
  String? _educationLevelError;
  String? _highSchoolNameError;
  String? _highSchoolLocationError;

  final List<String> _familyIncomeOptions = [
    'Low',
    'Medium',
    'High',
    'Prefer not to say',
  ];

  final List<String> _educationLevelOptions = [
    'High School',
    'Some College',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFamilyIncome = widget.signUpData.mentorFamilyIncome;
    _selectedEducationLevel = widget.signUpData.mentorEducationLevel;
    _highSchoolNameController.text =
        widget.signUpData.mentorHighSchoolName ?? '';
    _highSchoolLocationController.text =
        widget.signUpData.mentorHighSchoolLocation ?? '';
  }

  @override
  void dispose() {
    _highSchoolNameController.dispose();
    _highSchoolLocationController.dispose();
    super.dispose();
  }

  void _validateHighSchoolName() {
    setState(() {
      if (_highSchoolNameController.text.isEmpty) {
        _highSchoolNameError = 'High school name is required';
      } else {
        _highSchoolNameError = null;
      }
    });
  }

  void _validateHighSchoolLocation() {
    setState(() {
      if (_highSchoolLocationController.text.isEmpty) {
        _highSchoolLocationError = 'High school location is required';
      } else {
        _highSchoolLocationError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Education',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us about your educational background',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Family Income During School
        const Text(
          'Family Income During School',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedFamilyIncome,
          decoration: InputDecoration(
            hintText: 'Select family income level',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.account_balance_wallet),
            errorText: _familyIncomeError,
          ),
          items: _familyIncomeOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedFamilyIncome = value;
              _familyIncomeError = null;
              widget.signUpData.mentorFamilyIncome = value;
            });
          },
        ),
        const SizedBox(height: 24),

        // Education Level
        const Text(
          'Education Level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEducationLevel,
          decoration: InputDecoration(
            hintText: 'Select your education level',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.school),
            errorText: _educationLevelError,
          ),
          items: _educationLevelOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEducationLevel = value;
              _educationLevelError = null;
              widget.signUpData.mentorEducationLevel = value;
            });
          },
        ),
        const SizedBox(height: 24),

        // High School Name
        TextField(
          controller: _highSchoolNameController,
          decoration: InputDecoration(
            labelText: 'High School Name',
            hintText: 'Enter your high school name',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.school_outlined),
            errorText: _highSchoolNameError,
          ),
          onChanged: (value) {
            widget.signUpData.mentorHighSchoolName = value;
            if (_highSchoolNameError != null) {
              _validateHighSchoolName();
            }
          },
          onTap: () {
            setState(() {
              _highSchoolNameError = null;
            });
          },
          onEditingComplete: _validateHighSchoolName,
        ),
        const SizedBox(height: 16),

        // High School Location
        TextField(
          controller: _highSchoolLocationController,
          decoration: InputDecoration(
            labelText: 'High School Location',
            hintText: 'City/State',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on),
            errorText: _highSchoolLocationError,
            helperText: 'e.g., Fortaleza/CE',
          ),
          onChanged: (value) {
            widget.signUpData.mentorHighSchoolLocation = value;
            if (_highSchoolLocationError != null) {
              _validateHighSchoolLocation();
            }
          },
          onTap: () {
            setState(() {
              _highSchoolLocationError = null;
            });
          },
          onEditingComplete: _validateHighSchoolLocation,
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MenteeSchoolScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MenteeSchoolScreen({super.key, required this.signUpData});

  @override
  State<MenteeSchoolScreen> createState() => _MenteeSchoolScreenState();
}

class _MenteeSchoolScreenState extends State<MenteeSchoolScreen> {
  final _schoolNameController = TextEditingController();
  final _schoolLocationController = TextEditingController();
  String? _schoolNameError;
  String? _schoolLocationError;

  @override
  void initState() {
    super.initState();
    _schoolNameController.text = widget.signUpData.menteeSchoolName ?? '';
    _schoolLocationController.text =
        widget.signUpData.menteeSchoolLocation ?? '';
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _schoolLocationController.dispose();
    super.dispose();
  }

  void _validateSchoolName() {
    setState(() {
      if (_schoolNameController.text.isEmpty) {
        _schoolNameError = 'School name is required';
      } else {
        _schoolNameError = null;
      }
    });
  }

  void _validateSchoolLocation() {
    setState(() {
      if (_schoolLocationController.text.isEmpty) {
        _schoolLocationError = 'School location is required';
      } else {
        _schoolLocationError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'School',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us about your school',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // School Name
        TextField(
          controller: _schoolNameController,
          decoration: InputDecoration(
            labelText: 'School Name',
            hintText: 'Enter your school name',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.school),
            errorText: _schoolNameError,
          ),
          onChanged: (value) {
            widget.signUpData.menteeSchoolName = value;
            if (_schoolNameError != null) {
              _validateSchoolName();
            }
          },
          onTap: () {
            setState(() {
              _schoolNameError = null;
            });
          },
          onEditingComplete: _validateSchoolName,
        ),
        const SizedBox(height: 16),

        // School Location
        TextField(
          controller: _schoolLocationController,
          decoration: InputDecoration(
            labelText: 'School Location',
            hintText: 'City/State or Neighborhood',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on),
            errorText: _schoolLocationError,
            helperText: 'e.g., Fortaleza/CE or Aldeota',
          ),
          onChanged: (value) {
            widget.signUpData.menteeSchoolLocation = value;
            if (_schoolLocationError != null) {
              _validateSchoolLocation();
            }
          },
          onTap: () {
            setState(() {
              _schoolLocationError = null;
            });
          },
          onEditingComplete: _validateSchoolLocation,
        ),
      ],
    );
  }
}

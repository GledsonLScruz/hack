import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MenteeInterestsScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MenteeInterestsScreen({
    super.key,
    required this.signUpData,
  });

  @override
  State<MenteeInterestsScreen> createState() => _MenteeInterestsScreenState();
}

class _MenteeInterestsScreenState extends State<MenteeInterestsScreen> {
  final _academicInterestsController = TextEditingController();
  final _strengthsController = TextEditingController();
  final _areasOfInterestController = TextEditingController();
  String? _academicInterestsError;
  String? _strengthsError;
  String? _areasOfInterestError;

  @override
  void initState() {
    super.initState();
    _academicInterestsController.text =
        widget.signUpData.menteeAcademicInterests ?? '';
    _strengthsController.text = widget.signUpData.menteeStrengths ?? '';
    _areasOfInterestController.text =
        widget.signUpData.menteeAreasOfInterest ?? '';
  }

  @override
  void dispose() {
    _academicInterestsController.dispose();
    _strengthsController.dispose();
    _areasOfInterestController.dispose();
    super.dispose();
  }

  void _validateAcademicInterests() {
    setState(() {
      if (_academicInterestsController.text.isEmpty) {
        _academicInterestsError = 'Academic interests are required';
      } else {
        _academicInterestsError = null;
      }
    });
  }

  void _validateStrengths() {
    setState(() {
      if (_strengthsController.text.isEmpty) {
        _strengthsError = 'Strengths are required';
      } else {
        _strengthsError = null;
      }
    });
  }

  void _validateAreasOfInterest() {
    setState(() {
      if (_areasOfInterestController.text.isEmpty) {
        _areasOfInterestError = 'Areas of interest are required';
      } else {
        _areasOfInterestError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Interests & Strengths',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Share what you love and what you\'re good at',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Academic Interests
        TextField(
          controller: _academicInterestsController,
          decoration: InputDecoration(
            labelText: 'Academic Interests',
            hintText: 'Math, Science, Literature...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.book),
            errorText: _academicInterestsError,
            helperText: 'What subjects do you enjoy?',
          ),
          maxLines: 3,
          onChanged: (value) {
            widget.signUpData.menteeAcademicInterests = value;
            if (_academicInterestsError != null) {
              _validateAcademicInterests();
            }
          },
          onTap: () {
            setState(() {
              _academicInterestsError = null;
            });
          },
          onEditingComplete: _validateAcademicInterests,
        ),
        const SizedBox(height: 16),

        // Strengths
        TextField(
          controller: _strengthsController,
          decoration: InputDecoration(
            labelText: 'Strengths',
            hintText: 'Problem solving, creativity, teamwork...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.star),
            errorText: _strengthsError,
            helperText: 'What are you naturally good at?',
          ),
          maxLines: 3,
          onChanged: (value) {
            widget.signUpData.menteeStrengths = value;
            if (_strengthsError != null) {
              _validateStrengths();
            }
          },
          onTap: () {
            setState(() {
              _strengthsError = null;
            });
          },
          onEditingComplete: _validateStrengths,
        ),
        const SizedBox(height: 16),

        // Areas of Interest
        TextField(
          controller: _areasOfInterestController,
          decoration: InputDecoration(
            labelText: 'Areas of Interest',
            hintText: 'Technology, arts, sports, social causes...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.interests),
            errorText: _areasOfInterestError,
            helperText: 'What topics or fields interest you?',
          ),
          maxLines: 3,
          onChanged: (value) {
            widget.signUpData.menteeAreasOfInterest = value;
            if (_areasOfInterestError != null) {
              _validateAreasOfInterest();
            }
          },
          onTap: () {
            setState(() {
              _areasOfInterestError = null;
            });
          },
          onEditingComplete: _validateAreasOfInterest,
        ),
      ],
    );
  }
}


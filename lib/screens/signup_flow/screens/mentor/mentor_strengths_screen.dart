import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MentorStrengthsScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MentorStrengthsScreen({
    super.key,
    required this.signUpData,
  });

  @override
  State<MentorStrengthsScreen> createState() => _MentorStrengthsScreenState();
}

class _MentorStrengthsScreenState extends State<MentorStrengthsScreen> {
  final _strengthsController = TextEditingController();
  final _areasOfInterestController = TextEditingController();
  String? _strengthsError;
  String? _areasOfInterestError;

  @override
  void initState() {
    super.initState();
    _strengthsController.text = widget.signUpData.mentorStrengths ?? '';
    _areasOfInterestController.text =
        widget.signUpData.mentorAreasOfInterest ?? '';
  }

  @override
  void dispose() {
    _strengthsController.dispose();
    _areasOfInterestController.dispose();
    super.dispose();
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
          'Strengths & Focus',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Share what you excel at and what you\'re passionate about',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Strengths
        TextField(
          controller: _strengthsController,
          decoration: InputDecoration(
            labelText: 'Strengths',
            hintText: 'Leadership, communication, technical skills...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.star),
            errorText: _strengthsError,
            helperText: 'What are your key strengths?',
          ),
          maxLines: 4,
          onChanged: (value) {
            widget.signUpData.mentorStrengths = value;
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
            hintText: 'Technology, business, education, social impact...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.interests),
            errorText: _areasOfInterestError,
            helperText: 'What topics or fields are you passionate about?',
          ),
          maxLines: 4,
          onChanged: (value) {
            widget.signUpData.mentorAreasOfInterest = value;
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


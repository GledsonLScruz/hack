import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MentorActivitiesScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MentorActivitiesScreen({
    super.key,
    required this.signUpData,
  });

  @override
  State<MentorActivitiesScreen> createState() =>
      _MentorActivitiesScreenState();
}

class _MentorActivitiesScreenState extends State<MentorActivitiesScreen> {
  final _activitiesController = TextEditingController();
  String? _activitiesError;

  @override
  void initState() {
    super.initState();
    _activitiesController.text =
        widget.signUpData.mentorExtracurricularActivities ?? '';
  }

  @override
  void dispose() {
    _activitiesController.dispose();
    super.dispose();
  }

  void _validateActivities() {
    setState(() {
      if (_activitiesController.text.isEmpty) {
        _activitiesError = 'Extracurricular activities are required';
      } else {
        _activitiesError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Activities',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us about your extracurricular activities',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Extracurricular Activities
        TextField(
          controller: _activitiesController,
          decoration: InputDecoration(
            labelText: 'Extracurricular Activities',
            hintText:
                'Volunteering, sports, clubs, community involvement...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.sports_soccer),
            errorText: _activitiesError,
            helperText:
                'What activities have you been involved in outside of work/school?',
          ),
          maxLines: 6,
          onChanged: (value) {
            widget.signUpData.mentorExtracurricularActivities = value;
            if (_activitiesError != null) {
              _validateActivities();
            }
          },
          onTap: () {
            setState(() {
              _activitiesError = null;
            });
          },
          onEditingComplete: _validateActivities,
        ),
      ],
    );
  }
}


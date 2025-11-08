import 'package:flutter/material.dart';
import '../../models/signup_data.dart';

class Part2AdditionalInfo extends StatefulWidget {
  final SignUpData signUpData;
  final Function(SignUpData) onDataChanged;
  final GlobalKey<FormState>? formKey;

  const Part2AdditionalInfo({
    super.key,
    required this.signUpData,
    required this.onDataChanged,
    this.formKey,
  });

  @override
  State<Part2AdditionalInfo> createState() => _Part2AdditionalInfoState();
}

class _Part2AdditionalInfoState extends State<Part2AdditionalInfo> {
  final _skillsController = TextEditingController();
  final _extracurricularController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _academicSubjects = [
    'Math',
    'Physics',
    'Biology',
    'Portuguese',
    'Chemistry',
    'History',
    'Geography',
    'English',
    'Literature',
    'Art',
    'Music',
    'Physical Education',
  ];

  final List<String> _goalOptions = [
    'Start working soon',
    'Study more',
    'Become an entrepreneur',
  ];

  @override
  void initState() {
    super.initState();
    _skillsController.text = widget.signUpData.skills ?? '';
    _extracurricularController.text =
        widget.signUpData.extracurricularActivities ?? '';
  }

  @override
  void dispose() {
    _skillsController.dispose();
    _extracurricularController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.onDataChanged(widget.signUpData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey ?? _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Education Level
            DropdownButtonFormField<String>(
              value: widget.signUpData.educationLevel,
              decoration: const InputDecoration(
                labelText: 'Education Level *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Elementary Education',
                  child: Text('Elementary Education'),
                ),
                DropdownMenuItem(
                  value: 'High School',
                  child: Text('High School'),
                ),
                DropdownMenuItem(
                  value: 'Higher Education',
                  child: Text('Higher Education'),
                ),
                DropdownMenuItem(
                  value: 'Postgraduate Education',
                  child: Text('Postgraduate Education'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  widget.signUpData.educationLevel = value;
                  _updateData();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an education level';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Academic Interests
            const Text(
              'Academic Interests (Favorite Subjects) *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _academicSubjects.map((subject) {
                final isSelected = widget.signUpData.academicInterests.contains(
                  subject,
                );
                return FilterChip(
                  label: Text(subject),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.signUpData.academicInterests.add(subject);
                      } else {
                        widget.signUpData.academicInterests.remove(subject);
                      }
                      _updateData();
                    });
                  },
                );
              }).toList(),
            ),
            if (widget.signUpData.academicInterests.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Please select at least one subject',
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            // Skills
            TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills (technical, creative, social) *',
                hintText:
                    'I like to calculate things, I like to meet animals...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Skills cannot be empty';
                }
                return null;
              },
              onChanged: (value) {
                widget.signUpData.skills = value;
                _updateData();
              },
            ),
            const SizedBox(height: 24),

            // Financial Situation
            DropdownButtonFormField<String>(
              value: widget.signUpData.financialSituation,
              decoration: const InputDecoration(
                labelText: 'Financial Situation *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'High', child: Text('High')),
                DropdownMenuItem(
                  value: 'Prefer not to say',
                  child: Text('Prefer not to say'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  widget.signUpData.financialSituation = value;
                  _updateData();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a financial situation';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Availability
            DropdownButtonFormField<String>(
              value: widget.signUpData.availability,
              decoration: const InputDecoration(
                labelText: 'Availability *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              items: const [
                DropdownMenuItem(value: 'full-time', child: Text('Full-time')),
                DropdownMenuItem(value: 'part-time', child: Text('Part-time')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.signUpData.availability = value;
                  _updateData();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select availability';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Goals
            const Text(
              'Goals *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _goalOptions.map((goal) {
                final isSelected = widget.signUpData.goals.contains(goal);
                return FilterChip(
                  label: Text(goal),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.signUpData.goals.add(goal);
                      } else {
                        widget.signUpData.goals.remove(goal);
                      }
                      _updateData();
                    });
                  },
                );
              }).toList(),
            ),
            if (widget.signUpData.goals.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Please select at least one goal',
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            // Restrictions
            TextFormField(
              initialValue: widget.signUpData.restrictions,
              decoration: const InputDecoration(
                labelText: 'Restrictions (mobility, special needs)',
                hintText: 'Enter any restrictions if applicable',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
              ),
              maxLines: 2,
              onChanged: (value) {
                widget.signUpData.restrictions = value;
                _updateData();
              },
            ),
            const SizedBox(height: 24),

            // Where I want to study/work
            DropdownButtonFormField<String>(
              value: widget.signUpData.studyWorkPreference,
              decoration: const InputDecoration(
                labelText: 'Where I want to study/work *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
              ),
              items: const [
                DropdownMenuItem(value: 'Closest', child: Text('Closest')),
                DropdownMenuItem(
                  value: 'Does not matter',
                  child: Text('Does not matter'),
                ),
                DropdownMenuItem(value: 'Remote', child: Text('Remote')),
                DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.signUpData.studyWorkPreference = value;
                  _updateData();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a preference';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Extracurricular Activities
            TextFormField(
              controller: _extracurricularController,
              decoration: const InputDecoration(
                labelText: 'Extracurricular Activities',
                hintText:
                    'Provide details about your extracurricular activities',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sports_soccer),
              ),
              maxLines: 4,
              onChanged: (value) {
                widget.signUpData.extracurricularActivities = value;
                _updateData();
              },
            ),
          ],
        ),
      ),
    );
  }

  bool validate() {
    final formKeyToUse = widget.formKey ?? _formKey;
    final isValid = formKeyToUse.currentState?.validate() ?? false;
    if (!isValid) return false;

    if (widget.signUpData.academicInterests.isEmpty) {
      return false;
    }

    if (widget.signUpData.goals.isEmpty) {
      return false;
    }

    return true;
  }
}

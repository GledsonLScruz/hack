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
  final List<String> _selectedStrengths = [];
  final _areasOfInterestController = TextEditingController();
  String? _areasOfInterestError;

  final Map<String, Color> _strengths = {
    'Communication': const Color(0xFF6366F1),
    'Leadership': const Color(0xFF8B5CF6),
    'Teamwork': const Color(0xFF3B82F6),
    'Problem Solving': const Color(0xFF0EA5E9),
    'Creativity': const Color(0xFF06B6D4),
    'Adaptability': const Color(0xFF10B981),
    'Empathy': const Color(0xFF14B8A6),
    'Critical Thinking': const Color(0xFF22C55E),
    'Organization': const Color(0xFFF59E0B),
    'Time Management': const Color(0xFFF97316),
    'Responsibility': const Color(0xFFEF4444),
    'Emotional Intelligence': const Color(0xFFEC4899),
    'Decision Making': const Color(0xFFD946EF),
    'Self-Motivation': const Color(0xFFA855F7),
    'Initiative': const Color(0xFF9333EA),
    'Attention to Detail': const Color(0xFF7C3AED),
    'Resilience': const Color(0xFF2563EB),
    'Analytical Thinking': const Color(0xFF059669),
    'Introverted (reflective, thoughtful)': const Color(0xFF16A34A),
    'Extroverted (outgoing, social)': const Color(0xFFDB2777),
  };

  @override
  void initState() {
    super.initState();
    // Load previously selected strengths
    if (widget.signUpData.mentorStrengths != null &&
        widget.signUpData.mentorStrengths!.isNotEmpty) {
      _selectedStrengths.addAll(
        widget.signUpData.mentorStrengths!
            .split(',')
            .map((e) => e.trim()),
      );
    }
    _areasOfInterestController.text =
        widget.signUpData.mentorAreasOfInterest ?? '';
  }

  @override
  void dispose() {
    _areasOfInterestController.dispose();
    super.dispose();
  }

  void _toggleStrength(String strength) {
    setState(() {
      if (_selectedStrengths.contains(strength)) {
        _selectedStrengths.remove(strength);
      } else {
        _selectedStrengths.add(strength);
      }
      // Update the data model
      widget.signUpData.mentorStrengths = _selectedStrengths.join(', ');
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

        // Strengths Section
        const Text(
          'Strengths',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all that apply to you',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // Strengths Grid
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _strengths.entries.map((entry) {
            final isSelected = _selectedStrengths.contains(entry.key);
            return _buildStrengthChip(
              label: entry.key,
              color: entry.value,
              isSelected: isSelected,
              onTap: () => _toggleStrength(entry.key),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

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

  Widget _buildStrengthChip({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}


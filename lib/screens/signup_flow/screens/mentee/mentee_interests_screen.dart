import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MenteeInterestsScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MenteeInterestsScreen({super.key, required this.signUpData});

  @override
  State<MenteeInterestsScreen> createState() => _MenteeInterestsScreenState();
}

class _MenteeInterestsScreenState extends State<MenteeInterestsScreen> {
  final List<String> _selectedStrengths = [];

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
    if (widget.signUpData.menteeStrengths != null &&
        widget.signUpData.menteeStrengths!.isNotEmpty) {
      _selectedStrengths.addAll(
        widget.signUpData.menteeStrengths!.split(',').map((e) => e.trim()),
      );
    }
  }

  void _toggleStrength(String strength) {
    setState(() {
      if (_selectedStrengths.contains(strength)) {
        _selectedStrengths.remove(strength);
      } else {
        _selectedStrengths.add(strength);
      }
      // Update the data model
      widget.signUpData.menteeStrengths = _selectedStrengths.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Strengths',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all that apply to you',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

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

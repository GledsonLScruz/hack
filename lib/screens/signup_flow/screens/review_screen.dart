import 'package:flutter/material.dart';
import '../../../models/signup_data_new.dart';

class ReviewScreen extends StatelessWidget {
  final SignUpDataNew signUpData;
  final Function(int) onEdit;
  final VoidCallback onSubmit;

  const ReviewScreen({
    super.key,
    required this.signUpData,
    required this.onEdit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Review Your Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please review your information before submitting',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Part 1: General Information
        _buildSectionHeader(context, 'General Information', () => onEdit(0)),
        _buildInfoRow('Email', signUpData.email ?? ''),
        _buildInfoRow('Name', signUpData.name ?? ''),
        _buildInfoRow('Password', '••••••••'),
        _buildInfoRow(
          'Role',
          signUpData.isMentor == true ? 'Mentor' : 'Mentee',
        ),
        const SizedBox(height: 24),

        // Part 2: Role-specific information
        if (signUpData.isMentor == true) ...[
          // Mentor sections
          _buildSectionHeader(context, 'Background', () => onEdit(1)),
          _buildInfoRow('Age', signUpData.mentorAge?.toString() ?? ''),
          _buildInfoRow('Hometown City', signUpData.mentorHometownCity ?? ''),
          _buildInfoRow('Hometown State', signUpData.mentorHometownState ?? ''),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Identity', () => onEdit(2)),
          _buildInfoRow('Gender', signUpData.mentorGender ?? ''),
          _buildInfoRow('Color/Race', signUpData.mentorColorRace ?? ''),
          _buildInfoRow(
            'Person with Disability',
            signUpData.mentorIsDisabled == null
                ? 'Prefer not to say'
                : (signUpData.mentorIsDisabled! ? 'Yes' : 'No'),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Education', () => onEdit(3)),
          _buildInfoRow(
            'Family Income During School',
            signUpData.mentorFamilyIncome ?? '',
          ),
          _buildInfoRow(
            'Education Level',
            signUpData.mentorEducationLevel ?? '',
          ),
          _buildInfoRow(
            'High School Name',
            signUpData.mentorHighSchoolName ?? '',
          ),
          _buildInfoRow(
            'High School Location',
            signUpData.mentorHighSchoolLocation ?? '',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Strengths & Focus', () => onEdit(4)),
          _buildInfoRow('Strengths', signUpData.mentorStrengths ?? ''),
          _buildInfoRow(
            'Areas of Interest',
            signUpData.mentorAreasOfInterest ?? '',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Activities', () => onEdit(5)),
          _buildInfoRow(
            'Extracurricular Activities',
            signUpData.mentorExtracurricularActivities ?? '',
          ),
        ] else ...[
          // Mentee sections
          _buildSectionHeader(context, 'Location', () => onEdit(1)),
          _buildInfoRow('City', signUpData.menteeCity ?? ''),
          _buildInfoRow('State', signUpData.menteeState ?? ''),
          _buildInfoRow(
            'Neighborhood',
            signUpData.menteeNeighborhood ?? 'Not provided',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Identity', () => onEdit(2)),
          _buildInfoRow('Gender', signUpData.menteeGender ?? ''),
          _buildInfoRow('Color/Race', signUpData.menteeColorRace ?? ''),
          _buildInfoRow(
            'Person with Disability',
            signUpData.menteeIsDisabled == null
                ? 'Prefer not to say'
                : (signUpData.menteeIsDisabled! ? 'Yes' : 'No'),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'School', () => onEdit(3)),
          _buildInfoRow('School Name', signUpData.menteeSchoolName ?? ''),
          _buildInfoRow(
            'School Location',
            signUpData.menteeSchoolLocation ?? '',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Interests & Strengths', () => onEdit(4)),
          _buildInfoRow('Strengths', signUpData.menteeStrengths ?? ''),
          _buildInfoRow(
            'Areas of Interest',
            signUpData.menteeAreasOfInterest ?? '',
          ),
        ],

        const SizedBox(height: 32),

        // Submit Button
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onEdit,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


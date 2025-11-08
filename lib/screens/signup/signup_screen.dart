import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import '../../widgets/step_indicator.dart';
import 'part1_essential_info.dart';
import 'part2_additional_info.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentStep = 0;
  final SignUpData _signUpData = SignUpData();
  final GlobalKey<FormState> _part1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _part2FormKey = GlobalKey<FormState>();

  final List<String> _stepLabels = [
    'Essential Information',
    'Additional Information',
  ];

  void _handleDataChanged(SignUpData data) {
    setState(() {
      // Data is already updated in the SignUpData object
    });
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate Part 1
      if (_part1FormKey.currentState?.validate() ?? false) {
        if (_signUpData.isPart1Valid()) {
          setState(() {
            _currentStep = 1;
          });
        } else {
          _showValidationError('Please fill all required fields in Part 1');
        }
      }
    } else if (_currentStep == 1) {
      // Validate Part 2
      if (_part2FormKey.currentState?.validate() ?? false) {
        // Additional validation for chips
        if (_signUpData.academicInterests.isEmpty) {
          _showValidationError('Please select at least one academic interest');
          return;
        }
        if (_signUpData.goals.isEmpty) {
          _showValidationError('Please select at least one goal');
          return;
        }
        if (_signUpData.isPart2Valid()) {
          _submitSignUp();
        } else {
          _showValidationError('Please fill all required fields in Part 2');
        }
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submitSignUp() {
    // Here you would typically send the data to your backend
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up Complete!'),
        content: const Text('Your information has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Step Indicator
          StepIndicator(
            currentStep: _currentStep,
            totalSteps: _stepLabels.length,
            stepLabels: _stepLabels,
          ),
          const Divider(height: 1),

          // Content Area
          Expanded(
            child: Center(
              child: _currentStep == 0
                  ? Part1EssentialInfo(
                      formKey: _part1FormKey,
                      signUpData: _signUpData,
                      onDataChanged: _handleDataChanged,
                    )
                  : Part2AdditionalInfo(
                      formKey: _part2FormKey,
                      signUpData: _signUpData,
                      onDataChanged: _handleDataChanged,
                    ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: _previousStep,
                    child: const Text('Previous'),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(_currentStep == _stepLabels.length - 1 ? 'Submit' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


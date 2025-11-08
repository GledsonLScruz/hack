import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/signup_data_new.dart';
import 'screens/role_selection_screen.dart';
import 'screens/welcome_role_screen.dart';
import 'screens/mentee/mentee_location_screen.dart';
import 'screens/mentee/mentee_identity_screen.dart';
import 'screens/mentee/mentee_school_screen.dart';
import 'screens/mentee/mentee_interests_screen.dart';
import 'screens/mentor/mentor_background_screen.dart';
import 'screens/mentor/mentor_identity_screen.dart';
import 'screens/mentor/mentor_education_screen.dart';
import 'screens/mentor/mentor_strengths_screen.dart';
import 'screens/mentor/mentor_activities_screen.dart';
import 'screens/review_screen.dart';

class SignUpFlowScreen extends StatefulWidget {
  const SignUpFlowScreen({super.key});

  @override
  State<SignUpFlowScreen> createState() => _SignUpFlowScreenState();
}

class _SignUpFlowScreenState extends State<SignUpFlowScreen> {
  int _currentStep = 0;
  final SignUpDataNew _signUpData = SignUpDataNew();
  bool _roleSelected = false;
  String? _validationError;

  int get _totalSteps {
    if (_signUpData.isMentor == true) {
      return 7; // Welcome + 5 mentor screens + Review
    } else {
      return 6; // Welcome + 4 mentee screens + Review
    }
  }

  void _handleRoleSelection(bool isMentor) {
    setState(() {
      _signUpData.isMentor = isMentor;
      _roleSelected = true;
    });
  }

  String get _currentStepLabel {
    if (_currentStep == 0) {
      return 'Account Info';
    }
    
    if (_signUpData.isMentor == true) {
      switch (_currentStep) {
        case 1:
          return 'Background';
        case 2:
          return 'Identity';
        case 3:
          return 'Education';
        case 4:
          return 'Strengths & Focus';
        case 5:
          return 'Activities';
        case 6:
          return 'Review';
        default:
          return '';
      }
    } else {
      switch (_currentStep) {
        case 1:
          return 'Location';
        case 2:
          return 'Identity';
        case 3:
          return 'School';
        case 4:
          return 'Interests & Strengths';
        case 5:
          return 'Review';
        default:
          return '';
      }
    }
  }

  void _handleNext() {
    setState(() {
      _validationError = null;
    });

    // Validate current step
    final error = _validateCurrentStep();
    if (error != null) {
      setState(() {
        _validationError = error;
      });
      return;
    }

    // Move to next step
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _validationError = null;
      });
    }
  }

  void _handleSaveAndContinueLater() {
    // In a real app, save to local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress saved! You can continue later.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _jumpToStep(int step) {
    setState(() {
      _currentStep = step;
      _validationError = null;
    });
  }


  String? _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Account Info
        if (_signUpData.email == null || _signUpData.email!.isEmpty) {
          return 'Email is required';
        }
        if (!_isValidEmail(_signUpData.email!)) {
          return 'Please enter a valid email address';
        }
        if (_signUpData.name == null || _signUpData.name!.isEmpty) {
          return 'Name is required';
        }
        if (_signUpData.password == null || _signUpData.password!.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;

      case 1:
        if (_signUpData.isMentor == true) {
          // Mentor Background
          if (_signUpData.mentorAge == null) {
            return 'Age is required';
          }
          if (_signUpData.mentorAge! < 18 || _signUpData.mentorAge! > 100) {
            return 'Age must be between 18 and 100';
          }
          if (_signUpData.mentorHometownCity == null ||
              _signUpData.mentorHometownCity!.isEmpty) {
            return 'Hometown city is required';
          }
          if (_signUpData.mentorHometownState == null ||
              _signUpData.mentorHometownState!.isEmpty) {
            return 'Hometown state is required';
          }
        } else {
          // Mentee Location
          if (_signUpData.menteeCity == null ||
              _signUpData.menteeCity!.isEmpty) {
            return 'City is required';
          }
          if (_signUpData.menteeState == null ||
              _signUpData.menteeState!.isEmpty) {
            return 'State is required';
          }
        }
        return null;

      case 2:
        // Identity (both mentor and mentee)
        if (_signUpData.isMentor == true) {
          if (_signUpData.mentorGender == null ||
              _signUpData.mentorGender!.isEmpty) {
            return 'Gender is required';
          }
          if (_signUpData.mentorColorRace == null ||
              _signUpData.mentorColorRace!.isEmpty) {
            return 'Color/Race is required';
          }
          if (_signUpData.mentorIsDisabled == null) {
            return 'Please indicate disability status';
          }
        } else {
          if (_signUpData.menteeGender == null ||
              _signUpData.menteeGender!.isEmpty) {
            return 'Gender is required';
          }
          if (_signUpData.menteeColorRace == null ||
              _signUpData.menteeColorRace!.isEmpty) {
            return 'Color/Race is required';
          }
          if (_signUpData.menteeIsDisabled == null) {
            return 'Please indicate disability status';
          }
        }
        return null;

      case 3:
        if (_signUpData.isMentor == true) {
          // Mentor Education
          if (_signUpData.mentorFamilyIncome == null ||
              _signUpData.mentorFamilyIncome!.isEmpty) {
            return 'Family income information is required';
          }
          if (_signUpData.mentorEducationLevel == null ||
              _signUpData.mentorEducationLevel!.isEmpty) {
            return 'Education level is required';
          }
          if (_signUpData.mentorHighSchoolName == null ||
              _signUpData.mentorHighSchoolName!.isEmpty) {
            return 'High school name is required';
          }
          if (_signUpData.mentorHighSchoolLocation == null ||
              _signUpData.mentorHighSchoolLocation!.isEmpty) {
            return 'High school location is required';
          }
        } else {
          // Mentee School
          if (_signUpData.menteeSchoolName == null ||
              _signUpData.menteeSchoolName!.isEmpty) {
            return 'School name is required';
          }
          if (_signUpData.menteeSchoolLocation == null ||
              _signUpData.menteeSchoolLocation!.isEmpty) {
            return 'School location is required';
          }
        }
        return null;

      case 4:
        if (_signUpData.isMentor == true) {
          // Mentor Strengths & Focus
          if (_signUpData.mentorStrengths == null ||
              _signUpData.mentorStrengths!.isEmpty) {
            return 'Strengths are required';
          }
          if (_signUpData.mentorAreasOfInterest == null ||
              _signUpData.mentorAreasOfInterest!.isEmpty) {
            return 'Areas of interest are required';
          }
        } else {
          // Mentee Interests & Strengths
          if (_signUpData.menteeAcademicInterests == null ||
              _signUpData.menteeAcademicInterests!.isEmpty) {
            return 'Academic interests are required';
          }
          if (_signUpData.menteeStrengths == null ||
              _signUpData.menteeStrengths!.isEmpty) {
            return 'Strengths are required';
          }
          if (_signUpData.menteeAreasOfInterest == null ||
              _signUpData.menteeAreasOfInterest!.isEmpty) {
            return 'Areas of interest are required';
          }
        }
        return null;

      case 5:
        if (_signUpData.isMentor == true) {
          // Mentor Activities
          if (_signUpData.mentorExtracurricularActivities == null ||
              _signUpData.mentorExtracurricularActivities!.isEmpty) {
            return 'Extracurricular activities are required';
          }
        }
        // Mentee case 5 is Review, no validation needed
        return null;

      default:
        return null;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleFinalSubmit() {
    // Output final JSON
    final jsonOutput = jsonEncode(_signUpData.toJson());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up Complete'),
        content: SingleChildScrollView(
          child: SelectableText(
            jsonOutput,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentStep) {
      case 0:
        return WelcomeRoleScreen(signUpData: _signUpData);
      case 1:
        if (_signUpData.isMentor == true) {
          return MentorBackgroundScreen(signUpData: _signUpData);
        } else {
          return MenteeLocationScreen(signUpData: _signUpData);
        }
      case 2:
        if (_signUpData.isMentor == true) {
          return MentorIdentityScreen(signUpData: _signUpData);
        } else {
          return MenteeIdentityScreen(signUpData: _signUpData);
        }
      case 3:
        if (_signUpData.isMentor == true) {
          return MentorEducationScreen(signUpData: _signUpData);
        } else {
          return MenteeSchoolScreen(signUpData: _signUpData);
        }
      case 4:
        if (_signUpData.isMentor == true) {
          return MentorStrengthsScreen(signUpData: _signUpData);
        } else {
          return MenteeInterestsScreen(signUpData: _signUpData);
        }
      case 5:
        if (_signUpData.isMentor == true) {
          return MentorActivitiesScreen(signUpData: _signUpData);
        } else {
          return ReviewScreen(
            signUpData: _signUpData,
            onEdit: _jumpToStep,
            onSubmit: _handleFinalSubmit,
          );
        }
      case 6:
        return ReviewScreen(
          signUpData: _signUpData,
          onEdit: _jumpToStep,
          onSubmit: _handleFinalSubmit,
        );
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show role selection screen first
    if (!_roleSelected) {
      return RoleSelectionScreen(onRoleSelected: _handleRoleSelection);
    }

    final isReviewStep =
        (_signUpData.isMentor == true && _currentStep == 6) ||
        (_signUpData.isMentor == false && _currentStep == 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Fixed Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / _totalSteps,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      _currentStepLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildCurrentScreen(),
            ),
          ),

          // Validation Error
          if (_validationError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Colors.red[50],
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _validationError!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Save & Continue Later
                if (!isReviewStep)
                  TextButton(
                    onPressed: _handleSaveAndContinueLater,
                    child: const Text('Save & continue later'),
                  ),
                const SizedBox(height: 8),
                // Back and Next buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        onPressed: _handleBack,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox.shrink(),
                    if (!isReviewStep)
                      ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Next'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../models/signup_data_new.dart';

// TODO: Uncomment these imports when ready to connect to API
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class SubmissionScreen extends StatefulWidget {
  final SignUpDataNew signUpData;
  final VoidCallback onSuccess;

  const SubmissionScreen({
    super.key,
    required this.signUpData,
    required this.onSuccess,
  });

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen>
    with SingleTickerProviderStateMixin {
  bool _isCreatingUser = true;
  bool _userCreated = false;
  bool _hasError = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _submitData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    setState(() {
      _isCreatingUser = true;
      _hasError = false;
    });

    // Simulate loading for better UX
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Uncomment this section when ready to connect to API
    /*
    try {
      // Prepare the JSON data
      final jsonData = widget.signUpData.toJson();

      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/api/users/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        setState(() {
          _isCreatingUser = false;
          _userCreated = true;
        });

        // Wait a bit to show success message
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to home
        if (mounted) {
          widget.onSuccess();
        }
      } else {
        // Error from server
        setState(() {
          _isCreatingUser = false;
          _hasError = true;
          _errorMessage = 'Failed to create account. Please try again.';
        });
      }
    } catch (e) {
      // Network or other error
      setState(() {
        _isCreatingUser = false;
        _hasError = true;
        _errorMessage = 'Connection error. Please check your internet.';
      });
    }
    */

    // FOR TESTING: Always succeed
    setState(() {
      _isCreatingUser = false;
      _userCreated = true;
    });

    // Wait a bit to show success message
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to home
    if (mounted) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isCreatingUser) ...[
                    // Loading state
                    const SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Creating your account...',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please wait while we set up your profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else if (_userCreated) ...[
                    // Success state
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Account created successfully!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome! Redirecting to home...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else if (_hasError) ...[
                    // Error state
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


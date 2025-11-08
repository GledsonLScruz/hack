import 'package:flutter/material.dart';
import '../../../models/signup_data_new.dart';

class WelcomeRoleScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const WelcomeRoleScreen({
    super.key,
    required this.signUpData,
  });

  @override
  State<WelcomeRoleScreen> createState() => _WelcomeRoleScreenState();
}

class _WelcomeRoleScreenState extends State<WelcomeRoleScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _nameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.signUpData.email ?? '';
    _nameController.text = widget.signUpData.name ?? '';
    _passwordController.text = widget.signUpData.password ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(_emailController.text)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameError = 'Name is required';
      } else {
        _nameError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
      } else if (_passwordController.text.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create Your Account',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome, ${widget.signUpData.isMentor == true ? 'Mentor' : 'Mentee'}!',
          style: TextStyle(
            fontSize: 16,
            color: widget.signUpData.isMentor == true
                ? Colors.purple
                : Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 32),

        // Email Field
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'name@example.com',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.email_outlined),
            errorText: _emailError,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            widget.signUpData.email = value;
            if (_emailError != null) {
              _validateEmail();
            }
          },
          onTap: () {
            setState(() {
              _emailError = null;
            });
          },
          onEditingComplete: _validateEmail,
        ),
        const SizedBox(height: 16),

        // Name Field
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Your full name',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person_outline),
            errorText: _nameError,
          ),
          onChanged: (value) {
            widget.signUpData.name = value;
            if (_nameError != null) {
              _validateName();
            }
          },
          onTap: () {
            setState(() {
              _nameError = null;
            });
          },
          onEditingComplete: _validateName,
        ),
        const SizedBox(height: 16),

        // Password Field
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'At least 8 characters',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            errorText: _passwordError,
          ),
          obscureText: _obscurePassword,
          onChanged: (value) {
            widget.signUpData.password = value;
            if (_passwordError != null) {
              _validatePassword();
            }
          },
          onTap: () {
            setState(() {
              _passwordError = null;
            });
          },
          onEditingComplete: _validatePassword,
        ),
      ],
    );
  }
}

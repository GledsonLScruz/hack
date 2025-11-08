import 'package:flutter/material.dart';
import '../../../models/signup_data_new.dart';

class WelcomeRoleScreen extends StatefulWidget {
  final SignUpDataNew signUpData;
  final Function(bool?) onRoleChange;

  const WelcomeRoleScreen({
    super.key,
    required this.signUpData,
    required this.onRoleChange,
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
          'Welcome!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose your role and create your account',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Role Selection Cards
        const Text(
          'I am a...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                title: 'Mentee',
                description: 'I want to be mentored',
                icon: Icons.school,
                isSelected: widget.signUpData.isMentor == false,
                onTap: () => widget.onRoleChange(false),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildRoleCard(
                title: 'Mentor',
                description: 'I want to mentor others',
                icon: Icons.person,
                isSelected: widget.signUpData.isMentor == true,
                onTap: () => widget.onRoleChange(true),
              ),
            ),
          ],
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

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

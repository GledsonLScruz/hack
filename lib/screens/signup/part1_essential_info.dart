import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/signup_data.dart';

class Part1EssentialInfo extends StatefulWidget {
  final SignUpData signUpData;
  final Function(SignUpData) onDataChanged;
  final GlobalKey<FormState>? formKey;

  const Part1EssentialInfo({
    super.key,
    required this.signUpData,
    required this.onDataChanged,
    this.formKey,
  });

  @override
  State<Part1EssentialInfo> createState() => _Part1EssentialInfoState();
}

class _Part1EssentialInfoState extends State<Part1EssentialInfo> {
  final _nameController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.signUpData.name ?? '';
    _postalCodeController.text = widget.signUpData.postalCode ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.onDataChanged(widget.signUpData);
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final minAgeDate = DateTime(now.year - 13, now.month, now.day);
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: minAgeDate,
      helpText: 'Select Birth Date',
      errorInvalidText: 'You must be at least 13 years old',
    );

    if (picked != null) {
      setState(() {
        widget.signUpData.birthDate = picked;
        _updateData();
      });
    }
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
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'Enter your full name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
              onChanged: (value) {
                widget.signUpData.name = value;
                _updateData();
              },
            ),
            const SizedBox(height: 24),

            // Birth Date Field
            InkWell(
              onTap: _selectBirthDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Birth Date *',
                  hintText: 'Select your birth date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  widget.signUpData.birthDate != null
                      ? DateFormat('yyyy-MM-dd').format(widget.signUpData.birthDate!)
                      : 'Select your birth date',
                  style: TextStyle(
                    color: widget.signUpData.birthDate != null
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Postal Code Field
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code *',
                hintText: 'Enter your postal code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Postal code cannot be empty';
                }
                return null;
              },
              onChanged: (value) {
                widget.signUpData.postalCode = value;
                _updateData();
              },
            ),
            const SizedBox(height: 24),

            // Gender Field
            DropdownButtonFormField<String>(
              value: widget.signUpData.gender,
              decoration: const InputDecoration(
                labelText: 'Gender *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: const [
                DropdownMenuItem(value: 'MALE', child: Text('Male')),
                DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.signUpData.gender = value;
                  _updateData();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a gender';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Color/Race Field
            TextFormField(
              initialValue: widget.signUpData.colorRace,
              decoration: const InputDecoration(
                labelText: 'Color/Race *',
                hintText: 'Enter your color/race',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Color/Race cannot be empty';
                }
                return null;
              },
              onChanged: (value) {
                widget.signUpData.colorRace = value;
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
    return formKeyToUse.currentState?.validate() ?? false;
  }
}


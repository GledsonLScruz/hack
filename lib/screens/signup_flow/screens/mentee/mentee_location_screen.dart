import 'package:flutter/material.dart';
import '../../../../models/signup_data_new.dart';

class MenteeLocationScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MenteeLocationScreen({super.key, required this.signUpData});

  @override
  State<MenteeLocationScreen> createState() => _MenteeLocationScreenState();
}

class _MenteeLocationScreenState extends State<MenteeLocationScreen> {
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  String? _cityError;
  String? _stateError;

  @override
  void initState() {
    super.initState();
    _cityController.text = widget.signUpData.menteeCity ?? '';
    _stateController.text = widget.signUpData.menteeState ?? '';
    _neighborhoodController.text = widget.signUpData.menteeNeighborhood ?? '';
  }

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  void _validateCity() {
    setState(() {
      if (_cityController.text.isEmpty) {
        _cityError = 'City is required';
      } else {
        _cityError = null;
      }
    });
  }

  void _validateState() {
    setState(() {
      if (_stateController.text.isEmpty) {
        _stateError = 'State is required';
      } else {
        _stateError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Where are you located?',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // City
        TextField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'City',
            hintText: 'Fortaleza',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_city),
            errorText: _cityError,
          ),
          onChanged: (value) {
            widget.signUpData.menteeCity = value;
            if (_cityError != null) {
              _validateCity();
            }
          },
          onTap: () {
            setState(() {
              _cityError = null;
            });
          },
          onEditingComplete: _validateCity,
        ),
        const SizedBox(height: 16),

        // State
        TextField(
          controller: _stateController,
          decoration: InputDecoration(
            labelText: 'State',
            hintText: 'CE',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.map),
            errorText: _stateError,
          ),
          onChanged: (value) {
            widget.signUpData.menteeState = value;
            if (_stateError != null) {
              _validateState();
            }
          },
          onTap: () {
            setState(() {
              _stateError = null;
            });
          },
          onEditingComplete: _validateState,
        ),
        const SizedBox(height: 16),

        // Neighborhood (optional)
        TextField(
          controller: _neighborhoodController,
          decoration: const InputDecoration(
            labelText: 'Neighborhood (optional)',
            hintText: 'Aldeota',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.place),
          ),
          onChanged: (value) {
            widget.signUpData.menteeNeighborhood = value;
          },
        ),
      ],
    );
  }
}

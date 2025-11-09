import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../models/signup_data_new.dart';

class MenteeLocationScreen extends StatefulWidget {
  final SignUpDataNew signUpData;

  const MenteeLocationScreen({super.key, required this.signUpData});

  @override
  State<MenteeLocationScreen> createState() => _MenteeLocationScreenState();
}

class _MenteeLocationScreenState extends State<MenteeLocationScreen> {
  final _cepController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  String? _cepError;
  String? _cityError;
  String? _stateError;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _cityController.text = widget.signUpData.menteeCity ?? '';
    _stateController.text = widget.signUpData.menteeState ?? '';
    _neighborhoodController.text = widget.signUpData.menteeNeighborhood ?? '';
  }

  @override
  void dispose() {
    _cepController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  Future<void> _fetchAddressFromCep(String cep) async {
    // Remove mask characters
    final cleanCep = cep.replaceAll('-', '');
    
    if (cleanCep.length != 8) {
      return;
    }

    setState(() {
      _isLoadingAddress = true;
      _cepError = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cleanCep/json/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['erro'] == true) {
          setState(() {
            _cepError = 'CEP not found';
            _isLoadingAddress = false;
          });
          return;
        }

        setState(() {
          // Fill the fields with the API response
          _cityController.text = data['localidade'] ?? '';
          widget.signUpData.menteeCity = data['localidade'] ?? '';
          
          _stateController.text = data['uf'] ?? '';
          widget.signUpData.menteeState = data['uf'] ?? '';
          
          _neighborhoodController.text = data['bairro'] ?? '';
          widget.signUpData.menteeNeighborhood = data['bairro'] ?? '';
          
          _isLoadingAddress = false;
          _cityError = null;
          _stateError = null;
        });
      } else {
        setState(() {
          _cepError = 'Error fetching address';
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      setState(() {
        _cepError = 'Error connecting to service';
        _isLoadingAddress = false;
      });
    }
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

        // CEP Field
        TextField(
          controller: _cepController,
          inputFormatters: [_cepMask],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'CEP',
            hintText: '00000-000',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.pin_drop),
            suffixIcon: _isLoadingAddress
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            errorText: _cepError,
            helperText: 'Enter your postal code',
          ),
          onChanged: (value) {
            if (_cepError != null) {
              setState(() {
                _cepError = null;
              });
            }
            
            // Auto-fetch when CEP is complete
            if (value.length == 9) {
              _fetchAddressFromCep(value);
            }
          },
        ),
        const SizedBox(height: 16),

        // City
        TextField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'City',
            hintText: 'Fortaleza',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_city),
            errorText: _cityError,
            enabled: !_isLoadingAddress,
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
            enabled: !_isLoadingAddress,
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
          decoration: InputDecoration(
            labelText: 'Neighborhood (optional)',
            hintText: 'Aldeota',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.place),
            enabled: !_isLoadingAddress,
          ),
          onChanged: (value) {
            widget.signUpData.menteeNeighborhood = value;
          },
        ),
      ],
    );
  }
}

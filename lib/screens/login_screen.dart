import 'package:flutter/material.dart';
import 'signup_flow/signup_flow_screen.dart';
import 'home_screen.dart';
import 'mentor_home_screen.dart';
import '../config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_logged_data.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email é obrigatório';
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(_emailController.text)) {
        _emailError = 'Por favor, insira um email válido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Senha é obrigatória';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> _handleLogin() async {
    // Clear previous errors
    setState(() {
      _generalError = null;
    });

    // Validate fields
    _validateEmail();
    _validatePassword();

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare login request body as form data (application/x-www-form-urlencoded)
      final requestBody = <String, String>{
        'grant_type': ApiConfig.grantTypePassword,
        'username': _emailController.text,
        'password': _passwordController.text,
        'scope': '',
      };

      // Override Content-Type to send form-encoded data. Keep other default headers.
      final headers = {
        ...ApiConfig.defaultHeaders,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      // When passing a Map<String, String> as body, the http package will
      // encode it as application/x-www-form-urlencoded. We set the header
      // explicitly to ensure the server interprets it as form data.
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Success - parse response and save user data
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final userData = UserLoggedData.fromJson(data);

        // Save user data to shared preferences
        final saved = await AuthService.saveUserData(userData);

        if (!saved) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _generalError = 'Erro ao salvar dados do usuário';
            });
          }
          return;
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Route to different home screens based on isMentor flag
          final isMentor = userData.user.isMentor;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => isMentor
                  ? const MentorHomeScreen()
                  : const HomeScreen(),
            ),
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        // Invalid credentials
        String errorMsg = 'Email ou senha inválidos';

        // Try to parse error message from response
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['detail'] != null) {
            errorMsg = errorData['detail'];
          } else if (errorData['message'] != null) {
            errorMsg = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMsg = errorData['error'];
          }
        } catch (e) {
          // Use default error message
        }

        setState(() {
          _isLoading = false;
          _generalError = errorMsg;
        });
      } else {
        // Other error
        setState(() {
          _isLoading = false;
          _generalError = 'Falha no login. Tente novamente.';
        });
      }
    } catch (e) {
      // Network or other error
      setState(() {
        _isLoading = false;
        _generalError = 'Erro de conexão. Verifique sua internet.';
      });
    }
  }

  void _navigateToSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignUpFlowScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Icon with modern design
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC8206).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 64,
                    color: Color(0xFFEC8206),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Bem-vindo de volta!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Entre para continuar sua jornada',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 48),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'seu@email.com',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText: _emailError,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  onChanged: (value) {
                    if (_emailError != null) {
                      _validateEmail();
                    }
                  },
                  onTap: () {
                    setState(() {
                      _emailError = null;
                      _generalError = null;
                    });
                  },
                  onEditingComplete: _validateEmail,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
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
                  enabled: !_isLoading,
                  onChanged: (value) {
                    if (_passwordError != null) {
                      _validatePassword();
                    }
                  },
                  onTap: () {
                    setState(() {
                      _passwordError = null;
                      _generalError = null;
                    });
                  },
                  onEditingComplete: _validatePassword,
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 8),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            // TODO: Implement forgot password
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Funcionalidade em breve'),
                              ),
                            );
                          },
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 8),

                // General Error Message
                if (_generalError != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEF4444)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFEF4444),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _generalError!,
                            style: const TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OU',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  ],
                ),
                const SizedBox(height: 24),

                // Create Account Button
                OutlinedButton(
                  onPressed: _isLoading ? null : _navigateToSignUp,
                  child: const Text('Criar Conta'),
                ),
                const SizedBox(height: 24),

                // Terms and Privacy
                Text(
                  'Ao continuar, você concorda com nossos Termos de Serviço e Política de Privacidade',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

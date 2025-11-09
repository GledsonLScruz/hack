import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_config.dart';
import '../../models/mentor_model.dart';
import '../../services/auth_service.dart';

class MentorsTab extends StatefulWidget {
  const MentorsTab({super.key});

  @override
  State<MentorsTab> createState() => _MentorsTabState();
}

class _MentorsTabState extends State<MentorsTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Mentor> _mentors = [];
  int _threshold = 1;
  int _limit = 50;
  static const String _cacheKey = 'mentors_cache';
  static const String _cacheTimestampKey = 'mentors_cache_timestamp';
  static const Duration _cacheDuration = Duration(days: 1);

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        var cachedData = await _loadFromCache();
        if (cachedData != null) {
          setState(() {
            _mentors = cachedData;
            _isLoading = false;
          });
          return;
        }
      }

      // Get user data from shared preferences
      final userData = await AuthService.getUserData();

      if (userData == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Usuário não autenticado';
            _isLoading = false;
          });
        }
        return;
      }

      // Get authorization header
      final authHeader = await AuthService.getAuthorizationHeader();
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (authHeader != null) 'Authorization': authHeader,
      };

      // Build URL with query parameters
      final uri = Uri.parse(ApiConfig.mentorsUrl).replace(
        queryParameters: {
          'user_id': userData.user.id.toString(),
          'threshold': _threshold.toString(),
          'limit': _limit.toString(),
        },
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final mentorsResponse = MentorsResponse.fromJson(data);

        // Save to cache
        await _saveToCache(mentorsResponse.matches);

        if (mounted) {
          setState(() {
            _mentors = mentorsResponse.matches;
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Sessão expirada. Faça login novamente.';
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Erro ao carregar mentores. Tente novamente.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro de conexão. Verifique sua internet.';
          _isLoading = false;
        });
      }
    }
  }

  /// Load mentors data from cache if available and not expired
  Future<List<Mentor>?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      final cachedTimestamp = prefs.getInt(_cacheTimestampKey);

      if (cachedJson == null || cachedTimestamp == null) {
        return null;
      }

      // Check if cache is expired
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      if (difference > _cacheDuration) {
        // Cache expired, clear it
        await _clearCache();
        return null;
      }

      // Parse cached data
      final data = jsonDecode(cachedJson) as List<dynamic>;
      List<Mentor> mentors = data
          .map((e) => Mentor.fromJson(e as Map<String, dynamic>))
          .toList();
      return mentors;
    } catch (e) {
      // If cache is corrupted, clear it
      print('Error loading from cache: $e');
      await _clearCache();
      return null;
    }
  }

  /// Save mentors data to cache
  Future<void> _saveToCache(List<Mentor> mentors) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(mentors.map((e) => e.toJson()).toList());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(_cacheTimestampKey, timestamp);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  /// Clear mentors cache
  Future<void> _clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC8206)),
        ),
      );
    }

    if (_errorMessage != null) {
      return RefreshIndicator(
        onRefresh: () => _loadMentors(forceRefresh: true),
        color: const Color(0xFFEC8206),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _loadMentors(forceRefresh: true),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC8206),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadMentors(forceRefresh: true),
      color: const Color(0xFFEC8206),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encontre seu Mentor',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Conecte-se com mentores que combinam com seu perfil',
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          // Mentors List
          Expanded(
            child: _mentors.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhum mentor encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tente ajustar seus filtros ou volte mais tarde',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _mentors.length,
                    itemBuilder: (context, index) {
                      final mentor = _mentors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildMentorCard(context, mentor),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(BuildContext context, Mentor mentor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to mentor profile details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ver perfil de ${mentor.mentorName}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Photo, Name, and Match
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo/Initial
                  _buildProfilePhoto(mentor.mentorName, null),
                  const SizedBox(width: 16),

                  // Name and Match
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentor.mentorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Mentor Verificado',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Cargo and Location
              Row(
                children: [
                  Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      mentor.mentorCargo,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    mentor.location,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                mentor.mentorSobre,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Match Reasons
              if (mentor.matchReasons.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: mentor.matchReasons.take(2).map((reason) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC8206).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        reason,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFEC8206),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Action Buttons
              Row(
                children: [
                  /** 
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: View full profile
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ver perfil completo de ${mentor.mentorName}',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person, size: 18),
                      label: const Text('Ver Perfil'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  */
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showConnectDialog(context, mentor),
                      icon: const Icon(Icons.connect_without_contact, size: 18),
                      label: const Text('Conectar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(String name, String? photoUrl) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'M';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: photoUrl != null && photoUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitialCircle(initial);
                },
              ),
            )
          : _buildInitialCircle(initial),
    );
  }

  Widget _buildInitialCircle(String initial) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEC8206), Color(0xFFF59E42)],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Show dialog to connect with mentor
  void _showConnectDialog(BuildContext context, Mentor mentor) {
    final messageController = TextEditingController(
      text:
          'Olá ${mentor.mentorName.split(' ').first}, gostaria de me conectar com você e aprender com sua experiência! Acredito que sua trajetória pode me ajudar muito no meu desenvolvimento profissional.',
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEC8206).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.connect_without_contact,
                  color: Color(0xFFEC8206),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Conectar com Mentor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enviar mensagem para ${mentor.mentorName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFEC8206),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Capture message value immediately to avoid disposal issues
                final message = messageController.text.trim();

                if (message.isEmpty) {
                  // Show snackbar without closing dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, escreva uma mensagem'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Close dialog
                Navigator.of(dialogContext).pop();

                // Send request with captured message value
                _sendMentorshipRequest(context, mentor.mentorId, message);
              },
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Enviar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC8206),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      messageController.dispose();
    });
  }

  /// Send mentorship request to API
  Future<void> _sendMentorshipRequest(
    BuildContext context,
    int mentorId,
    String message,
  ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC8206)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enviando solicitação...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Get authorization header
      final authHeader = await AuthService.getAuthorizationHeader();
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (authHeader != null) 'Authorization': authHeader,
      };

      // Prepare request body
      final requestBody = {'mentor_id': mentorId, 'message': message};

      final response = await http.post(
        Uri.parse(ApiConfig.mentorshipRequestUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        if (context.mounted) {
          _showResultDialog(
            context,
            success: true,
            title: 'Solicitação Enviada!',
            message:
                'Sua solicitação de mentoria foi enviada com sucesso. O mentor receberá sua mensagem em breve.',
          );
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        if (context.mounted) {
          _showResultDialog(
            context,
            success: false,
            title: 'Sessão Expirada',
            message: 'Sua sessão expirou. Por favor, faça login novamente.',
          );
        }
      } else {
        // Other error
        if (context.mounted) {
          _showResultDialog(
            context,
            success: false,
            title: 'Erro ao Enviar',
            message:
                'Não foi possível enviar sua solicitação. Tente novamente mais tarde.',
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Network error
      if (context.mounted) {
        _showResultDialog(
          context,
          success: false,
          title: 'Erro de Conexão',
          message: 'Verifique sua conexão com a internet e tente novamente.',
        );
      }
    }
  }

  /// Show result dialog (success or error)
  void _showResultDialog(
    BuildContext context, {
    required bool success,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: success
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? Icons.check_circle : Icons.error,
                  size: 64,
                  color: success ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: success
                      ? Colors.green
                      : const Color(0xFFEC8206),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  int _threshold = 30;
  int _limit = 50;

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadMentors,
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
      );
    }

    return Column(
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
    );
  }

  Widget _buildMentorCard(BuildContext context, Mentor mentor) {
    final matchPercent = mentor.matchPercentage;
    Color matchColor;
    if (matchPercent >= 80) {
      matchColor = Colors.green;
    } else if (matchPercent >= 60) {
      matchColor = Colors.orange;
    } else {
      matchColor = Colors.grey;
    }

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

                  // Match Percentage Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: matchColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: matchColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: matchColor),
                        const SizedBox(width: 4),
                        Text(
                          '$matchPercent%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: matchColor,
                          ),
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
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Connect with mentor
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Conectar com ${mentor.mentorName}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
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
}

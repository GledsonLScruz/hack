import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_config.dart';
import '../../models/course_models.dart';
import '../../services/auth_service.dart';

class RoadMapTab extends StatefulWidget {
  const RoadMapTab({super.key});

  @override
  State<RoadMapTab> createState() => _RoadMapTabState();
}

class _RoadMapTabState extends State<RoadMapTab> {
  bool _isLoading = true;
  String? _errorMessage;
  RoadmapResponse? _roadmapData;
  static const String _cacheKey = 'roadmap_cache';
  static const String _cacheTimestampKey = 'roadmap_cache_timestamp';
  static const Duration _cacheDuration = Duration(days: 1);

  @override
  void initState() {
    super.initState();
    _loadRoadmap();
  }

  Future<void> _loadRoadmap({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var cachedData = await _loadFromCache();
      if (cachedData != null) {
        setState(() {
          _roadmapData = cachedData;
          _isLoading = false;
        });

        return;
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

      // Parse interests and strengths from comma-separated strings
      final interests = userData.user.areasInteresse
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();

      final strengths = userData.user.pontosFortes
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();

      // Prepare request body
      final requestBody = {
        'interests': interests,
        'location': userData.user.cidade,
        'strengths': strengths,
        'user_id': userData.user.id,
      };

      // Get authorization header
      final authHeader = await AuthService.getAuthorizationHeader();
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (authHeader != null) 'Authorization': authHeader,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.roadmapUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final roadmap = RoadmapResponse.fromJson(data);

        // Save to cache
        await _saveToCache(roadmap);

        if (mounted) {
          setState(() {
            _roadmapData = roadmap;
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
            _errorMessage = 'Erro ao carregar roadmap. Tente novamente.';
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

  /// Load roadmap data from cache if available and not expired
  Future<RoadmapResponse?> _loadFromCache() async {
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
      final data = jsonDecode(cachedJson) as Map<String, dynamic>;
      RoadmapResponse response = RoadmapResponse.fromJson(data);
      return response;
    } catch (e) {
      // If cache is corrupted, clear it
      print('Error loading from cache: $e');
      await _clearCache();
      return null;
    }
  }

  /// Save roadmap data to cache
  Future<void> _saveToCache(RoadmapResponse roadmap) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(roadmap.toJson());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(_cacheTimestampKey, timestamp);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  /// Clear roadmap cache
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
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _loadRoadmap(forceRefresh: true),
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
      );
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Text(
            'Sua perspectiva de carreira',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Guiando você do ensino médio até a universidade',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Recommended Courses Section
          _buildSectionHeader('Cursos Recomendados', Icons.school),
          const SizedBox(height: 16),
          _buildRecommendedCourses(),
          const SizedBox(height: 32),

          // Scholarship Opportunities Section
          if (_roadmapData?.roadmap.bolsasEstudo.isNotEmpty ?? false) ...[
            _buildSectionHeader('Bolsas de Estudo', Icons.school_outlined),
            const SizedBox(height: 16),
            _buildScholarships(),
            const SizedBox(height: 32),
          ],

          // Entry Opportunities Section
          if (_roadmapData?.roadmap.oportunidadesEntrada.isNotEmpty ??
              false) ...[
            _buildSectionHeader('Oportunidades de Entrada', Icons.work_outline),
            const SizedBox(height: 16),
            _buildEntryOpportunities(),
            const SizedBox(height: 32),
          ],

          // Networking Events Section
          if (_roadmapData?.roadmap.eventosNetworking.isNotEmpty ?? false) ...[
            _buildSectionHeader('Eventos de Networking', Icons.event),
            const SizedBox(height: 16),
            _buildNetworkingEvents(),
            const SizedBox(height: 32),
          ],

          // Skills to Develop Section
          if (_roadmapData?.roadmap.habilidadesDesenvolver.isNotEmpty ??
              false) ...[
            _buildSectionHeader(
              'Habilidades para Desenvolver',
              Icons.psychology,
            ),
            const SizedBox(height: 16),
            _buildSkillsToDevelop(),
            const SizedBox(height: 32),
          ],

          // Job Market Section
          if (_roadmapData?.roadmap.mercadoTrabalho != null) ...[
            _buildSectionHeader('Mercado de Trabalho', Icons.trending_up),
            const SizedBox(height: 16),
            _buildJobMarket(),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEC8206).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFFEC8206)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCourses() {
    final cursosRecomendados = _roadmapData?.roadmap.cursosRecomendados ?? [];
    final cursosOnline = _roadmapData?.roadmap.cursosOnline ?? [];
    final cursosTecnicos = _roadmapData?.roadmap.cursosTecnicos ?? [];

    return Column(
      children: [
        // Cursos Recomendados
        if (cursosRecomendados.isNotEmpty) ...[
          ...cursosRecomendados.map((curso) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildCursoRecomendadoCard(curso.toJson()),
            );
          }),
        ] else
          _buildEmptyState('Nenhum curso recomendado disponível'),

        const SizedBox(height: 16),

        // Cursos Online
        if (cursosOnline.isNotEmpty) ...[
          _buildSubSectionHeader('Cursos Online'),
          const SizedBox(height: 12),
          ...cursosOnline.map((curso) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildCursoOnlineCard(curso.toJson()),
            );
          }),
        ],

        const SizedBox(height: 16),

        // Cursos Técnicos
        if (cursosTecnicos.isNotEmpty) ...[
          _buildSubSectionHeader('Cursos Técnicos'),
          const SizedBox(height: 12),
          ...cursosTecnicos.map((curso) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildCursoTecnicoCard(curso.toJson()),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSubSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFEC8206),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCursoRecomendadoCard(Map<String, dynamic> curso) {
    final matchScore = curso['match_score'] as int;
    Color matchColor;
    if (matchScore >= 80) {
      matchColor = Colors.green;
    } else if (matchScore >= 60) {
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
          // TODO: Open link or navigate to course details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC8206).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Color(0xFFEC8206),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Course Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          curso['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          curso['institution'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Match Score
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
                          '$matchScore%',
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

              // Description
              Text(
                curso['description'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Details Row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    Icons.schedule,
                    '${curso['duration_months']} meses',
                  ),
                  _buildDetailChip(
                    Icons.location_on,
                    curso['location'] as String,
                  ),
                  _buildDetailChip(Icons.star, '${curso['rating']}'),
                  _buildDetailChip(Icons.category, curso['type'] as String),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCursoOnlineCard(Map<String, dynamic> curso) {
    final certificado = curso['certificate'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Open link
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Online Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.computer,
                      color: Colors.purple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Course Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          curso['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          curso['platform'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Certificate Badge
                  if (certificado)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue, width: 1.5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            'Certificado',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                curso['description'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Details Row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    Icons.access_time,
                    '${curso['duration_hours']}h',
                  ),
                  _buildDetailChip(
                    Icons.signal_cellular_alt,
                    curso['level'] as String,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCursoTecnicoCard(Map<String, dynamic> curso) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Open link
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Technical Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.engineering,
                      color: Colors.teal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Course Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          curso['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          curso['institution'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                curso['description'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Details Row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    Icons.schedule,
                    '${curso['duration_months']} meses',
                  ),
                  _buildDetailChip(
                    Icons.location_on,
                    curso['location'] as String,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildScholarships() {
    final bolsas = _roadmapData?.roadmap.bolsasEstudo ?? [];

    return Column(
      children: bolsas.map((bolsa) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildScholarshipCard(bolsa),
        );
      }).toList(),
    );
  }

  Widget _buildEntryOpportunities() {
    final oportunidades = _roadmapData?.roadmap.oportunidadesEntrada ?? [];

    return Column(
      children: oportunidades.map((oportunidade) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildEntryOpportunityCard(oportunidade),
        );
      }).toList(),
    );
  }

  Widget _buildNetworkingEvents() {
    final eventos = _roadmapData?.roadmap.eventosNetworking ?? [];

    return Column(
      children: eventos.map((evento) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildNetworkingEventCard(evento),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsToDevelop() {
    final habilidades = _roadmapData?.roadmap.habilidadesDesenvolver ?? [];

    return Column(
      children: habilidades.map((habilidade) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildSkillCard(habilidade),
        );
      }).toList(),
    );
  }

  Widget _buildJobMarket() {
    final mercado = _roadmapData?.roadmap.mercadoTrabalho;
    if (mercado == null) return const SizedBox.shrink();

    return _buildJobMarketCard(mercado);
  }

  Widget _buildScholarshipCard(ScholarshipOpportunity bolsa) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Open link
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bolsa.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bolsa.tipo,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 1.5),
                    ),
                    child: Text(
                      bolsa.porcentagem,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (bolsa.prazo.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Prazo: ${_formatDate(bolsa.prazo)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              if (bolsa.instituicoesAplicaveis.isNotEmpty) ...[
                const Text(
                  'Aplicável em:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bolsa.instituicoesAplicaveis.map((inst) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        inst,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntryOpportunityCard(EntryOpportunity oportunidade) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Open link
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC8206).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.work_outline,
                      color: Color(0xFFEC8206),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          oportunidade.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          oportunidade.tipoEmpresa,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailChip(Icons.location_on, oportunidade.localizacao),
                  _buildDetailChip(Icons.computer, oportunidade.modalidade),
                ],
              ),
              if (oportunidade.requisitos.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Requisitos:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                ...oportunidade.requisitos
                    .take(3)
                    .map(
                      (req) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                            Expanded(
                              child: Text(
                                req,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkingEventCard(NetworkingEvent evento) {
    final isPresencial = evento.tipo.toLowerCase().contains('presencial');
    final typeColor = isPresencial ? Colors.blue : Colors.purple;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Open link
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isPresencial ? Icons.place : Icons.computer,
                      color: typeColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          evento.descricao,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: typeColor, width: 1.5),
                    ),
                    child: Text(
                      evento.tipo,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailChip(Icons.location_on, evento.localizacao),
                  _buildDetailChip(
                    Icons.calendar_today,
                    _formatDate(evento.data),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCard(SkillToDevelop habilidade) {
    Color priorityColor;
    switch (habilidade.prioridade.toLowerCase()) {
      case 'alta':
        priorityColor = Colors.red;
        break;
      case 'média':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.psychology, color: priorityColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habilidade.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habilidade.categoria,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: priorityColor, width: 1.5),
                  ),
                  child: Text(
                    habilidade.prioridade,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
            if (habilidade.ondeAprender.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Onde aprender:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: habilidade.ondeAprender.map((local) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC8206).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      local,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFEC8206),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJobMarketCard(JobMarket mercado) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salary Info
            Row(
              children: [
                Expanded(
                  child: _buildSalaryBox(
                    'Salário Inicial',
                    mercado.salarioInicial,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSalaryBox(
                    'Salário Experiente',
                    mercado.salarioExperiente,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Trending Areas
            if (mercado.areasTendencia.isNotEmpty) ...[
              const Text(
                'Áreas em Alta:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: mercado.areasTendencia.map((area) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC8206).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFEC8206),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      area,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFEC8206),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Main Employers
            if (mercado.principaisEmpregadores.isNotEmpty) ...[
              const Text(
                'Principais Empregadores:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: mercado.principaisEmpregadores.map((emp) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      emp,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Trends
            if (mercado.tendencias.isNotEmpty) ...[
              const Text(
                'Tendências:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              ...mercado.tendencias.map(
                (tendencia) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 16,
                        color: Color(0xFFEC8206),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tendencia,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Fev',
        'Mar',
        'Abr',
        'Mai',
        'Jun',
        'Jul',
        'Ago',
        'Set',
        'Out',
        'Nov',
        'Dez',
      ];
      return '${date.day} de ${months[date.month - 1]}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_config.dart';
import '../../models/mentorship_request_model.dart';
import '../../services/auth_service.dart';

class ReceivedRequestsTab extends StatefulWidget {
  const ReceivedRequestsTab({super.key});

  @override
  State<ReceivedRequestsTab> createState() => _ReceivedRequestsTabState();
}

class _ReceivedRequestsTabState extends State<ReceivedRequestsTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<MentorshipRequest> _requests = [];
  static const String _cacheKey = 'received_requests_cache';
  static const String _cacheTimestampKey = 'received_requests_cache_timestamp';
  static const Duration _cacheDuration = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests({bool forceRefresh = false}) async {
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
            _requests = cachedData;
            _isLoading = false;
          });
          return;
        }
      }

      // Get authorization header
      final authHeader = await AuthService.getAuthorizationHeader();
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (authHeader != null) 'Authorization': authHeader,
      };

      final response = await http.get(
        Uri.parse(ApiConfig.receivedRequestsUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final requestsResponse = ReceivedRequestsResponse.fromJson(data);

        // Save to cache
        await _saveToCache(requestsResponse.requests);

        if (mounted) {
          setState(() {
            _requests = requestsResponse.requests;
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
            _errorMessage = 'Erro ao carregar solicitações. Tente novamente.';
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

  /// Load requests from cache if available and not expired
  Future<List<MentorshipRequest>?> _loadFromCache() async {
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
      return data
          .map((e) => MentorshipRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading from cache: $e');
      await _clearCache();
      return null;
    }
  }

  /// Save requests to cache
  Future<void> _saveToCache(List<MentorshipRequest> requests) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(requests.map((e) => e.toJson()).toList());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(_cacheTimestampKey, timestamp);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  /// Clear cache
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
        onRefresh: () => _loadRequests(forceRefresh: true),
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
                      onPressed: () => _loadRequests(forceRefresh: true),
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
      onRefresh: () => _loadRequests(forceRefresh: true),
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
                  'Solicitações Recebidas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_requests.length} ${_requests.length == 1 ? 'solicitação' : 'solicitações'}',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          // Requests List
          Expanded(
            child: _requests.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma solicitação recebida',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Quando alguém solicitar mentoria, aparecerá aqui',
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
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final request = _requests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildRequestCard(context, request),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, MentorshipRequest request) {
    Color statusColor;
    IconData statusIcon;

    if (request.isPending) {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    } else if (request.isAccepted) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
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
            // Header with mentee info and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile initial
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFEC8206), Color(0xFFF59E42)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      request.mentee.nome.isNotEmpty
                          ? request.mentee.nome[0].toUpperCase()
                          : 'M',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name and location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.mentee.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (request.mentee.location.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              request.mentee.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        request.statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mensagem:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    request.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2D3142),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Date
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(request.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),

            // Action buttons for pending requests
            if (request.isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Reject request
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidade em breve'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Rejeitar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
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
                        // TODO: Accept request
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidade em breve'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Aceitar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Agora';
        }
        return '${difference.inMinutes}min atrás';
      }
      return '${difference.inHours}h atrás';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}


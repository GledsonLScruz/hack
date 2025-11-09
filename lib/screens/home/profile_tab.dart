import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../services/auth_service.dart';
import '../../models/user_logged_data.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isLoading = true;
  String? _errorMessage;
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load user data from SharedPreferences (stored during login)
      final userLoggedData = await AuthService.getUserData();

      if (userLoggedData == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Sessão expirada. Faça login novamente.';
            _isLoading = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _userData = userLoggedData.user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar dados do perfil.';
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
                onPressed: _loadUserData,
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

    if (_userData == null) {
      return const Center(child: Text('Nenhum dado de perfil disponível'));
    }

    final userName = _userData!.nome;
    final userRole = _userData!.isMentor ? 'Mentor' : 'Aluno';
    final userPhoto = null; // URL to user photo or null
    final userEmail = _userData!.email;

    // Parse areas of interest and strengths from comma-separated strings
    final areasOfInterest = _userData!.areasInteresse
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final strengths = _userData!.pontosFortes
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section with gradient background
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEC8206), Color(0xFFF59E42)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    // Profile Photo/Initial
                    _buildProfilePhoto(userName, userPhoto),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        userRole,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Email
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to edit profile screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Funcionalidade de edição em breve',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Perfil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFEC8206),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Areas of Interest Section
                _buildSectionTitle('Áreas de Interesse', Icons.interests),
                const SizedBox(height: 16),
                _buildChipsList(areasOfInterest, Colors.deepPurple),
                const SizedBox(height: 32),

                // Strengths Section
                _buildSectionTitle('Pontos Fortes', Icons.star),
                const SizedBox(height: 16),
                _buildChipsList(strengths, Colors.amber),
                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sair da Conta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto(String userName, String? photoUrl) {
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF2D3142)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildChipsList(List<String> items, Color color) {
    if (items.isEmpty) {
      return Text(
        'Nenhum item cadastrado',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text('Tem certeza que deseja sair da sua conta?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog

                // Clear all caches (user data, roadmap, mentors, profile)
                await AuthService.clearAllCaches();

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}

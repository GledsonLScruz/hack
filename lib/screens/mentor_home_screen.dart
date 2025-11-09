import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'mentor/received_requests_tab.dart';
import 'home/profile_tab.dart';
import '../services/auth_service.dart';

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({super.key});

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  int _currentIndex = 0;

  Future<void> _handleLogout() async {
    // Clear all caches (user data, roadmap, mentors, profile, requests)
    await AuthService.clearAllCaches();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _currentIndex == 0
          ? const ReceivedRequestsTab()
          : const ProfileTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Solicitações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Solicitações';
      case 1:
        return 'Perfil';
      default:
        return 'Mentor';
    }
  }
}


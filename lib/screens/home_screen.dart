import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home/roadmap_tab.dart';
import 'home/mentors_tab.dart';
import 'home/profile_tab.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Future<void> _handleLogout() async {
    // Clear all caches (user data, roadmap, mentors, profile)
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
          ? RoadMapTab()
          : _currentIndex == 1
          ? MentorsTab()
          : _currentIndex == 2
          ? ProfileTab()
          : RoadMapTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Perspectiva'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Mentores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Perspectiva';
      case 1:
        return 'Mentores';
      case 2:
        return 'Perfil';
      default:
        return 'Carreira';
    }
  }
}

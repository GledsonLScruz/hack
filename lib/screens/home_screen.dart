import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home/roadmap_tab.dart';
import 'home/mentors_tab.dart';
import 'home/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
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
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'RoadMap'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Mentores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'RoadMap';
      case 1:
        return 'Mentores';
      case 2:
        return 'Perfil';
      default:
        return 'CareerPath';
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildRoadMapTab();
      case 1:
        return _buildMentorsTab();
      case 2:
        return _buildProfileTab();
      default:
        return _buildRoadMapTab();
    }
  }

  Widget _buildRoadMapTab() {
    return const RoadMapTab();
  }

  Widget _buildMentorsTab() {
    return const MentorsTab();
  }

  Widget _buildProfileTab() {
    return const ProfileTab();
  }
}

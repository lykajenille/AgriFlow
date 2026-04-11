import 'package:flutter/material.dart';
import '../models/user.dart';
import 'farmer/farmer_home.dart';
import 'farmer/farmer_farms.dart';
import 'farmer/farmer_crops.dart';
import 'farmer/farmer_reports.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final User userId;

  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final _farmsKey = GlobalKey<FarmerFarmsState>();
  final _cropsKey = GlobalKey<FarmerCropsState>();

  final _titles = ['Home', 'My Farms', 'My Crops', 'Reports'];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          FarmerHome(user: widget.userId, onNavigate: _onNavTap),
          FarmerFarms(key: _farmsKey, user: widget.userId),
          FarmerCrops(key: _cropsKey, user: widget.userId),
          FarmerReports(user: widget.userId),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () => _farmsKey.currentState?.showAddFarmDialog(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : _selectedIndex == 2
              ? FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () => _cropsKey.currentState?.showAddCropDialog(),
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture_rounded), label: 'Farms'),
          BottomNavigationBarItem(icon: Icon(Icons.eco_rounded), label: 'Crops'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment_rounded), label: 'Reports'),
        ],
      ),
    );
  }
}
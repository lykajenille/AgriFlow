import 'package:flutter/material.dart';
import 'package:agriflow/screens/login_screen.dart';
import 'package:agriflow/models/user.dart';
import 'admin_overview.dart';
import 'admin_users.dart';
import 'admin_farms.dart';
import 'admin_crops.dart';
import 'admin_reports.dart';
import 'admin_settings.dart';

class AdminDashboard extends StatefulWidget {
  final User user;
  const AdminDashboard({super.key, required this.user});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem('Overview', Icons.dashboard_rounded),
    _NavItem('Users', Icons.people_rounded),
    _NavItem('Farms', Icons.agriculture_rounded),
    _NavItem('Crops', Icons.grass_rounded),
    _NavItem('Reports', Icons.assessment_rounded),
    _NavItem('Settings', Icons.settings_rounded),
  ];

  void _navigateTo(int index) => setState(() => _selectedIndex = index);

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // â”€â”€ App Bar â”€â”€
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.green[800],
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.eco, size: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AgriFlow Admin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _navItems[_selectedIndex].label,
                style: TextStyle(fontSize: 12, color: Colors.green[100]),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Badge(
            smallSize: 8,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: _logout,
            child: Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.green[600],
                child: Text(
                  widget.user.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              label: Text(
                widget.user.username,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              backgroundColor: Colors.green[700],
              side: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // â”€â”€ Drawer â”€â”€
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[800]!, Colors.green[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    widget.user.username[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.user.fullName ?? widget.user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Administrator',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < _navItems.length; i++)
                  ListTile(
                    leading: Icon(
                      _navItems[i].icon,
                      color: _selectedIndex == i
                          ? Colors.green[700]
                          : Colors.grey[600],
                    ),
                    title: Text(
                      _navItems[i].label,
                      style: TextStyle(
                        fontWeight: _selectedIndex == i
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedIndex == i
                            ? Colors.green[700]
                            : Colors.grey[800],
                      ),
                    ),
                    selected: _selectedIndex == i,
                    selectedTileColor: Colors.green[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      _navigateTo(i);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[400]),
            title: Text('Logout', style: TextStyle(color: Colors.red[400])),
            onTap: _logout,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // â”€â”€ Bottom Nav â”€â”€
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
      onTap: _navigateTo,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      items: _navItems.take(5).map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }

  // â”€â”€ Body â”€â”€
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return AdminOverview(user: widget.user, onNavigate: _navigateTo);
      case 1:
        return const AdminUsers();
      case 2:
        return const AdminFarms();
      case 3:
        return const AdminCrops();
      case 4:
        return const AdminReports();
      case 5:
        return const AdminSettings();
      default:
        return AdminOverview(user: widget.user, onNavigate: _navigateTo);
    }
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}

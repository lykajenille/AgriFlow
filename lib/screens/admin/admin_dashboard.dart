import 'package:flutter/material.dart';
import 'package:agriflow/screens/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'System Settings'),
            Tab(text: 'User Activity'),
            Tab(text: 'System Reports'),
            Tab(text: 'Access Control'),
            Tab(text: 'Farm Performance'),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // System Settings Tab
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Settings',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Data needed to manage the system itself.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),
                _settingsCard('Notification Preferences', 'Manage how you receive alerts'),
                _settingsCard('Reminders', 'Set up automatic reminders'),
                _settingsCard('System Maintenance', 'Schedule system maintenance'),
                _settingsCard('Backup Settings', 'Configure data backup options'),
              ],
            ),
          ),
          // User Activity Logs Tab
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Activity Logs',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Login history, operations performed',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),
                _activityCard('Admin logged in', 'Today 10:30 AM', Icons.login),
                _activityCard('Database backup completed', 'Today 09:15 AM', Icons.backup),
                _activityCard('User roles updated', 'Yesterday 03:45 PM', Icons.edit),
                _activityCard('System report generated', 'Yesterday 01:20 PM', Icons.description),
              ],
            ),
          ),
          // Reports Tab
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Reports',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Daily, weekly, monthly farm performance reports',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),
                _reportCard('Daily Report', 'Today\'s farm operations summary', Icons.today),
                _reportCard('Weekly Report', 'Last 7 days performance metrics', Icons.date_range),
                _reportCard('Monthly Report', 'Full month analysis and insights', Icons.calendar_month),
                _reportCard('Yield Analysis', 'Crop yield trends and predictions', Icons.trending_up),
              ],
            ),
          ),
          // Access Control Tab
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Access Control',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Who can see or edit data',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),
                _accessCard('Admin Role', 'Full system access', Colors.red),
                _accessCard('Manager Role', 'Farm management and reporting', Colors.orange),
                _accessCard('Worker Role', 'Data entry and monitoring', Colors.blue),
                _accessCard('Viewer Role', 'Read-only access to reports', Colors.green),
              ],
            ),
          ),
          // Farm Performance Tab
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farm Performance',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Daily, weekly, monthly farm performance metrics',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),
                _performanceCard('Total Farms', '45', Icons.agriculture),
                _performanceCard('Active Crops', '127', Icons.grain),
                _performanceCard('Avg Yield', '8.5 tons/ha', Icons.trending_up),
                _performanceCard('Health Score', '92%', Icons.favorite),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {},
      ),
    );
  }

  Widget _activityCard(String title, String time, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(time),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _reportCard(String title, String description, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.download),
        onTap: () {},
      ),
    );
  }

  Widget _accessCard(String role, String description, Color color) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: ListTile(
          title: Text(role, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
          trailing: Icon(Icons.people, color: color),
        ),
      ),
    );
  }

  Widget _performanceCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
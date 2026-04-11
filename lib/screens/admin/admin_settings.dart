import 'package:flutter/material.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),
          _settingsTile('Notifications', 'Manage alerts & reminders',
              Icons.notifications_rounded),
          _settingsTile('Backup & Restore', 'Configure data backup',
              Icons.backup_rounded),
          _settingsTile('Access Control', 'Manage user roles & permissions',
              Icons.security_rounded),
          _settingsTile('System Maintenance', 'Schedule maintenance tasks',
              Icons.build_rounded),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'AgriFlow v1.0.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title:
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: () {},
      ),
    );
  }
}

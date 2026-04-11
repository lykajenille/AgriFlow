import 'package:flutter/material.dart';
import '../../services/api_services.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  List<dynamic> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final data = await ApiService.getAdminUsers();
      if (data['success'] == true) {
        setState(() {
          _users = data['users'] ?? [];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }

    return RefreshIndicator(
      color: Colors.green,
      onRefresh: _loadUsers,
      child: _users.isEmpty
          ? Center(child: Text('No users found', style: TextStyle(color: Colors.grey[500])))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('User Management',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  );
                }
                return _userCard(_users[index - 1]);
              },
            ),
    );
  }

  Widget _userCard(Map<String, dynamic> u) {
    final name = u['full_name'] ?? u['username'] ?? 'Unknown';
    final role = u['role'] ?? 'farmer';
    final farms = u['farm_count'] ?? 0;
    final isAdmin = role == 'admin';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isAdmin ? Colors.orange[100] : Colors.green[100],
          child: Text(
            name[0].toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, color: isAdmin ? Colors.orange[800] : Colors.green[800]),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${u['email'] ?? ''} • $farms farms', style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isAdmin ? Colors.orange[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 12,
              color: isAdmin ? Colors.orange[700] : Colors.green[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
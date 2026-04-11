import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/api_services.dart';

class AdminOverview extends StatefulWidget {
  final User user;
  final void Function(int) onNavigate;

  const AdminOverview({super.key, required this.user, required this.onNavigate});

  @override
  State<AdminOverview> createState() => _AdminOverviewState();
}

class _AdminOverviewState extends State<AdminOverview> {
  Map<String, dynamic>? _stats;
  List<dynamic> _activity = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final data = await ApiService.getAdminStats();
      if (data['success'] == true) {
        setState(() {
          _stats = data['stats'];
          _activity = data['recent_activity'] ?? [];
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
      onRefresh: _loadStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${widget.user.fullName ?? widget.user.username}!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Here\'s what\'s happening across all farms.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _statCard('Total Farms', '${_stats?['total_farms'] ?? 0}',
                    Icons.agriculture_rounded, Colors.green),
                _statCard('Active Crops', '${_stats?['total_crops'] ?? 0}',
                    Icons.grass_rounded, Colors.teal),
                _statCard('Farmers', '${_stats?['total_farmers'] ?? 0}',
                    Icons.people_rounded, Colors.blue),
                _statCard('Harvested', '${_formatNum(_stats?['total_harvests'] ?? 0)} t',
                    Icons.trending_up_rounded, Colors.orange),
              ],
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                Icon(Icons.history, color: Colors.green[700], size: 22),
                const SizedBox(width: 8),
                Text('Recent Activity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              ],
            ),
            const SizedBox(height: 12),
            if (_activity.isEmpty)
              _emptyCard('No activity yet')
            else
              ..._activity.map((a) => _activityTile(a)),
            const SizedBox(height: 28),

            Row(
              children: [
                Icon(Icons.bolt, color: Colors.amber[700], size: 22),
                const SizedBox(width: 8),
                Text('Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _quickAction('Farms', Icons.add_business_rounded, Colors.green, () => widget.onNavigate(2))),
                const SizedBox(width: 12),
                Expanded(child: _quickAction('Users', Icons.people_rounded, Colors.blue, () => widget.onNavigate(1))),
                const SizedBox(width: 12),
                Expanded(child: _quickAction('Reports', Icons.assessment_rounded, Colors.purple, () => widget.onNavigate(4))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNum(dynamic v) {
    final num n = v is num ? v : num.tryParse(v.toString()) ?? 0;
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);
  }

  Widget _statCard(String title, String value, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: color[50], borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color[700], size: 20),
              ),
              Flexible(
                child: Text(value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _activityTile(Map<String, dynamic> a) {
    final type = a['type'] ?? '';
    final IconData icon;
    final Color color;
    switch (type) {
      case 'user':
        icon = Icons.person_add_rounded; color = Colors.blue;
      case 'crop':
        icon = Icons.eco_rounded; color = Colors.green;
      case 'expense':
        icon = Icons.receipt_long_rounded; color = Colors.orange;
      default:
        icon = Icons.info_rounded; color = Colors.grey;
    }

    return Card(
      elevation: 0, color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(a['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(a['subtitle'] ?? '', style: const TextStyle(fontSize: 12)),
        trailing: Text(_timeAgo(a['time']), style: TextStyle(color: Colors.grey[500], fontSize: 11)),
      ),
    );
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.month}/${date.day}';
    } catch (_) {
      return '';
    }
  }

  Widget _quickAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(14)),
      child: Text(msg, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500])),
    );
  }
}

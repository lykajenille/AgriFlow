import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/api_services.dart';

class FarmerHome extends StatefulWidget {
  final User user;
  final void Function(int) onNavigate;

  const FarmerHome({super.key, required this.user, required this.onNavigate});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  Map<String, dynamic>? _stats;
  List<dynamic> _recentCrops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final data = await ApiService.getDashboardStats(widget.user.id!);
      if (data['success'] == true) {
        setState(() {
          _stats = data['stats'];
          _recentCrops = data['recent_crops'] ?? [];
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
            // Greeting
            Text(
              'Hello, ${widget.user.fullName ?? widget.user.username}! 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Here\'s your farm overview.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),

            // Stat cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _statCard(
                  'My Farms',
                  '${_stats?['total_farms'] ?? 0}',
                  Icons.agriculture_rounded,
                  Colors.green,
                ),
                _statCard(
                  'My Crops',
                  '${_stats?['total_crops'] ?? 0}',
                  Icons.grass_rounded,
                  Colors.teal,
                ),
                _statCard(
                  'Expenses',
                  '₱${_formatNumber(_stats?['total_expenses'] ?? 0)}',
                  Icons.receipt_long_rounded,
                  Colors.orange,
                ),
                _statCard(
                  'Harvested',
                  '${_formatNumber(_stats?['total_harvests'] ?? 0)} t',
                  Icons.inventory_2_rounded,
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _quickAction('Add Farm', Icons.add_business_rounded,
                      Colors.green, () => widget.onNavigate(1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction('Add Crop', Icons.eco_rounded,
                      Colors.teal, () => widget.onNavigate(2)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction('Reports', Icons.assessment_rounded,
                      Colors.purple, () => widget.onNavigate(3)),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Recent Crops
            Text(
              'Recent Crops',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            if (_recentCrops.isEmpty)
              _emptyState('No crops yet. Add a farm then plant some crops!')
            else
              ..._recentCrops.map((crop) => _cropTile(crop)),
          ],
        ),
      ),
    );
  }

  String _formatNumber(dynamic value) {
    final num n = value is num ? value : num.tryParse(value.toString()) ?? 0;
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);
  }

  Widget _statCard(String title, String value, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
                decoration: BoxDecoration(
                  color: color[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color[700], size: 20),
              ),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cropTile(Map<String, dynamic> crop) {
    final status = crop['status'] ?? 'Unknown';
    final color = status == 'Harvest Ready'
        ? Colors.orange
        : status == 'Growing'
            ? Colors.green
            : Colors.blue;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.eco_rounded, color: color, size: 22),
        ),
        title: Text(
          crop['crop_name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          crop['farm_name'] ?? '',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.eco_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }
}

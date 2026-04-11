import 'package:flutter/material.dart';
import '../../services/api_services.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  List<dynamic> _reports = [];
  Map<String, dynamic>? _summary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final data = await ApiService.getAdminReports();
      if (data['success'] == true) {
        setState(() {
          _reports = data['reports'] ?? [];
          _summary = data['summary'];
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
      onRefresh: _loadReports,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports & Analytics',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 8),
            Text('Farm performance overview from the database.',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),

            // Summary cards
            if (_summary != null)
              Row(
                children: [
                  Expanded(child: _summaryCard('Total Expenses',
                      '₱${_formatNum(_summary!['total_expenses'] ?? 0)}', Colors.red)),
                  const SizedBox(width: 12),
                  Expanded(child: _summaryCard('Total Harvests',
                      '${_formatNum(_summary!['total_harvests'] ?? 0)} t', Colors.green)),
                ],
              ),
            const SizedBox(height: 24),

            Text('Per-Farm Breakdown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 12),

            if (_reports.isEmpty)
              Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('No farm data yet', style: TextStyle(color: Colors.grey[500])),
              ))
            else
              ..._reports.map((r) => _reportCard(r)),
          ],
        ),
      ),
    );
  }

  String _formatNum(dynamic v) {
    final num n = v is num ? v : num.tryParse(v.toString()) ?? 0;
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(2);
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _reportCard(Map<String, dynamic> r) {
    final expenses = double.tryParse(r['total_expenses']?.toString() ?? '0') ?? 0;
    final harvests = double.tryParse(r['total_harvests']?.toString() ?? '0') ?? 0;
    final crops = r['crop_count'] ?? 0;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.agriculture_rounded, color: Colors.purple[700], size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['farm_name'] ?? 'Farm',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Owner: ${r['owner_name'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _chip(Icons.eco, '$crops crops', Colors.teal),
                const SizedBox(width: 8),
                _chip(Icons.receipt_long, '₱${expenses.toStringAsFixed(0)}', Colors.orange),
                const SizedBox(width: 8),
                _chip(Icons.inventory_2, '${harvests.toStringAsFixed(1)} t', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
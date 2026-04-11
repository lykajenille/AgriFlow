import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/api_services.dart';

class FarmerReports extends StatefulWidget {
  final User user;

  const FarmerReports({super.key, required this.user});

  @override
  State<FarmerReports> createState() => _FarmerReportsState();
}

class _FarmerReportsState extends State<FarmerReports> {
  List<dynamic> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final data = await ApiService.getReports(widget.user.id!);
      setState(() {
        _reports = data;
        _loading = false;
      });
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
      child: _reports.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reports.length,
              itemBuilder: (context, index) => _reportCard(_reports[index]),
            ),
    );
  }

  Widget _reportCard(Map<String, dynamic> report) {
    final expenses = double.tryParse(report['total_expenses']?.toString() ?? '0') ?? 0;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.assessment_rounded, color: Colors.purple[700], size: 24),
        ),
        title: Text(
          report['farm_name'] ?? 'Farm',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          'Total Expenses: ₱${expenses.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text('No reports yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text('Add farms and expenses to see reports', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

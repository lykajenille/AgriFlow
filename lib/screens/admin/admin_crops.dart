import 'package:flutter/material.dart';
import '../../services/api_services.dart';

class AdminCrops extends StatefulWidget {
  const AdminCrops({super.key});

  @override
  State<AdminCrops> createState() => _AdminCropsState();
}

class _AdminCropsState extends State<AdminCrops> {
  List<dynamic> _crops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    try {
      final data = await ApiService.getAdminCrops();
      if (data['success'] == true) {
        setState(() {
          _crops = data['crops'] ?? [];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'growing': return Colors.green;
      case 'harvest ready': return Colors.orange;
      case 'seedling': return Colors.blue;
      case 'harvested': return Colors.grey;
      default: return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }

    return RefreshIndicator(
      color: Colors.green,
      onRefresh: _loadCrops,
      child: _crops.isEmpty
          ? Center(child: Text('No crops found', style: TextStyle(color: Colors.grey[500])))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _crops.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('Crop Monitoring',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  );
                }
                return _cropCard(_crops[index - 1]);
              },
            ),
    );
  }

  Widget _cropCard(Map<String, dynamic> c) {
    final status = c['status'] ?? 'Unknown';
    final color = _statusColor(status);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.grass, color: color),
        ),
        title: Text(c['crop_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${c['farm_name'] ?? ''} • ${c['owner_name'] ?? ''}', style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
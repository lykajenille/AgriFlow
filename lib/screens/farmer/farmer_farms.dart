import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/api_services.dart';

class FarmerFarms extends StatefulWidget {
  final User user;

  const FarmerFarms({super.key, required this.user});

  @override
  State<FarmerFarms> createState() => FarmerFarmsState();
}

class FarmerFarmsState extends State<FarmerFarms> {
  List<dynamic> _farms = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    try {
      final data = await ApiService.getFarms(widget.user.id!);
      if (data['success'] == true) {
        setState(() {
          _farms = data['farms'] ?? [];
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
      onRefresh: _loadFarms,
      child: _farms.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _farms.length,
              itemBuilder: (context, index) => _farmCard(_farms[index]),
            ),
    );
  }

  Widget _farmCard(Map<String, dynamic> farm) {
    final cropCount = farm['crop_count'] ?? 0;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.agriculture_rounded, color: Colors.green[700], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farm['farm_name'] ?? 'Unnamed Farm',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (farm['location'] != null && farm['location'] != '')
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              farm['location'],
                              style: TextStyle(color: Colors.grey[500], fontSize: 13),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoChip(Icons.straighten, '${farm['size'] ?? '—'} ha'),
                const SizedBox(width: 12),
                _infoChip(Icons.eco, '$cropCount crops'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text('No farms yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text('Tap + to add your first farm', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }

  void showAddFarmDialog() {
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final sizeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Farm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Farm Name *'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: sizeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Size (hectares)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              final result = await ApiService.addFarm(
                userId: widget.user.id!,
                farmName: nameCtrl.text.trim(),
                location: locationCtrl.text.trim(),
                size: sizeCtrl.text.trim(),
              );
              if (result['status'] == 'success') {
                _loadFarms();
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

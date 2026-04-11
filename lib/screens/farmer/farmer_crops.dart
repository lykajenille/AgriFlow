import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/api_services.dart';

class FarmerCrops extends StatefulWidget {
  final User user;

  const FarmerCrops({super.key, required this.user});

  @override
  State<FarmerCrops> createState() => FarmerCropsState();
}

class FarmerCropsState extends State<FarmerCrops> {
  List<dynamic> _crops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    try {
      final data = await ApiService.getCrops(widget.user.id!);
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }

    return RefreshIndicator(
      color: Colors.green,
      onRefresh: _loadCrops,
      child: _crops.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _crops.length,
              itemBuilder: (context, index) => _cropCard(_crops[index]),
            ),
    );
  }

  Widget _cropCard(Map<String, dynamic> crop) {
    final status = crop['status'] ?? 'Unknown';
    final color = _statusColor(status);

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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.eco_rounded, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop['crop_name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        crop['farm_name'] ?? '',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (crop['planting_date'] != null && crop['planting_date'] != '')
                  _infoChip(Icons.calendar_today, 'Planted: ${crop['planting_date']}'),
                if (crop['expected_harvest'] != null && crop['expected_harvest'] != '') ...[
                  const SizedBox(width: 10),
                  _infoChip(Icons.event, 'Harvest: ${crop['expected_harvest']}'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'growing':
        return Colors.green;
      case 'harvest ready':
        return Colors.orange;
      case 'seedling':
        return Colors.blue;
      case 'harvested':
        return Colors.grey;
      default:
        return Colors.teal;
    }
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
          Icon(icon, size: 13, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text('No crops yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text('Add a farm first, then plant some crops', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }

  void showAddCropDialog() async {
    // Fetch user's farms for the dropdown
    List<dynamic> farms = [];
    try {
      final data = await ApiService.getFarms(widget.user.id!);
      if (data['success'] == true) {
        farms = data['farms'] ?? [];
      }
    } catch (_) {}

    if (farms.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a farm first before adding crops')),
      );
      return;
    }

    final nameCtrl = TextEditingController();
    int? selectedFarmId = farms.first['id'] is int
        ? farms.first['id']
        : int.tryParse(farms.first['id'].toString());
    String selectedStatus = 'Seedling';
    DateTime? plantingDate;
    DateTime? harvestDate;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Crop'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Crop Name *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: selectedFarmId,
                  decoration: const InputDecoration(labelText: 'Farm *'),
                  items: farms.map<DropdownMenuItem<int>>((f) {
                    final id = f['id'] is int ? f['id'] : int.tryParse(f['id'].toString()) ?? 0;
                    return DropdownMenuItem(value: id, child: Text(f['farm_name'] ?? 'Farm'));
                  }).toList(),
                  onChanged: (v) => setDialogState(() => selectedFarmId = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['Seedling', 'Growing', 'Harvest Ready', 'Harvested']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => selectedStatus = v!),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(plantingDate == null
                      ? 'Planting Date'
                      : 'Planted: ${_formatDate(plantingDate!)}'),
                  trailing: const Icon(Icons.calendar_today, size: 20),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setDialogState(() => plantingDate = picked);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(harvestDate == null
                      ? 'Expected Harvest'
                      : 'Harvest: ${_formatDate(harvestDate!)}'),
                  trailing: const Icon(Icons.event, size: 20),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now().add(const Duration(days: 90)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setDialogState(() => harvestDate = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty || selectedFarmId == null) return;
                Navigator.pop(ctx);
                try {
                  await ApiService.addCrop(
                    farmId: selectedFarmId!,
                    cropName: nameCtrl.text.trim(),
                    plantingDate: plantingDate != null ? _formatDate(plantingDate!) : '',
                    expectedHarvest: harvestDate != null ? _formatDate(harvestDate!) : '',
                    status: selectedStatus,
                  );
                  _loadCrops();
                } catch (_) {}
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

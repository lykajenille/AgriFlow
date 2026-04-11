import 'package:flutter/material.dart';
import '../../services/api_services.dart';

class AdminFarms extends StatefulWidget {
  const AdminFarms({super.key});

  @override
  State<AdminFarms> createState() => _AdminFarmsState();
}

class _AdminFarmsState extends State<AdminFarms> {
  List<dynamic> _farms = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    try {
      final data = await ApiService.getAdminFarms();
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
          ? Center(child: Text('No farms found', style: TextStyle(color: Colors.grey[500])))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _farms.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('Farm Management',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  );
                }
                return _farmCard(_farms[index - 1]);
              },
            ),
    );
  }

  Widget _farmCard(Map<String, dynamic> f) {
    final cropCount = f['crop_count'] ?? 0;
    final owner = f['owner_name'] ?? f['owner_username'] ?? 'Unknown';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.agriculture_rounded, color: Colors.green[700], size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['farm_name'] ?? 'Unnamed',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(owner,
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  if (f['location'] != null && f['location'] != '') ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(f['location'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        if (f['size'] != null) ...[
                          const SizedBox(width: 10),
                          Icon(Icons.straighten, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text('${f['size']} ha', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$cropCount crops',
                  style: TextStyle(color: Colors.teal[700], fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
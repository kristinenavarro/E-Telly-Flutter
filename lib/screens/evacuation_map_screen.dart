// screens/evacuation_map_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EvacuationCenter {
  final int id;
  final String name;
  final String address;
  final int capacity;
  final int currentOccupancy;
  final String status; // 'available', 'almost_full', 'full'
  final String contact;
  final String coordinates;
  final String distance;
  final List<String> facilities;
  final String operatingHours;

  EvacuationCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.capacity,
    required this.currentOccupancy,
    required this.status,
    required this.contact,
    required this.coordinates,
    required this.distance,
    required this.facilities,
    required this.operatingHours,
  });
}

class EvacuationMapScreen extends StatefulWidget {
  @override
  _EvacuationMapScreenState createState() => _EvacuationMapScreenState();
}

class _EvacuationMapScreenState extends State<EvacuationMapScreen> {
  String _activeTab = 'evac';
  
  final List<EvacuationCenter> _evacuationCenters = [
    EvacuationCenter(
      id: 1,
      name: 'Navotas City Hall Evacuation Center',
      address: 'M. Naval St, Navotas, Metro Manila',
      capacity: 500,
      currentOccupancy: 480,
      status: 'almost_full',
      contact: '288-4567',
      coordinates: '14.6525,120.9439',
      distance: '1.2 km',
      facilities: ['Medical Station', 'Food & Water', 'Restrooms', 'Power Outlets'],
      operatingHours: '24/7',
    ),
    EvacuationCenter(
      id: 2,
      name: 'Navotas Sports Complex',
      address: 'M. Naval St, Navotas, Metro Manila',
      capacity: 800,
      currentOccupancy: 320,
      status: 'available',
      contact: '288-4568',
      coordinates: '14.6489,120.9487',
      distance: '2.5 km',
      facilities: ['Medical Station', 'Food & Water', 'Restrooms', 'Showers', 'Play Area'],
      operatingHours: '24/7',
    ),
    EvacuationCenter(
      id: 3,
      name: 'Navotas National High School',
      address: 'M. Naval St, Navotas, Metro Manila',
      capacity: 1200,
      currentOccupancy: 150,
      status: 'available',
      contact: '288-4569',
      coordinates: '14.6512,120.9523',
      distance: '3.1 km',
      facilities: ['Medical Station', 'Food & Water', 'Restrooms', 'Classroom Areas'],
      operatingHours: '24/7',
    ),
    EvacuationCenter(
      id: 4,
      name: 'Tangos Elementary School',
      address: 'Tangos, Navotas, Metro Manila',
      capacity: 400,
      currentOccupancy: 400,
      status: 'full',
      contact: '288-4570',
      coordinates: '14.6550,120.9500',
      distance: '0.8 km',
      facilities: ['Food & Water', 'Restrooms'],
      operatingHours: '24/7',
    ),
    EvacuationCenter(
      id: 5,
      name: 'Navotas Polytechnic College',
      address: 'Bangus St, Navotas, Metro Manila',
      capacity: 600,
      currentOccupancy: 180,
      status: 'available',
      contact: '288-4571',
      coordinates: '14.6533,120.9555',
      distance: '2.8 km',
      facilities: ['Medical Station', 'Food & Water', 'Restrooms', 'Study Areas'],
      operatingHours: '24/7',
    ),
  ];

  // Bottom Navigation Items
  final List<Map<String, dynamic>> _bottomNavItems = [
    {'id': 'home', 'label': 'Home', 'icon': Icons.home_outlined, 'iconActive': Icons.home},
    {'id': 'safety', 'label': 'Safety Tips', 'icon': Icons.security_outlined, 'iconActive': Icons.security},
    {'id': 'evac', 'label': 'Evac Nav', 'icon': Icons.map_outlined, 'iconActive': Icons.map},
    {'id': 'resources', 'label': 'Resources', 'icon': Icons.inventory_2_outlined, 'iconActive': Icons.inventory_2},
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person_outline, 'iconActive': Icons.person},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return const Color(0xFF10B981);
      case 'almost_full':
        return const Color(0xFFF59E0B);
      case 'full':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'available':
        return 'Available';
      case 'almost_full':
        return 'Almost Full';
      case 'full':
        return 'FULL';
      default:
        return 'Unknown';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'available':
        return Icons.check_circle;
      case 'almost_full':
        return Icons.warning;
      case 'full':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Future<void> _openDirections(String coordinates) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$coordinates&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Unable to open directions'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openContact(String contact) async {
    final cleanNumber = contact.replaceAll(RegExp(r'[^\d+]'), '');
    final url = 'tel:$cleanNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Unable to make call'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<EvacuationCenter> get _availableCenters =>
      _evacuationCenters.where((center) => center.status == 'available').toList();
  
  List<EvacuationCenter> get _almostFullCenters =>
      _evacuationCenters.where((center) => center.status == 'almost_full').toList();
  
  List<EvacuationCenter> get _fullCenters =>
      _evacuationCenters.where((center) => center.status == 'full').toList();

  void _handleBottomNavPress(String id) {
    setState(() {
      _activeTab = id;
    });
    
    // Navigate using named routes
    switch (id) {
      case 'home':
        Navigator.pushNamed(context, '/home');
        break;
      case 'safety':
        Navigator.pushNamed(context, '/safety-tips');
        break;
      case 'resources':
        Navigator.pushNamed(context, '/resources');
        break;
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'evac':
        // Already on this screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDC2626).withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () => Navigator.pop(context), // Use Navigator.pop to go back
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Evacuation Centers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_availableCenters.length} Available • ${_evacuationCenters.length} Total',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDC2626).withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Info'),
                            content: const Text(
                              'Evacuation centers are safe shelters during floods. Check availability before going.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),

            // Status Summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildSummaryItem(
                    color: const Color(0xFF10B981),
                    count: _availableCenters.length,
                    label: 'Available',
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryItem(
                    color: const Color(0xFFF59E0B),
                    count: _almostFullCenters.length,
                    label: 'Almost Full',
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryItem(
                    color: const Color(0xFFDC2626),
                    count: _fullCenters.length,
                    label: 'Full',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFDC2626).withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_outlined, size: 20, color: Color(0xFFDC2626)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: const Text(
                      'Check center availability before going. Bring essential items: medicines, documents, food, water.',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Evacuation Centers List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _evacuationCenters.length,
                itemBuilder: (context, index) {
                  final center = _evacuationCenters[index];
                  final statusColor = _getStatusColor(center.status);
                  final occupancyPercent = (center.currentOccupancy / center.capacity) * 100;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(_getStatusIcon(center.status), size: 16, color: statusColor),
                                const SizedBox(width: 6),
                                Text(
                                  _getStatusText(center.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 12, color: Color(0xFF666666)),
                                const SizedBox(width: 4),
                                Text(
                                  center.distance,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Center Info
                        Text(
                          center.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          center.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Occupancy Bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: center.currentOccupancy / center.capacity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${center.currentOccupancy}/${center.capacity} (${occupancyPercent.round()}%)',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Facilities
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            ...center.facilities.take(3).map((facility) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check, size: 12, color: statusColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    facility,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            if (center.facilities.length > 3)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  '+${center.facilities.length - 3} more',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: center.status == 'full' 
                                    ? null 
                                    : () => _openDirections(center.coordinates),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: statusColor,
                                  side: BorderSide(
                                    color: center.status == 'full'
                                        ? Colors.grey[300]!
                                        : statusColor.withOpacity(0.5),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.navigation, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Directions',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _openContact(center.contact),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: statusColor,
                                  side: BorderSide(color: statusColor),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.call, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Operating Hours
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Color(0xFF666666)),
                            const SizedBox(width: 6),
                            Text(
                              center.operatingHours,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: _bottomNavItems.map((item) {
                  final isActive = _activeTab == item['id'];
                  return Expanded(
                    child: Material(
                      color: isActive
                          ? const Color(0xFFDC2626).withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () => _handleBottomNavPress(item['id']),
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive ? item['iconActive'] as IconData : item['icon'] as IconData,
                                size: 20,
                                color: isActive ? const Color(0xFFDC2626) : const Color(0xFF666666),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['label'],
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  color: isActive ? const Color(0xFFDC2626) : const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required Color color,
    required int count,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
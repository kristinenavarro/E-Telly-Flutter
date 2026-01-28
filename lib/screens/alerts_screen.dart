import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final String barangay;
  final String timestamp;
  final String severity;
  final bool active;
  final bool read;
  final String? waterLevel;
  final String? evacuationCenter;

  AlertItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.barangay,
    required this.timestamp,
    required this.severity,
    required this.active,
    required this.read,
    this.waterLevel,
    this.evacuationCenter,
  });

  AlertItem copyWith({
    bool? read,
    bool? active,
  }) {
    return AlertItem(
      id: id,
      type: type,
      title: title,
      message: message,
      barangay: barangay,
      timestamp: timestamp,
      severity: severity,
      active: active ?? this.active,
      read: read ?? this.read,
      waterLevel: waterLevel,
      evacuationCenter: evacuationCenter,
    );
  }
}

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _activeScreen = 'alerts';
  
  List<AlertItem> _alerts = [
    AlertItem(
      id: '1',
      type: 'flood',
      title: 'CRITICAL: COASTAL FLOODING',
      message: 'High tide + heavy rain causing severe flooding in coastal areas. Water level at 1.8 meters.',
      barangay: 'Tanza 1, Tanza 2, Bangkulasi',
      timestamp: '10:45 AM',
      severity: 'critical',
      active: true,
      read: false,
      waterLevel: '1.8m',
      evacuationCenter: 'Navotas City Hall Evacuation Center',
    ),
    AlertItem(
      id: '2',
      type: 'evacuate',
      title: 'EVACUATION ORDER - IMMEDIATE',
      message: 'Mandatory evacuation for riverside communities. Navotas River overflowing.',
      barangay: 'Daanghari, North Bay Boulevard South',
      timestamp: '10:30 AM',
      severity: 'critical',
      active: true,
      read: false,
      waterLevel: '2.1m',
      evacuationCenter: 'Navotas National High School',
    ),
    AlertItem(
      id: '3',
      type: 'rain',
      title: 'INTENSE RAINFALL WARNING',
      message: 'Heavy to intense rainfall (15-30mm/hr) expected for next 3 hours. Prepare for possible flooding.',
      barangay: 'All Navotas Barangays',
      timestamp: '10:15 AM',
      severity: 'high',
      active: true,
      read: true,
      waterLevel: 'Rising',
    ),
    AlertItem(
      id: '4',
      type: 'flood',
      title: 'URBAN FLOODING ALERT',
      message: 'Drainage systems overwhelmed. Major roads impassable due to knee-deep flooding.',
      barangay: 'San Roque, Tangos, Navotas West',
      timestamp: '9:45 AM',
      severity: 'high',
      active: true,
      read: true,
      waterLevel: '0.8m',
      evacuationCenter: 'Tangos Elementary School',
    ),
    AlertItem(
      id: '5',
      type: 'water_level',
      title: 'NAVOTAS RIVER WARNING',
      message: 'River water level approaching critical mark at 2.3 meters. Monitor closely.',
      barangay: 'Riverside Communities',
      timestamp: 'Yesterday',
      severity: 'moderate',
      active: true,
      read: true,
      waterLevel: '2.3m',
    ),
  ];

  final List<Map<String, dynamic>> _bottomNavItems = [
    {'id': 'home', 'label': 'Home', 'icon': Icons.home_outlined, 'iconActive': Icons.home},
    {'id': 'safety', 'label': 'Safety Tips', 'icon': Icons.security_outlined, 'iconActive': Icons.security},
    {'id': 'evac', 'label': 'Evac Nav', 'icon': Icons.map_outlined, 'iconActive': Icons.map},
    {'id': 'resources', 'label': 'Resources', 'icon': Icons.inventory_2_outlined, 'iconActive': Icons.inventory_2},
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person_outline, 'iconActive': Icons.person},
  ];

  int get _unreadAlerts {
    return _alerts.where((alert) => alert.active && !alert.read).length;
  }

  List<AlertItem> get _activeAlerts {
    return _alerts.where((alert) => alert.active).toList();
  }

  List<AlertItem> get _criticalAlerts {
    return _alerts.where((alert) => alert.severity == 'critical' && alert.active).toList();
  }

  Color _getAlertColor(String type) {
    switch (type) {
      case 'flood':
        return const Color(0xFF06B6D4);
      case 'rain':
        return const Color(0xFF3B82F6);
      case 'evacuate':
        return const Color(0xFFDC2626);
      case 'water_level':
        return const Color(0xFF8B5CF6);
      case 'typhoon':
        return const Color(0xFFF59E0B);
      case 'earthquake':
        return const Color(0xFFF59E0B);
      case 'fire':
        return const Color(0xFFDC2626);
      case 'medical':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF666666);
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'flood':
        return Icons.water_damage;
      case 'rain':
        return Icons.grain;
      case 'evacuate':
        return Icons.warning;
      case 'water_level':
        return Icons.trending_up;
      case 'typhoon':
        return Icons.cloud;
      case 'earthquake':
        return Icons.landscape;
      case 'fire':
        return Icons.local_fire_department;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.warning;
    }
  }

  String _getAlertTypeText(String type) {
    switch (type) {
      case 'flood':
        return 'Flood Warning';
      case 'rain':
        return 'Rainfall Alert';
      case 'evacuate':
        return 'Evacuation Order';
      case 'water_level':
        return 'Water Level Alert';
      case 'typhoon':
        return 'Typhoon Alert';
      case 'earthquake':
        return 'Earthquake Alert';
      case 'fire':
        return 'Fire Hazard';
      case 'medical':
        return 'Health Advisory';
      default:
        return 'Alert';
    }
  }

  void _handleBottomNavPress(String id) {
    setState(() {
      _activeScreen = id;
    });
    
    // Navigate to the appropriate screen
    switch (id) {
      case 'home':
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 'safety':
        Navigator.of(context).pushNamed('/safety-tips');
        break;
      case 'evac':
        Navigator.of(context).pushNamed('/evacuation-map');
        break;
      case 'resources':
        Navigator.of(context).pushNamed('/resources');
        break;
      case 'profile':
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  void _handleAlertPress(AlertItem alert) {
    setState(() {
      _alerts = _alerts.map((a) => 
        a.id == alert.id ? a.copyWith(read: true) : a
      ).toList();
    });

    final details = [
      '📍 Location: ${alert.barangay}',
      '⏰ Time: ${alert.timestamp}',
      if (alert.waterLevel != null) '🌊 Water Level: ${alert.waterLevel}',
      if (alert.evacuationCenter != null) '🏫 Evacuation Center: ${alert.evacuationCenter}',
      '',
      if (alert.type == 'evacuate') '🚨 EVACUATE IMMEDIATELY if in affected area!',
      if (alert.type == 'flood') '⚠️ Avoid floodwaters - may contain contaminants!',
      if (alert.type == 'rain') '☔ Prepare emergency kits and stay indoors!',
      if (alert.type == 'typhoon') '🌀 Secure loose objects and prepare for strong winds!',
      if (alert.type == 'earthquake') '🌍 Drop, Cover, and Hold On during shaking!',
      if (alert.type == 'fire') '🔥 Check electrical systems and avoid open flames!',
      if (alert.type == 'medical') '🏥 Boil water and maintain hygiene!',
    ].where((item) => item.isNotEmpty).join('\n');

    final actions = <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('OK'),
      ),
    ];

    if (alert.evacuationCenter != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed('/evacuation-map');
          },
          child: const Text('View Evacuation Map'),
        ),
      );
    }

    if (alert.type == 'medical') {
      actions.add(
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            const url = 'tel:155';
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          child: const Text('Call Health Hotline'),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: SingleChildScrollView(
          child: Text('${alert.message}\n\n$details'),
        ),
        actions: actions,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _handleReportEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Emergency'),
        content: const Text('What would you like to report?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reported'),
                  content: const Text('Flooding reported to Navotas DRRMO (288-4567)'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
            child: const Text('🚨 Flooding in Area'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reported'),
                  content: const Text('Water level rise reported to monitoring team'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
            child: const Text('💧 Rising Water Level'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:911';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('🏠 Need Evacuation Help'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:117';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('⚠️ Trapped/Stranded'),
          ),
        ],
      ),
    );
  }

  void _handleEmergencyCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navotas Emergency Services'),
        content: const Text('Select emergency service to call:'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:911';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('🚨 EMERGENCY RESCUE (911)'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:117';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('🔥 FIRE & RESCUE (117)'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:02884567';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('🏥 NAVOTAS HOSPITAL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:02883111';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('🌊 NAVOTAS DRRMO'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              const url = 'tel:02883222';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const Text('👮 NAVOTAS POLICE'),
          ),
        ],
      ),
    );
  }

  void _handleMarkAllRead() {
    if (_unreadAlerts == 0) return;
    
    setState(() {
      _alerts = _alerts.map((alert) => alert.copyWith(read: true)).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All alerts marked as read'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () {
                        // FIXED: Navigate to Home screen
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      color: const Color(0xFFDC2626),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Alerts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Navotas Disaster Response',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.report_outlined, size: 20),
                          onPressed: _handleReportEmergency,
                          color: const Color(0xFFDC2626),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      if (_unreadAlerts > 0)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626),
                              shape: BoxShape.circle,
                              border: Border(
                                top: BorderSide(color: Colors.white, width: 1.5),
                                bottom: BorderSide(color: Colors.white, width: 1.5),
                                left: BorderSide(color: Colors.white, width: 1.5),
                                right: BorderSide(color: Colors.white, width: 1.5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _unreadAlerts.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Emergency Stats
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                children: [
                  _buildStatCard(
                    count: _criticalAlerts.length,
                    label: 'CRITICAL',
                    color: const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    count: _activeAlerts.length,
                    label: 'ACTIVE ALERTS',
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    count: _unreadAlerts,
                    label: 'UNREAD',
                    color: const Color(0xFF3B82F6),
                  ),
                ],
              ),
            ),

            // Alerts List
            Expanded(
              child: Column(
                children: [
                  // Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Alerts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        TextButton(
                          onPressed: _unreadAlerts == 0 ? null : _handleMarkAllRead,
                          child: Text(
                            'Mark All Read',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _unreadAlerts == 0
                                  ? const Color(0xFF666666)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Alerts List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _activeAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = _activeAlerts[index];
                        final alertColor = _getAlertColor(alert.type);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _handleAlertPress(alert),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Icon
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: alertColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        _getAlertIcon(alert.type),
                                        size: 20,
                                        color: alertColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _getAlertTypeText(alert.type),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: alertColor,
                                                ),
                                              ),
                                              Text(
                                                alert.timestamp,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF666666),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            alert.title,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            alert.message,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF666666),
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 12,
                                                    color: Color(0xFF666666),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    alert.barangay,
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
                                        ],
                                      ),
                                    ),
                                    
                                    // Unread indicator
                                    if (!alert.read)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: alertColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Emergency Button
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDC2626),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleEmergencyCall,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.call,
                          size: 20,
                          color: Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'EMERGENCY CALL',
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                  final isActive = _activeScreen == item['id'];
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

  Widget _buildStatCard({
    required int count,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety Tips',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFFDC2626)),
        ),
      ),
      home: SafetyTipsScreen(),
    );
  }
}

class SafetyTip {
  final String id;
  final String category;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int steps;
  final String riskLevel;
  final List<String>? detailedSteps;
  final String? emergencyNumber;

  SafetyTip({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.steps,
    required this.riskLevel,
    this.detailedSteps,
    this.emergencyNumber,
  });
}

class SafetyTipsScreen extends StatefulWidget {
  @override
  _SafetyTipsScreenState createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  String _activeTab = 'safety';
  SafetyTip? _selectedTip;
  bool _showDetailModal = false;

  final List<SafetyTip> safetyTips = [
    SafetyTip(
      id: '1',
      category: 'First Aid',
      title: 'Basic first aid for common emergencies',
      description: 'Essential medical response procedures',
      icon: Icons.medical_services,
      color: Color(0xFFDC2626),
      steps: 10,
      riskLevel: 'High Risk',
      emergencyNumber: '911',
      detailedSteps: [
        'Check the scene for safety',
        'Call emergency services immediately',
        'Check if the person is responsive',
        'Perform CPR if trained and needed',
        'Control bleeding with direct pressure',
        'Treat for shock by keeping person warm',
        'Do not move injured person unless necessary',
        'Check for medical alert tags',
        'Stay with person until help arrives',
        'Follow dispatcher instructions carefully',
      ],
    ),
    SafetyTip(
      id: '2',
      category: 'Typhoon',
      title: 'Typhoon Preparedness',
      description: 'Complete guide for typhoon season',
      icon: Icons.cloud,
      color: Color(0xFF3B82F6),
      steps: 10,
      riskLevel: 'High Risk',
      emergencyNumber: '911',
      detailedSteps: [
        'Secure all windows and doors',
        'Trim trees and remove loose objects',
        'Stock 3-day supply of food and water',
        'Charge all electronic devices',
        'Prepare emergency lighting sources',
        'Stay indoors during the storm',
        'Stay away from windows',
        'Monitor official weather updates',
        'Evacuate if in flood-prone area',
        'Check on neighbors after storm passes',
      ],
    ),
    SafetyTip(
      id: '3',
      category: 'Earthquake',
      title: 'Earthquake Safety',
      description: 'Drop, Cover, and Hold On procedures',
      icon: Icons.warning,
      color: Color(0xFFF59E0B),
      steps: 10,
      riskLevel: 'High Risk',
      emergencyNumber: '911',
      detailedSteps: [
        'DROP to your hands and knees',
        'COVER your head and neck',
        'HOLD ON to sturdy furniture',
        'Stay away from windows and glass',
        'If outside, move to open area',
        'If driving, pull over and stay in car',
        'Stay indoors until shaking stops',
        'Check for injuries after shaking stops',
        'Expect aftershocks',
        'Listen to emergency broadcasts',
      ],
    ),
    SafetyTip(
      id: '4',
      category: 'Fire',
      title: 'Fire Emergency Guide',
      description: 'Prevention and response to fire hazards',
      icon: Icons.local_fire_department,
      color: Color(0xFFDC2626),
      steps: 8,
      riskLevel: 'High Risk',
      emergencyNumber: '8-281-0854',
      detailedSteps: [
        'Install smoke detectors on every level',
        'Test smoke detectors monthly',
        'Create and practice fire escape plan',
        'Keep fire extinguishers accessible',
        'Stop, drop, and roll if clothes catch fire',
        'Crawl low under smoke',
        'Check doors for heat before opening',
        'Meet at designated outside location',
      ],
    ),
    SafetyTip(
      id: '5',
      category: 'Flood',
      title: 'Flood Safety Guide',
      description: 'Essential steps before, during, and after floods',
      icon: Icons.water_damage,
      color: Color(0xFF06B6D4),
      steps: 10,
      riskLevel: 'High Risk',
      emergencyNumber: '911',
      detailedSteps: [
        'Monitor weather updates and flood warnings',
        'Prepare emergency kit with food, water, and medications',
        'Move valuables to higher floors',
        'Turn off electricity at main switch',
        'Evacuate immediately if instructed',
        'Avoid walking or driving through floodwaters',
        'Stay away from downed power lines',
        'Listen to local news for updates',
        'Return only when authorities say it\'s safe',
        'Document damage for insurance claims',
      ],
    ),
    SafetyTip(
      id: '6',
      category: 'Evacuation',
      title: 'Evacuation Procedures',
      description: 'Safe evacuation routes and procedures',
      icon: Icons.directions_walk,
      color: Color(0xFF10B981),
      steps: 7,
      riskLevel: 'Medium Risk',
      emergencyNumber: '8-281-1111',
      detailedSteps: [
        'Know your evacuation zone',
        'Plan multiple evacuation routes',
        'Prepare "go-bag" with essentials',
        'Follow official evacuation orders',
        'Take pets and medications',
        'Inform family of destination',
        'Use only designated evacuation routes',
      ],
    ),
    SafetyTip(
      id: '7',
      category: 'Heat',
      title: 'Heatwave Safety',
      description: 'Protection during extreme heat conditions',
      icon: Icons.thermostat,
      color: Color(0xFFDC2626),
      steps: 6,
      riskLevel: 'Medium Risk',
      emergencyNumber: '911',
      detailedSteps: [
        'Stay hydrated with water',
        'Avoid outdoor activities during peak heat',
        'Wear lightweight, light-colored clothing',
        'Stay in air-conditioned places',
        'Check on elderly and vulnerable neighbors',
        'Know signs of heat exhaustion',
      ],
    ),
    SafetyTip(
      id: '8',
      category: 'Electrical',
      title: 'Electrical Safety',
      description: 'Preventing electrical hazards',
      icon: Icons.flash_on,
      color: Color(0xFFF59E0B),
      steps: 8,
      riskLevel: 'High Risk',
      emergencyNumber: '911',
      detailedSteps: [
        'Keep electrical appliances away from water',
        'Do not overload outlets',
        'Use surge protectors',
        'Check cords for damage',
        'Turn off main breaker during floods',
        'Do not touch electrical equipment if wet',
        'Have electrical system inspected',
        'Know location of main electrical panel',
      ],
    ),
  ];

  final List<Map<String, dynamic>> bottomNavItems = [
    {'id': 'home', 'label': 'Home', 'icon': Icons.home_outlined, 'iconActive': Icons.home},
    {'id': 'safety', 'label': 'Safety Tips', 'icon': Icons.security_outlined, 'iconActive': Icons.security},
    {'id': 'evac', 'label': 'Evac Nav', 'icon': Icons.map_outlined, 'iconActive': Icons.map},
    {'id': 'resources', 'label': 'Resources', 'icon': Icons.widgets_outlined, 'iconActive': Icons.widgets},
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person_outline, 'iconActive': Icons.person},
  ];

  Color getRiskLevelColor(String riskLevel) {
    switch (riskLevel) {
      case 'High Risk':
        return Color(0xFFDC2626);
      case 'Medium Risk':
        return Color(0xFFF59E0B);
      case 'Low Risk':
        return Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  void _handleSafetyTipPress(SafetyTip tip) {
    setState(() {
      _selectedTip = tip;
      _showDetailModal = true;
    });
  }

  void _handleEmergencyCall(String number) async {
    final cleanNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    final url = 'tel:$cleanNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Unable to make call'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _handleBottomNavPress(String id) {
    setState(() {
      _activeTab = id;
    });
    
    // Navigation logic
    switch (id) {
      case 'home':
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 'evac':
        // Navigate to evacuation map screen
        Navigator.pushReplacementNamed(context, '/evacuation-map');
        break;
      case 'resources':
        // Navigate to resources screen
        Navigator.pushReplacementNamed(context, '/resources');
        break;
      case 'profile':
        // Navigate to profile screen
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 'safety':
        // Already on safety tips screen
        break;
      default:
        print('Unknown navigation: $id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFFDC2626).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(Icons.arrow_back, size: 20, color: Color(0xFFDC2626)),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Safety Tips & Guides',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(0xFFDC2626).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(Icons.search, size: 18, color: Color(0xFFDC2626)),
                      ),
                    ],
                  ),
                ),

                // Safety Tips List
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ALL SAFETY TIPS (${safetyTips.length})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        SizedBox(height: 16),
                        ...safetyTips.map((tip) => _buildSafetyTipCard(tip)).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
              ),
              child: Row(
                children: bottomNavItems.map((item) => _buildBottomNavItem(item)).toList(),
              ),
            ),
          ),

          // Detail Modal
          if (_showDetailModal && _selectedTip != null)
            _buildDetailModal(),
        ],
      ),
    );
  }

  Widget _buildSafetyTipCard(SafetyTip tip) {
    return GestureDetector(
      onTap: () => _handleSafetyTipPress(tip),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: tip.color, width: 3),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tip.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(tip.icon, size: 20, color: tip.color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: tip.color,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        tip.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        tip.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.list_outlined, size: 14, color: tip.color),
                          SizedBox(width: 4),
                          Text(
                            '${tip.steps} steps',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: getRiskLevelColor(tip.riskLevel).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tip.riskLevel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: getRiskLevelColor(tip.riskLevel),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.chevron_right, size: 18, color: tip.color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(Map<String, dynamic> item) {
    bool isActive = _activeTab == item['id'];
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleBottomNavPress(item['id']),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFFDC2626).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? item['iconActive'] : item['icon'],
                size: 20,
                color: isActive ? Color(0xFFDC2626) : Color(0xFF666666),
              ),
              SizedBox(height: 2),
              Text(
                item['label'],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Color(0xFFDC2626) : Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailModal() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Modal Header
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 24),
                    decoration: BoxDecoration(
                      color: _selectedTip!.color,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 12,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => setState(() => _showDetailModal = false),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(Icons.close, size: 24, color: Colors.white),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(_selectedTip!.icon, size: 32, color: Colors.white),
                            ),
                            SizedBox(height: 12),
                            Text(
                              _selectedTip!.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _selectedTip!.category,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: getRiskLevelColor(_selectedTip!.riskLevel),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _selectedTip!.riskLevel,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Modal Body
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          Text(
                            _selectedTip!.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Steps Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.list_outlined, size: 20, color: _selectedTip!.color),
                                  SizedBox(width: 8),
                                  Text(
                                    'STEP-BY-STEP GUIDE',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTip!.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Divider(height: 1, color: Color(0xFFE5E7EB)),
                              SizedBox(height: 12),
                              ..._selectedTip!.detailedSteps!.asMap().entries.map((entry) {
                                int index = entry.key;
                                String step = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: _selectedTip!.color,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            step,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF1F2937),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),

                          // Emergency Contact
                          if (_selectedTip!.emergencyNumber != null) ...[
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.warning, size: 20, color: _selectedTip!.color),
                                    SizedBox(width: 8),
                                    Text(
                                      'EMERGENCY CONTACT',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _selectedTip!.color,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Divider(height: 1, color: Color(0xFFE5E7EB)),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () => _handleEmergencyCall(_selectedTip!.emergencyNumber!),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _selectedTip!.color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Icon(Icons.call, size: 24, color: Colors.white),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _selectedTip!.emergencyNumber!,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'Tap to call emergency services',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white.withOpacity(0.8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.chevron_right, size: 20, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
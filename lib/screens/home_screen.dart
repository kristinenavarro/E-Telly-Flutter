import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNotificationPressed;
  final ValueChanged<String>? onTabSelected;

  const HomeScreen({
    Key? key,
    this.onNotificationPressed,
    this.onTabSelected,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeTab = 'home';

  // Emergency Features Data
  final List<EmergencyFeature> _emergencyFeatures = [
    EmergencyFeature(
      id: 'alerts',
      title: 'Alerts',
      icon: Icons.notifications,
      color: const Color(0xFFDC2626),
    ),
    EmergencyFeature(
      id: 'evac-map',
      title: 'Evacuation Map',
      icon: Icons.map,
      color: const Color(0xFF10B981),
    ),
    EmergencyFeature(
      id: 'flood-monitor',
      title: 'Flood Monitor',
      icon: Icons.water_damage,
      color: const Color(0xFF3B82F6),
    ),
    EmergencyFeature(
      id: 'resources',
      title: 'Resources',
      icon: Icons.inventory,
      color: const Color(0xFF8B5CF6),
    ),
  ];

  // Quick Actions Data
  final List<QuickAction> _quickActions = [
    QuickAction(
      id: 'report-emergency',
      title: 'Report Emergency',
      icon: Icons.warning,
      color: const Color(0xFFDC2626),
    ),
    QuickAction(
      id: 'safety-tips',
      title: 'Safety Tips',
      icon: Icons.info,
      color: const Color(0xFF3B82F6),
    ),
  ];

  // Emergency Contacts Data
  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      id: 'ndrrmc',
      title: 'NDRRMC',
      number: '911',
      subtitle: 'National Disaster Risk Reduction',
      icon: Icons.call,
      color: const Color(0xFF26DC32),
      type: 'hotline',
    ),
    EmergencyContact(
      id: 'redcross',
      title: 'Red Cross',
      number: '143',
      subtitle: 'Philippine Red Cross',
      icon: Icons.medical_services,
      color: const Color(0xFFDC2626),
      type: 'hotline',
    ),
    EmergencyContact(
      id: 'navotas_drrrmo',
      title: 'Navotas DRRMO',
      number: '8-281-1111',
      subtitle: 'Emergency Hotline',
      icon: Icons.warning,
      color: const Color(0xFFF59E0B),
      type: 'hotline',
    ),
    EmergencyContact(
      id: 'navotas_bfp',
      title: 'BFP - Navotas',
      number: '8-281-0854',
      subtitle: 'Bureau of Fire Protection',
      icon: Icons.local_fire_department,
      color: const Color(0xFFDC2626),
      type: 'fire',
    ),
    EmergencyContact(
      id: 'navotas_pnp',
      title: 'PNP - Navotas',
      number: '0998 598 7866',
      subtitle: 'Philippine National Police',
      icon: Icons.shield,
      color: const Color(0xFF3B82F6),
      type: 'police',
    ),
    EmergencyContact(
      id: 'navotas_city_hall',
      title: 'Navotas City Hall',
      number: '8-283-7415',
      subtitle: 'City Government Office',
      icon: Icons.business,
      color: const Color(0xFF10B981),
      type: 'hotline',
    ),
  ];

  final List<EmergencyContact> _jrtContacts = [
    EmergencyContact(
      id: 'jrt_globe',
      title: 'Globe',
      number: '0917 521 8578',
      subtitle: 'JRT Text Emergency',
      icon: Icons.chat,
      color: const Color(0xFF3B82F6),
      type: 'text',
    ),
    EmergencyContact(
      id: 'jrt_smart',
      title: 'Smart',
      number: '0908 886 8578',
      subtitle: 'JRT Text Emergency',
      icon: Icons.chat,
      color: const Color(0xFFF59E0B),
      type: 'text',
    ),
  ];

  // GINAYA KO DITO YUNG NAV BAR NG SAFETYSCREEN
  final List<Map<String, dynamic>> bottomNavItems = [
    {'id': 'home', 'label': 'Home', 'icon': Icons.home_outlined, 'iconActive': Icons.home},
    {'id': 'safety', 'label': 'Safety Tips', 'icon': Icons.security_outlined, 'iconActive': Icons.security},
    {'id': 'evac', 'label': 'Evac Map', 'icon': Icons.map_outlined, 'iconActive': Icons.map},
    {'id': 'resources', 'label': 'Resources', 'icon': Icons.widgets_outlined, 'iconActive': Icons.widgets},
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person_outline, 'iconActive': Icons.person},
  ];

  // Navigation methods - SAME PARIN
  void _navigateToScreen(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _handleFeatureTap(String id) {
    switch (id) {
      case 'alerts':
        _navigateToScreen('/alerts');
        break;
      case 'evac-map':
        _navigateToScreen('/evacuation-map');
        break;
      case 'flood-monitor':
        _navigateToScreen('/flood-monitor');
        break;
      case 'resources':
        _navigateToScreen('/resources');
        break;
      case 'report-emergency':
        _navigateToScreen('/report-emergency');
        break;
      case 'safety-tips':
        _navigateToScreen('/safety-tips');
        break;
    }
  }

  void _handleBottomNavPress(String id) {
    setState(() {
      _activeTab = id;
    });
    
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(id);
    }
    
    switch (id) {
      case 'safety':
        _navigateToScreen('/safety-tips');
        break;
      case 'evac':
        _navigateToScreen('/evacuation-map');
        break;
      case 'resources':
        _navigateToScreen('/resources');
        break;
      case 'profile':
        _navigateToScreen('/profile');
        break;
      case 'home':
        break;
    }
  }

  void _handleEmergencyCall(String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Emergency'),
        content: Text('Would call: $number\n\n(Requires url_launcher package)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSendSMS(String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send SMS'),
        content: Text('Would send SMS to: $number\n\n(Requires url_launcher package)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showJRTModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('JRT Text Emergency Numbers'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Globe: 0917 521 8578'),
            Text('Smart: 0908 886 8578'),
            Text('Sun: 0922 888 8578'),
            Text('Sun: 0933 810 0221'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Copied'),
                  content: Text('All JRT numbers copied to clipboard'),
                  actions: [
                    TextButton(
                      onPressed: null,
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Copy All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleEmergencyCallButton() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navotas Emergency Services'),
        content: const Text('Select emergency service to call:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleEmergencyCall('911');
            },
            child: const Text('🚨 EMERGENCY RESCUE (911)'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleEmergencyCall('117');
            },
            child: const Text('🔥 FIRE & RESCUE (117)'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleEmergencyCall('8-281-1111');
            },
            child: const Text('🏥 NAVOTAS HOSPITAL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleEmergencyCall('8-281-1111');
            },
            child: const Text('🌊 NAVOTAS DRRMO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleEmergencyCall('0998 598 7866');
            },
            child: const Text('👮 NAVOTAS POLICE'),
          ),
        ],
      ),
    );
  }

  // Widget builders - SAME PARIN
  Widget _buildEmergencyFeature(EmergencyFeature feature) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: feature.color, width: 3),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleFeatureTap(feature.id),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: feature.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(feature.icon, size: 20, color: feature.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: feature.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(QuickAction action) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: action.color, width: 3),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleFeatureTap(action.id),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(action.icon, size: 20, color: action.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: action.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(EmergencyContact contact) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: contact.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(contact.icon, size: 16, color: contact.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  contact.subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                contact.number,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: contact.color,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: contact.type == 'text'
                    ? () => _handleSendSMS(contact.number)
                    : () => _handleEmergencyCall(contact.number),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: contact.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    contact.type == 'text' ? Icons.chat : Icons.call,
                    size: 14,
                    color: contact.color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ITO YUNG NAV BAR NA GINAYA SA SAFETYSCREEN
  Widget _buildBottomNavItem(Map<String, dynamic> item) {
    bool isActive = _activeTab == item['id'];
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleBottomNavPress(item['id']),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFDC2626).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? item['iconActive'] : item['icon'],
                size: 20,
                color: isActive ? const Color(0xFFDC2626) : const Color(0xFF666666),
              ),
              const SizedBox(height: 2),
              Text(
                item['label'],
                style: TextStyle(
                  fontSize: 9, // SAME FONT SIZE
                  fontWeight: FontWeight.w500,
                  color: isActive ? const Color(0xFFDC2626) : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header - SAME PARIN
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 20,
              right: 20,
              bottom: 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome To E-Telly!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Disaster Preparedness Dashboard',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onNotificationPressed,
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content - FIXED SPACING
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emergency Features Section - FIXED ALIGNMENT
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 8),
                    child: Text(
                      'EMERGENCY FEATURES',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3,
                    ),
                    itemCount: _emergencyFeatures.length,
                    itemBuilder: (context, index) {
                      return _buildEmergencyFeature(_emergencyFeatures[index]);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Quick Actions Section - FIXED ALIGNMENT
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3,
                    ),
                    itemCount: _quickActions.length,
                    itemBuilder: (context, index) {
                      return _buildQuickAction(_quickActions[index]);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Emergency Contacts Section - UNCHANGED
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'EMERGENCY CONTACTS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'National Emergency',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: _emergencyContacts
                          .sublist(0, 2)
                          .map((contact) => _buildContactItem(contact))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'Navotas City Emergency',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: _emergencyContacts
                          .sublist(2)
                          .map((contact) => _buildContactItem(contact))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _showJRTModal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'JRT Text Emergency',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.info, size: 16, color: Color(0xFF666666)),
                            ],
                          ),
                          const Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right, size: 16, color: Color(0xFF666666)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: _jrtContacts
                          .map((contact) => _buildContactItem(contact))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Tap "View All" to see all JRT numbers for different networks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF666666),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _handleEmergencyCallButton,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.emergency, size: 24),
                      label: const Text(
                        'EMERGENCY CALL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // BAGONG NAV BAR - SAME NA NGAYON SA SAFETYSCREEN
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
            ),
            child: Row(
              children: bottomNavItems.map((item) => _buildBottomNavItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Data models - SAME PARIN
class EmergencyFeature {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  EmergencyFeature({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class QuickAction {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  QuickAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class EmergencyContact {
  final String id;
  final String title;   
  final String number;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String type;

  EmergencyContact({
    required this.id,
    required this.title,
    required this.number,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.type,
  });
}
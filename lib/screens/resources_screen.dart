import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final ValueChanged<String>? onTabSelected;

  const ResourcesScreen({
    Key? key,
    this.onBackPressed,
    this.onTabSelected,
  }) : super(key: key);

  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _activeScreen = 'resources';
  String _activeTab = 'donate';
  String? _selectedResource;
  String _quantity = '1';
  bool _urgent = false;
  String _notes = '';
  bool _showModal = false;

  final List<MyRequest> _myRequests = [];
  final ScrollController _scrollController = ScrollController();

  // Bottom Navigation Items - SAME AS HOMESCREEN
  final List<Map<String, dynamic>> bottomNavItems = [
    {
      'id': 'home',
      'label': 'Home',
      'icon': Icons.home_outlined,
      'iconActive': Icons.home
    },
    {
      'id': 'safety',
      'label': 'Safety Tips',
      'icon': Icons.security_outlined,
      'iconActive': Icons.security
    },
    {
      'id': 'evac',
      'label': 'Evac Map',
      'icon': Icons.map_outlined,
      'iconActive': Icons.map
    },
    {
      'id': 'resources',
      'label': 'Resources',
      'icon': Icons.inventory_outlined,
      'iconActive': Icons.inventory
    },
    {
      'id': 'profile',
      'label': 'Profile',
      'icon': Icons.person_outline,
      'iconActive': Icons.person
    },
  ];

  // Navigation methods - SAME AS HOMESCREEN
  void _navigateToScreen(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _handleBottomNavPress(String id) {
    setState(() {
      _activeScreen = id;
    });

    if (widget.onTabSelected != null) {
      widget.onTabSelected!(id);
    }

    switch (id) {
      case 'home':
        // FIXED: Navigate to home screen instead of welcome screen
        // Change '/home' to your actual home screen route name
        _navigateToScreen('/home');
        break;
      case 'safety':
        _navigateToScreen('/safety-tips');
        break;
      case 'evac':
        _navigateToScreen('/evacuation-map');
        break;
      case 'profile':
        _navigateToScreen('/profile');
        break;
      case 'resources':
        // Already on resources screen
        break;
    }
  }

  // Bottom Nav Widget - SAME AS HOMESCREEN
  Widget _buildBottomNavItem(Map<String, dynamic> item) {
    bool isActive = _activeScreen == item['id'];
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleBottomNavPress(item['id']),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFDC2626).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? item['iconActive'] : item['icon'],
                size: 20,
                color: isActive
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF666666),
              ),
              const SizedBox(height: 2),
              Text(
                item['label'],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Donatable Items
  final List<ResourceItem> _donatableItems = [
    ResourceItem(
      id: 'd1',
      name: 'Clothes',
      category: 'clothes',
      description: 'Clean and wearable clothes for all ages',
      icon: Icons.checkroom,
      available: true,
      unit: 'piece',
    ),
    ResourceItem(
      id: 'd2',
      name: 'Canned Goods',
      category: 'food',
      description: 'Non-perishable canned foods',
      icon: Icons.restaurant,
      available: true,
      unit: 'can',
    ),
    ResourceItem(
      id: 'd3',
      name: 'Bottled Water',
      category: 'water',
      description: 'Sealed bottled water',
      icon: Icons.water_drop,
      available: true,
      unit: 'bottle',
    ),
    ResourceItem(
      id: 'd4',
      name: 'Blankets',
      category: 'clothes',
      description: 'Clean blankets for warmth',
      icon: Icons.bed,
      available: true,
      unit: 'blanket',
    ),
    ResourceItem(
      id: 'd5',
      name: 'First Aid Supplies',
      category: 'kit',
      description: 'Bandages, antiseptics, basic medicines',
      icon: Icons.medical_services,
      available: true,
      unit: 'item',
    ),
    ResourceItem(
      id: 'd6',
      name: 'Hygiene Kits',
      category: 'other',
      description: 'Soap, toothpaste, sanitary products',
      icon: Icons.clean_hands,
      available: true,
      unit: 'kit',
    ),
    ResourceItem(
      id: 'd7',
      name: 'Infant Supplies',
      category: 'other',
      description: 'Baby formula, diapers, baby clothes',
      icon: Icons.child_care,
      available: true,
      unit: 'item',
    ),
    ResourceItem(
      id: 'd8',
      name: 'Cooked Food',
      category: 'food',
      description: 'Prepared meals (properly packed)',
      icon: Icons.restaurant_menu,
      available: true,
      unit: 'meal',
    ),
    ResourceItem(
      id: 'd9',
      name: 'Flashlights',
      category: 'kit',
      description: 'Working flashlights with batteries',
      icon: Icons.flashlight_on,
      available: true,
      unit: 'piece',
    ),
    ResourceItem(
      id: 'd10',
      name: 'Emergency Tools',
      category: 'kit',
      description: 'Whistles, multi-tools, rope',
      icon: Icons.build,
      available: true,
      unit: 'tool',
    ),
  ];

  // Requestable Items
  final List<ResourceItem> _requestableItems = [
    ResourceItem(
      id: '1',
      name: 'Drinking Water',
      category: 'water',
      description: '5-gallon purified water containers with essential minerals',
      icon: Icons.water_damage,
      available: true,
      estimatedDelivery: 'Within 1-2 hours',
      unit: 'container',
    ),
    ResourceItem(
      id: '2',
      name: 'Canned Goods Pack',
      category: 'food',
      description: 'Assorted canned goods (sardines, corned beef, beans)',
      icon: Icons.restaurant,
      available: true,
      estimatedDelivery: 'Within 1-2 hours',
      unit: 'pack',
    ),
    ResourceItem(
      id: '3',
      name: 'Emergency Clothes Set',
      category: 'clothes',
      description:
          'Complete set of emergency clothing (shirt, pants, underwear)',
      icon: Icons.checkroom,
      available: true,
      estimatedDelivery: 'Within 2-3 hours',
      unit: 'set',
    ),
    ResourceItem(
      id: '4',
      name: 'Basic Emergency Kit',
      category: 'kit',
      description: 'First aid, flashlight, whistle, thermal blanket, batteries',
      icon: Icons.medical_services,
      available: true,
      estimatedDelivery: 'Within 1-2 hours',
      unit: 'kit',
    ),
    ResourceItem(
      id: '5',
      name: 'Clean Water Pack',
      category: 'water',
      description: 'Pack of 12 bottled water (500ml each)',
      icon: Icons.water_drop,
      available: true,
      estimatedDelivery: 'Within 2-3 hours',
      unit: 'pack',
    ),
    ResourceItem(
      id: '6',
      name: 'Ready-to-Eat Meals',
      category: 'food',
      description: '24-hour food pack (instant noodles, biscuits, coffee)',
      icon: Icons.restaurant_menu,
      available: true,
      estimatedDelivery: 'Within 1-2 hours',
      unit: 'pack',
    ),
    ResourceItem(
      id: '7',
      name: 'Warm Blankets',
      category: 'clothes',
      description: 'Thermal emergency blankets for cold weather',
      icon: Icons.bed,
      available: true,
      estimatedDelivery: 'Within 1-2 hours',
      unit: 'blanket',
    ),
    ResourceItem(
      id: '8',
      name: 'Advanced First Aid Kit',
      category: 'kit',
      description:
          'Complete medical supplies including bandages, antiseptics, medicines',
      icon: Icons.medical_information,
      available: true,
      estimatedDelivery: 'Within 2-3 hours',
      unit: 'kit',
    ),
    ResourceItem(
      id: '9',
      name: 'Infant Survival Kit',
      category: 'kit',
      description: 'Baby formula, diapers, clothes, and essential supplies',
      icon: Icons.child_care,
      available: true,
      estimatedDelivery: 'Within 2-3 hours',
      unit: 'kit',
    ),
    ResourceItem(
      id: '10',
      name: 'Hygiene Kit',
      category: 'other',
      description: 'Soap, toothpaste, sanitary pads, toilet paper',
      icon: Icons.clean_hands,
      available: true,
      estimatedDelivery: 'Within 2-3 hours',
      unit: 'kit',
    ),
  ];

  Color _getDonateCategoryColor(String category) {
    switch (category) {
      case 'water':
        return const Color(0xFF06B6D4);
      case 'food':
        return const Color(0xFFF59E0B);
      case 'clothes':
        return const Color(0xFF10B981);
      case 'kit':
        return const Color(0xFF8B5CF6);
      case 'other':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF666666);
    }
  }

  Color _getRequestCategoryColor(String category) {
    switch (category) {
      case 'water':
        return const Color(0xFF3B82F6);
      case 'food':
        return const Color(0xFFF59E0B);
      case 'clothes':
        return const Color(0xFF10B981);
      case 'kit':
        return const Color(0xFFDC2626);
      case 'other':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF666666);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'water':
        return Icons.water_drop;
      case 'food':
        return Icons.restaurant;
      case 'clothes':
        return Icons.checkroom;
      case 'kit':
        return Icons.medical_services;
      case 'other':
        return Icons.inventory;
      default:
        return Icons.inventory;
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'water':
        return 'Water';
      case 'food':
        return 'Food';
      case 'clothes':
        return 'Clothes';
      case 'kit':
        return 'Emergency Kit';
      case 'other':
        return 'Other Supplies';
      default:
        return category;
    }
  }

  void _handleDonationSelect(String resourceId) {
    if (_activeTab == 'donate') {
      setState(() {
        _selectedResource = resourceId;
        _showModal = true;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleRequestSelect(String resourceId) {
    if (_activeTab == 'request') {
      setState(() {
        _selectedResource = resourceId;
        _showModal = true;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSubmitDonation() {
    if (_selectedResource == null) return;

    final resource = _donatableItems.firstWhere(
      (r) => r.id == _selectedResource,
      orElse: () => _donatableItems[0],
    );

    final qty = int.tryParse(_quantity) ?? 1;

    if (qty < 1) {
      _showAlert('Error', 'Quantity must be at least 1');
      return;
    }

    final newDonation = MyRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      resourceId: _selectedResource!,
      quantity: qty,
      urgent: _urgent,
      notes: _notes.trim(),
      status: 'pending',
      date: _formatDateTime(DateTime.now()),
      type: 'donation',
    );

    setState(() {
      _myRequests.insert(0, newDonation);
    });

    _showAlert(
      'Donation Submitted!',
      'Thank you for your generous donation of $qty ${resource.name}${qty > 1 ? 's' : ''}!\n\n'
          'DRRMO will contact you for pickup arrangements.\n'
          '${_urgent ? '🚨 URGENT DONATION - Priority pickup' : ''}',
      onOk: () {
        setState(() {
          _showModal = false;
          _quantity = '1';
          _urgent = false;
          _notes = '';
          _selectedResource = null;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _activeTab = 'myRequests';
          });
        });
      },
    );
  }

  void _handleSubmitRequest() {
    if (_selectedResource == null) return;

    final resource = _requestableItems.firstWhere(
      (r) => r.id == _selectedResource,
      orElse: () => _requestableItems[0],
    );

    final qty = int.tryParse(_quantity) ?? 1;

    if (qty < 1) {
      _showAlert('Error', 'Quantity must be at least 1');
      return;
    }

    if (!resource.available) {
      _showAlert('Not Available',
          'Sorry, ${resource.name} is currently out of stock.');
      return;
    }

    final newRequest = MyRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      resourceId: _selectedResource!,
      quantity: qty,
      urgent: _urgent,
      notes: _notes.trim(),
      status: 'pending',
      date: _formatDateTime(DateTime.now()),
      type: 'request',
    );

    setState(() {
      _myRequests.insert(0, newRequest);
    });

    _showAlert(
      'Request Submitted!',
      'Your request for $qty ${resource.name}${qty > 1 ? 's' : ''} has been submitted.\n\n'
          'Estimated delivery: ${resource.estimatedDelivery}\n'
          '${_urgent ? '🚨 URGENT REQUEST - Priority handling' : ''}',
      onOk: () {
        setState(() {
          _showModal = false;
          _quantity = '1';
          _urgent = false;
          _notes = '';
          _selectedResource = null;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _activeTab = 'myRequests';
          });
        });
      },
    );
  }

  void _handleCancelRequest(String requestId) {
    _showConfirmDialog(
      'Cancel',
      'Are you sure you want to cancel this?',
      onConfirm: () {
        setState(() {
          _myRequests.removeWhere((r) => r.id == requestId);
        });
        _showAlert('Cancelled', 'Your item has been cancelled.');
      },
    );
  }

  void _handleContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text('Select contact method:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAlert('Call', 'Would call DRRMO hotline');
            },
            child: const Text('📞 Call Hotline'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAlert('SMS', 'Would send SMS to DRRMO');
            },
            child: const Text('📱 SMS'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAlert(
                'DRRMO Office',
                'Navotas City Hall Compound\nM. Naval Street, Navotas City\nOpen 24/7 during emergencies',
              );
            },
            child: const Text('📍 Visit DRRMO Office'),
          ),
        ],
      ),
    );
  }

  ResourceItem? _getSelectedResourceDetails() {
    if (_selectedResource == null) return null;

    return _activeTab == 'donate'
        ? _donatableItems.firstWhere((r) => r.id == _selectedResource,
            orElse: () => _donatableItems[0])
        : _requestableItems.firstWhere((r) => r.id == _selectedResource,
            orElse: () => _requestableItems[0]);
  }

  String _formatDateTime(DateTime date) {
    return '${date.month}/${date.day}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showAlert(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(String title, String message,
      {required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(ResourceItem item, bool isDonate) {
    final color = isDonate
        ? _getDonateCategoryColor(item.category)
        : _getRequestCategoryColor(item.category);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedResource == item.id ? color : const Color(0xFFE5E7EB),
          width: _selectedResource == item.id ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => isDonate
            ? _handleDonationSelect(item.id)
            : _handleRequestSelect(item.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Icon and Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, size: 24, color: Colors.white),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, size: 12, color: color),
                        const SizedBox(width: 2),
                        Text(
                          'NEEDED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Name
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              // Footer with Category and Info
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 6,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(item.category),
                            size: 12, color: color),
                        const SizedBox(width: 2),
                        Text(
                          _getCategoryName(item.category),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pickup/Delivery Info
                  Text(
                    isDonate ? 'Pickup within 24hrs' : 'Available',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestableItem(ResourceItem item, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleRequestSelect(item.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left Side - Icon and Text
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, size: 20, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right Side - Delivery and Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.estimatedDelivery ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'REQUEST',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyRequestCard(MyRequest request) {
    final resource = request.type == 'donation'
        ? _donatableItems.firstWhere((r) => r.id == request.resourceId,
            orElse: () => _donatableItems[0])
        : _requestableItems.firstWhere((r) => r.id == request.resourceId,
            orElse: () => _requestableItems[0]);

    final color = request.type == 'donation'
        ? _getDonateCategoryColor(resource.category)
        : _getRequestCategoryColor(resource.category);

    Color statusColor;
    switch (request.status) {
      case 'delivered':
        statusColor = const Color(0xFF10B981);
        break;
      case 'processing':
        statusColor = const Color(0xFFDC2626);
        break;
      default:
        statusColor = const Color(0xFFF59E0B);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              request.type == 'donation'
                                  ? Icons.favorite
                                  : Icons.inventory,
                              size: 12,
                              color: color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              request.type == 'donation'
                                  ? 'DONATION'
                                  : 'REQUEST',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Resource Name
                      Text(
                        resource.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Meta Info
                      Row(
                        children: [
                          Text(
                            '${request.quantity} ${resource.unit ?? 'item'}${request.quantity > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              request.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (request.urgent)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning,
                            size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        const Text(
                          'URGENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // ID and Date
                  Row(
                    children: [
                      const Text('ID:',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280))),
                      const SizedBox(width: 8),
                      Text(
                        request.id.substring(request.id.length - 6),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Text('Date:',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280))),
                      const SizedBox(width: 8),
                      Text(
                        request.date,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Pickup/Delivery
                  Row(
                    children: [
                      Text(
                        '${request.type == 'donation' ? 'Pickup:' : 'Delivery:'}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        request.type == 'donation'
                            ? 'Within 24 hours'
                            : resource.estimatedDelivery ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Notes
                  if (request.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notes:',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF6B7280))),
                        const SizedBox(height: 4),
                        Text(
                          request.notes,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1F2937),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAlert(
                        'Track',
                        request.type == 'donation'
                            ? 'Pickup tracking feature coming soon!'
                            : 'Delivery tracking feature coming soon!',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.location_on, size: 16),
                    label: Text(
                      request.type == 'donation'
                          ? 'Track Pickup'
                          : 'Track Delivery',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleCancelRequest(request.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: BorderSide(
                          color: const Color(0xFFDC2626).withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalContent() {
    final resource = _getSelectedResourceDetails();
    if (resource == null) return Container();

    final color = _activeTab == 'donate'
        ? _getDonateCategoryColor(resource.category)
        : _getRequestCategoryColor(resource.category);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Modal Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_activeTab == 'donate' ? 'Donate' : 'Request'} ${resource.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _showModal = false),
                      icon: const Icon(Icons.close,
                          size: 24, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
              // Modal Body
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Resource Summary
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(resource.icon,
                                size: 32, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resource.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getCategoryName(resource.category),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  resource.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _activeTab == 'donate'
                                      ? '🕐 Pickup within 24 hours'
                                      : '📦 Estimated delivery: ${resource.estimatedDelivery}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Quantity
                      const Text(
                        'Quantity *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              final qty = int.tryParse(_quantity) ?? 1;
                              if (qty > 1) {
                                setState(
                                    () => _quantity = (qty - 1).toString());
                              }
                            },
                            icon: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFD1D5DB)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.remove,
                                  color: Color(0xFF1F2937)),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: _quantity)
                                ..selection = TextSelection.collapsed(
                                    offset: _quantity.length),
                              onChanged: (text) {
                                final num = int.tryParse(text);
                                if (num != null && num >= 1 && num <= 50) {
                                  setState(() => _quantity = text);
                                } else if (text.isEmpty) {
                                  setState(() => _quantity = '1');
                                }
                              },
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD1D5DB)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD1D5DB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: color, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final qty = int.tryParse(_quantity) ?? 1;
                              if (qty < 50) {
                                setState(
                                    () => _quantity = (qty + 1).toString());
                              }
                            },
                            icon: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFD1D5DB)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add,
                                  color: Color(0xFF1F2937)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Urgent Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _urgent,
                            onChanged: (value) =>
                                setState(() => _urgent = value ?? false),
                            activeColor: color,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Urgent',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Text(
                                  _activeTab == 'donate'
                                      ? 'This donation needs immediate pickup'
                                      : 'This is an urgent emergency need',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Notes
                      const Text(
                        'Additional Notes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Add any special instructions or details...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: color, width: 2),
                          ),
                        ),
                        onChanged: (text) => setState(() => _notes = text),
                      ),
                      const SizedBox(height: 24),
                      // Contact Information
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info,
                                    size: 20, color: Color(0xFF3B82F6)),
                                SizedBox(width: 8),
                                Text(
                                  'Contact Information',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _activeTab == 'donate'
                                  ? 'DRRMO will contact you using your profile information for pickup arrangements.'
                                  : 'DRRMO will deliver to the address in your profile. Please ensure your information is up to date.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _handleContactSupport,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Need help? Contact DRRMO Support',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _activeTab == 'donate'
                              ? _handleSubmitDonation
                              : _handleSubmitRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _activeTab == 'donate'
                                ? 'SUBMIT DONATION'
                                : 'SUBMIT REQUEST',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      children: [
                        if (widget.onBackPressed != null)
                          IconButton(
                            onPressed: widget.onBackPressed,
                            icon: const Icon(Icons.arrow_back,
                                color: Color(0xFF374151)),
                          ),
                        const SizedBox(width: 8),
                        const Text(
                          'Resources',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Tabs
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    _buildTabButton('donate', 'Donate'),
                    const SizedBox(width: 12),
                    _buildTabButton('request', 'Request'),
                    const SizedBox(width: 12),
                    _buildTabButton('myRequests', 'My Items'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(),
                ),
              ),

              // Bottom Navigation - SAME AS HOMESCREEN
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
                ),
                child: Row(
                  children: bottomNavItems
                      .map((item) => _buildBottomNavItem(item))
                      .toList(),
                ),
              ),
            ],
          ),

          // Modal Overlay
          if (_showModal)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: true,
              onDismiss: () => setState(() => _showModal = false),
            ),

          // Modal Content
          if (_showModal)
            Positioned.fill(
              child: _buildModalContent(),
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String id, String label) {
    final isActive = _activeTab == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = id),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_activeTab) {
      case 'donate':
        return _buildDonateContent();
      case 'request':
        return _buildRequestContent();
      case 'myRequests':
        return _buildMyRequestsContent();
      default:
        return Container();
    }
  }

  Widget _buildDonateContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'What can you donate?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select items you wish to donate. DRRMO will arrange pickup within 24 hours.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 24),

        // Items List
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _donatableItems.map((item) {
            final color = _getDonateCategoryColor(item.category);
            return Column(
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _handleDonationSelect(item.id),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row - NEEDED Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite,
                                        size: 12, color: color),
                                    const SizedBox(width: 2),
                                    Text(
                                      'NEEDED',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Main Content Row
                          Row(
                            children: [
                              // Left Side - Icon and Text
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(item.icon,
                                          size: 20, color: color),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF6B7280),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right Side - Pickup and Button
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Pickup within 24hrs',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'DONATE',
                                      style: TextStyle(
                                        fontSize: 12,
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
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRequestContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'Request Emergency Resources',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Available resources for emergency situations. Select an item to request.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 24),

        // Categories
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._requestableItems.map((item) {
              final color = _getRequestCategoryColor(item.category);
              return Column(
                children: [
                  _buildRequestableItem(item, color),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildMyRequestsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'My Donations & Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You have ${_myRequests.length} item${_myRequests.length != 1 ? 's' : ''}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 24),

        // Requests List
        if (_myRequests.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.inventory,
                  size: 64,
                  color: const Color(0xFF9CA3AF).withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No items yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start by donating or requesting resources above',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              ..._myRequests.map((request) {
                return Column(
                  children: [
                    _buildMyRequestCard(request),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ],
          ),
      ],
    );
  }
}

// Data Models
class ResourceItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final IconData icon;
  final bool available;
  final String? estimatedDelivery;
  final String? unit;

  ResourceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.available,
    this.estimatedDelivery,
    this.unit,
  });
}

class MyRequest {
  final String id;
  final String resourceId;
  final int quantity;
  final bool urgent;
  final String notes;
  final String status;
  final String date;
  final String type;

  MyRequest({
    required this.id,
    required this.resourceId,
    required this.quantity,
    required this.urgent,
    required this.notes,
    required this.status,
    required this.date,
    required this.type,
  });
}

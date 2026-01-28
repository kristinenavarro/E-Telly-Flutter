import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportEmergencyScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final ValueChanged<String>? onTabSelected;

  const ReportEmergencyScreen({
    Key? key,
    this.onBackPressed,
    this.onTabSelected,
  }) : super(key: key);

  @override
  _ReportEmergencyScreenState createState() => _ReportEmergencyScreenState();
}

class _ReportEmergencyScreenState extends State<ReportEmergencyScreen> {
  String? _emergencyType;
  int _severity = 2;
  bool _isSubmitting = false;
  UserData _userData = UserData();
  bool _loading = true;
  final List<String> _images = [];
  bool _showAdditionalInfo = false;
  String _activeTab = 'report';

  final ImagePicker _picker = ImagePicker();
  
  // Bottom Navigation Items
  final List<BottomNavItem> _bottomNavItems = [
    BottomNavItem(id: 'home', label: 'Home', icon: Icons.home_outlined, iconActive: Icons.home),
    BottomNavItem(id: 'safety', label: 'Safety Tips', icon: Icons.security_outlined, iconActive: Icons.security),
    BottomNavItem(id: 'evac', label: 'Evac Nav', icon: Icons.map_outlined, iconActive: Icons.map),
    BottomNavItem(id: 'resources', label: 'Resources', icon: Icons.inventory_outlined, iconActive: Icons.inventory),
    BottomNavItem(id: 'profile', label: 'Profile', icon: Icons.person_outlined, iconActive: Icons.person),
  ];

  // Emergency Types
  final List<EmergencyType> _emergencyTypes = [
    EmergencyType(
      id: 'flood',
      title: 'Flood',
      icon: Icons.water_damage,
      typeColor: const Color(0xFF06B6D4),
    ),
    EmergencyType(
      id: 'storm-surge',
      title: 'Storm Surge',
      icon: Icons.water,
      typeColor: const Color(0xFF0EA5E9),
    ),
    EmergencyType(
      id: 'rescue',
      title: 'Rescue',
      icon: Icons.person,
      typeColor: const Color(0xFF10B981),
    ),
    EmergencyType(
      id: 'medical',
      title: 'Medical',
      icon: Icons.medical_services,
      typeColor: const Color(0xFFDC2626),
    ),
    EmergencyType(
      id: 'typhoon',
      title: 'Typhoon',
      icon: Icons.cloud,
      typeColor: const Color(0xFF3B82F6),
    ),
    EmergencyType(
      id: 'earthquake',
      title: 'Earthquake',
      icon: Icons.warning,
      typeColor: const Color(0xFFF59E0B),
    ),
    EmergencyType(
      id: 'fire',
      title: 'Fire',
      icon: Icons.local_fire_department,
      typeColor: const Color(0xFFDC2626),
    ),
    EmergencyType(
      id: 'seawall',
      title: 'Seawall',
      icon: Icons.shield,
      typeColor: const Color(0xFF8B5CF6),
    ),
    EmergencyType(
      id: 'other',
      title: 'Other',
      icon: Icons.warning,
      typeColor: const Color(0xFF666666),
    ),
  ];

  // Severity Levels
  final List<SeverityLevel> _severityLevels = [
    SeverityLevel(
      level: 1,
      label: 'Low',
      description: 'Minor issue, no immediate danger',
      color: const Color(0xFF10B981),
    ),
    SeverityLevel(
      level: 2,
      label: 'Medium',
      description: 'Significant issue, monitor closely',
      color: const Color(0xFFF59E0B),
    ),
    SeverityLevel(
      level: 3,
      label: 'High',
      description: 'Urgent, immediate action needed',
      color: const Color(0xFFDC2626),
    ),
    SeverityLevel(
      level: 4,
      label: 'Critical',
      description: 'Life-threatening, immediate response',
      color: const Color(0xFFDC2626),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('full_name');
      final address = prefs.getString('address');
      final phone = prefs.getString('phone_number');

      setState(() {
        _userData = UserData(
          fullName: name,
          address: address,
          phoneNumber: phone,
        );
        _loading = false;
      });
    } catch (error) {
      print('Error loading user data: $error');
      setState(() {
        _loading = false;
      });
    }
  }

  void _handleBottomNavPress(String id) {
    setState(() {
      _activeTab = id;
    });
    
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(id);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (_images.length >= 5) {
          _showAlert('Limit Reached', 'You can only upload up to 5 images');
          return;
        }
        setState(() {
          _images.add(image.path);
        });
      }
    } catch (error) {
      _showAlert('Error', 'Failed to pick image');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (_images.length >= 5) {
          _showAlert('Limit Reached', 'You can only upload up to 5 images');
          return;
        }
        setState(() {
          _images.add(image.path);
        });
      }
    } catch (error) {
      _showAlert('Error', 'Failed to take photo');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    if (_emergencyType == null) {
      _showAlert('Error', 'Please select an emergency type');
      return;
    }

    final selectedEmergency = _emergencyTypes.firstWhere(
      (e) => e.id == _emergencyType,
      orElse: () => _emergencyTypes[0],
    );
    final selectedSeverity = _severityLevels.firstWhere(
      (s) => s.level == _severity,
      orElse: () => _severityLevels[1],
    );

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSubmitting = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Reported!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your ${selectedEmergency.title} emergency has been reported to authorities.\n',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Severity: ${selectedSeverity.label}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Location: ${_userData.address ?? 'Current Location'}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Photos: ${_images.length} uploaded',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Emergency responders have been notified and will contact you shortly.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
              if (widget.onBackPressed != null) {
                widget.onBackPressed!();
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              // Call emergency hotline
              // You would need url_launcher package for this
              // launchUrl(Uri.parse('tel:911'));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Call Emergency Hotline'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _emergencyType = null;
      _severity = 2;
      _images.clear();
      _showAdditionalInfo = false;
    });
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: _emergencyTypes.length,
      itemBuilder: (context, index) {
        final type = _emergencyTypes[index];
        final isSelected = _emergencyType == type.id;
        
        return GestureDetector(
          onTap: () => setState(() => _emergencyType = type.id),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? type.typeColor : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: type.typeColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(type.icon, size: 22, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    type.title,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeverityGrid() {
    return Column(
      children: _severityLevels.map((level) {
        final isSelected = _severity == level.level;
        
        return GestureDetector(
          onTap: () => setState(() => _severity = level.level),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? level.color : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: level.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        level.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? level.color : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    level.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _images.asMap().entries.map((entry) {
            final index = entry.key;
            final path = entry.value;
            
            return Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${_images.length} of 5 photos uploaded',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard() {
    final selectedEmergency = _emergencyTypes.firstWhere(
      (e) => e.id == _emergencyType,
      orElse: () => _emergencyTypes[0],
    );
    final selectedSeverity = _severityLevels.firstWhere(
      (s) => s.level == _severity,
      orElse: () => _severityLevels[1],
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Emergency Type
          _buildSummaryRow(
            label: 'Emergency Type:',
            value: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: selectedEmergency.typeColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(selectedEmergency.icon, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text(
                  selectedEmergency.title,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          // Severity Level
          _buildSummaryRow(
            label: 'Severity Level:',
            value: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: selectedSeverity.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${selectedSeverity.label} (Level $_severity)',
                  style: TextStyle(
                    color: selectedSeverity.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          // Location
          _buildSummaryRow(
            label: 'Location:',
            value: Text(
              _userData.address ?? 'Current Location',
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          // Photos
          _buildSummaryRow(
            label: 'Photos Uploaded:',
            value: Text(
              '${_images.length} photo(s)',
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required String label, required Widget value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          value,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFFDC2626)),
              const SizedBox(height: 20),
              const Text(
                'Loading your information...',
                style: TextStyle(color: Color(0xFF666666), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 20,
              right: 20,
              bottom: 14,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
                  icon: Container(
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
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Report Emergency',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Call emergency hotline
                    // You would need url_launcher package for this
                    // launchUrl(Uri.parse('tel:911'));
                  },
                  icon: Container(
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
                    child: const Icon(
                      Icons.call,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emergency Type Section
                  const Text(
                    'Select Emergency Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildEmergencyTypeGrid(),
                  const SizedBox(height: 20),
                  // Severity Section (only shows if emergency type is selected)
                  if (_emergencyType != null) ...[
                    const Text(
                      'Select Severity Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSeverityGrid(),
                    const SizedBox(height: 20),
                    // Location Section
                    const Text(
                      'Emergency Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_pin, size: 20, color: Color(0xFFDC2626)),
                              const SizedBox(width: 8),
                              const Text(
                                'Your Registered Address',
                                style: TextStyle(
                                  color: Color(0xFF1F2937),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _userData.address ?? 'No address saved in your profile',
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          if (_userData.address == null) ...[
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                // Navigate to Profile
                                if (widget.onTabSelected != null) {
                                  widget.onTabSelected!('profile');
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFDC2626),
                                side: BorderSide(
                                  color: const Color(0xFFDC2626).withOpacity(0.2),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Update your address in Profile'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Additional Information Toggle
                    GestureDetector(
                      onTap: () => setState(() => _showAdditionalInfo = !_showAdditionalInfo),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _showAdditionalInfo ? Icons.expand_less : Icons.expand_more,
                              size: 20,
                              color: const Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Additional Information (Optional)',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Additional Information Content
                    if (_showAdditionalInfo) ...[
                      const SizedBox(height: 16),
                      // Upload Photos
                      const Text(
                        'Upload Photos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Upload photos to help responders (max 5)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _takePhoto,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFDC2626),
                                side: BorderSide(
                                  color: const Color(0xFFDC2626).withOpacity(0.2),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.camera_alt, size: 18),
                              label: const Text(
                                'Take Photo',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickImage,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFDC2626),
                                side: BorderSide(
                                  color: const Color(0xFFDC2626).withOpacity(0.2),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.photo_library, size: 18),
                              label: const Text(
                                'Choose from Gallery',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildImagePreview(),
                      const SizedBox(height: 20),
                    ],
                    // Summary Section
                    const Text(
                      'Emergency Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(),
                    const SizedBox(height: 20),
                  ],
                  // Disclaimer
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info, size: 16, color: Color(0xFFDC2626)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This emergency report will be sent immediately to Navotas DRRMO emergency responders. '
                            'False reports may result in legal action. In case of immediate danger, call 911 first.',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF1F2937),
                              height: 1.5,
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
                    child: ElevatedButton.icon(
                      onPressed: (_emergencyType != null && _userData.address != null && !_isSubmitting)
                          ? _handleSubmit
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        shadowColor: const Color(0xFFDC2626).withOpacity(0.2),
                      ),
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.warning, size: 18, color: Colors.white),
                      label: _isSubmitting
                          ? const Text('Reporting...', style: TextStyle(color: Colors.white))
                          : const Text(
                              'Report Emergency',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Emergency Hotline Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Call emergency hotline
                        // You would need url_launcher package for this
                        // launchUrl(Uri.parse('tel:911'));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.call, size: 16, color: Color(0xFFDC2626)),
                      label: const Text(
                        'Call 911',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          // Bottom Navigation
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: _bottomNavItems.map((item) {
                final isActive = _activeTab == item.id;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _handleBottomNavPress(item.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFDC2626).withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: isActive
                            ? Border.all(
                                color: const Color(0xFFDC2626).withOpacity(0.2),
                                width: 0.5,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive ? item.iconActive : item.icon,
                            size: 20,
                            color: isActive
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF666666),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 8,
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
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class EmergencyType {
  final String id;
  final String title;
  final IconData icon;
  final Color typeColor;

  EmergencyType({
    required this.id,
    required this.title,
    required this.icon,
    required this.typeColor,
  });
}

class SeverityLevel {
  final int level;
  final String label;
  final String description;
  final Color color;

  SeverityLevel({
    required this.level,
    required this.label,
    required this.description,
    required this.color,
  });
}

class UserData {
  final String? fullName;
  final String? address;
  final String? phoneNumber;

  UserData({
    this.fullName,
    this.address,
    this.phoneNumber,
  });
}

class BottomNavItem {
  final String id;
  final String label;
  final IconData icon;
  final IconData iconActive;

  BottomNavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.iconActive,
  });
}
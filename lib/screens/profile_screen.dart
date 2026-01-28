import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final ValueChanged<String>? onTabSelected;

  const ProfileScreen({
    Key? key,
    this.onBackPressed,
    this.onTabSelected,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _activeScreen = 'profile';
  UserProfile? _profile;
  bool _isEditing = false;
  UserProfile _editedProfile = UserProfile();
  String? _profileImage;
  bool _isUploading = false;
  bool _showEmergencyModal = false;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  // Bottom Navigation Items - SAME AS HOMESCREEN
  final List<Map<String, dynamic>> bottomNavItems = [
    {'id': 'home', 'label': 'Home', 'icon': Icons.home_outlined, 'iconActive': Icons.home},
    {'id': 'safety', 'label': 'Safety Tips', 'icon': Icons.security_outlined, 'iconActive': Icons.security},
    {'id': 'evac', 'label': 'Evac Map', 'icon': Icons.map_outlined, 'iconActive': Icons.map},
    {'id': 'resources', 'label': 'Resources', 'icon': Icons.inventory_outlined, 'iconActive': Icons.inventory},
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person_outline, 'iconActive': Icons.person},
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
        _navigateToScreen('/');
        break;
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
        // Already on profile screen
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
                  fontSize: 9,
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
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Simulate loading user data from SharedPreferences
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _profile = UserProfile(
          fullName: prefs.getString('full_name') ?? 'John Doe',
          email: prefs.getString('email') ?? 'user@example.com',
          phoneNumber: prefs.getString('phone_number'),
          region: prefs.getString('region'),
          province: prefs.getString('province'),
          city: prefs.getString('city'),
          barangay: prefs.getString('barangay'),
          postalCode: prefs.getString('postal_code'),
          streetAddress: prefs.getString('street_address'),
          emergencyContactName: prefs.getString('emergency_contact_name'),
          emergencyContactPhone: prefs.getString('emergency_contact_phone'),
          emergencyContactRelationship: prefs.getString('emergency_contact_relationship'),
          role: 'resident',
        );
        
        _editedProfile = _profile!.copy();
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading profile: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        _updateProfileImage(image.path);
      }
    } catch (error) {
      _showAlert('Error', 'Failed to pick image');
    }
  }

  Future<void> _takeProfilePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        _updateProfileImage(image.path);
      }
    } catch (error) {
      _showAlert('Error', 'Failed to take photo');
    }
  }

  Future<void> _updateProfileImage(String imagePath) async {
    setState(() {
      _isUploading = true;
    });

    // Simulate image upload
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _profileImage = imagePath;
      _isUploading = false;
    });

    _showAlert('Success', 'Profile image updated successfully');
  }

  void _handleEdit() {
    setState(() {
      _isEditing = true;
      _editedProfile = _profile!.copy();
    });
  }

  Future<void> _handleSave() async {
    if (_editedProfile.fullName == null || _editedProfile.fullName!.isEmpty) {
      _showAlert('Error', 'Please enter your name');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save updated profile to SharedPreferences
      await prefs.setString('full_name', _editedProfile.fullName ?? '');
      await prefs.setString('phone_number', _editedProfile.phoneNumber ?? '');
      await prefs.setString('region', _editedProfile.region ?? '');
      await prefs.setString('province', _editedProfile.province ?? '');
      await prefs.setString('city', _editedProfile.city ?? '');
      await prefs.setString('barangay', _editedProfile.barangay ?? '');
      await prefs.setString('postal_code', _editedProfile.postalCode ?? '');
      await prefs.setString('street_address', _editedProfile.streetAddress ?? '');
      await prefs.setString('emergency_contact_name', _editedProfile.emergencyContactName ?? '');
      await prefs.setString('emergency_contact_phone', _editedProfile.emergencyContactPhone ?? '');
      await prefs.setString('emergency_contact_relationship', _editedProfile.emergencyContactRelationship ?? '');

      setState(() {
        _profile = _editedProfile.copy();
        _isEditing = false;
        _isLoading = false;
      });

      _showAlert('Success', 'Profile updated successfully');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showAlert('Error', 'Failed to save profile');
    }
  }

  void _handleCancel() {
    setState(() {
      _isEditing = false;
      _editedProfile = _profile!.copy();
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Clear SharedPreferences and navigate to welcome
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              // Navigate to welcome screen
              if (widget.onTabSelected != null) {
                widget.onTabSelected!('home');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFDC2626)),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takeProfilePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFDC2626)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickProfileImage();
              },
            ),
          ],
        ),
      ),
    );
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

  Widget _buildProfilePhotoSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _isEditing ? _showImagePickerOptions : null,
          child: Stack(
            children: [
              if (_isUploading)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: const Color(0xFFDC2626), width: 2),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFDC2626)),
                  ),
                )
              else if (_profileImage != null)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: const Color(0xFFDC2626), width: 2),
                    image: DecorationImage(
                      image: FileImage(File(_profileImage!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: const Color(0xFFDC2626), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _profile?.fullName?.split(' ').map((n) => n[0]).join('').toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isEditing)
          SizedBox(
            width: 200,
            child: TextField(
              controller: TextEditingController(text: _editedProfile.fullName),
              onChanged: (value) => setState(() => _editedProfile.fullName = value),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
                contentPadding: const EdgeInsets.all(8),
              ),
            ),
          )
        else
          Text(
            _profile?.fullName ?? 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          _profile?.email ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _profile?.role == 'lgu_admin' ? 'LGU Admin' : 'Resident',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String? value,
    required String? editedValue,
    required Function(String) onChanged,
    bool multiline = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          if (_isEditing)
            TextField(
              controller: TextEditingController(text: editedValue ?? ''),
              onChanged: onChanged,
              maxLines: multiline ? 2 : 1,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
                contentPadding: const EdgeInsets.all(8),
              ),
            )
          else
            Text(
              value ?? 'Not provided',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmergencyModal() {
    return AlertDialog(
      title: const Text('Emergency Contact'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info, size: 24, color: Color(0xFFDC2626)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your emergency contact information will be shared with responders when you report an emergency. Ensure this information is accurate and up-to-date.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning, size: 20, color: Color(0xFFDC2626)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Make sure your emergency contact is aware that they are listed as your emergency contact.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F2937),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() => _showEmergencyModal = false),
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFFDC2626)),
              const SizedBox(height: 20),
              const Text(
                'Loading profile...',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 48, color: Color(0xFFDC2626)),
              const SizedBox(height: 20),
              const Text(
                'Profile Not Available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please sign in to view your profile',
                style: TextStyle(color: Color(0xFF666666)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login
                  if (widget.onTabSelected != null) {
                    widget.onTabSelected!('home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                ),
                child: const Text('Go to Home'),
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
                      border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.2)),
                    ),
                    child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFFDC2626)),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage your account',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isEditing ? _handleSave : _handleEdit,
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Icon(
                      _isEditing ? Icons.check : Icons.edit,
                      size: 24,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Photo Section
                  _buildProfilePhotoSection(),
                  const SizedBox(height: 30),
                  // Personal Information
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, size: 20, color: Color(0xFFDC2626)),
                            const SizedBox(width: 8),
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: _buildInfoItem(
                            label: 'Phone Number',
                            value: _profile?.phoneNumber,
                            editedValue: _editedProfile.phoneNumber,
                            onChanged: (value) => setState(() => _editedProfile.phoneNumber = value),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Address Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 20, color: Color(0xFFDC2626)),
                                const SizedBox(width: 8),
                                const Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                            if (_isEditing)
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Handle current location
                                  _showAlert('Info', 'Current location feature would be implemented here');
                                },
                                icon: const Icon(Icons.navigation, size: 16, color: Color(0xFFDC2626)),
                                label: const Text(
                                  'Use Current Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFDC2626),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: const Color(0xFFDC2626).withOpacity(0.2)),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            children: [
                              _buildInfoItem(
                                label: 'Region',
                                value: _profile?.region,
                                editedValue: _editedProfile.region,
                                onChanged: (value) => setState(() => _editedProfile.region = value),
                              ),
                              _buildInfoItem(
                                label: 'Province',
                                value: _profile?.province,
                                editedValue: _editedProfile.province,
                                onChanged: (value) => setState(() => _editedProfile.province = value),
                              ),
                              _buildInfoItem(
                                label: 'City',
                                value: _profile?.city,
                                editedValue: _editedProfile.city,
                                onChanged: (value) => setState(() => _editedProfile.city = value),
                              ),
                              _buildInfoItem(
                                label: 'Barangay',
                                value: _profile?.barangay,
                                editedValue: _editedProfile.barangay,
                                onChanged: (value) => setState(() => _editedProfile.barangay = value),
                              ),
                              _buildInfoItem(
                                label: 'Postal Code',
                                value: _profile?.postalCode,
                                editedValue: _editedProfile.postalCode,
                                onChanged: (value) => setState(() => _editedProfile.postalCode = value),
                                keyboardType: TextInputType.number,
                              ),
                              _buildInfoItem(
                                label: 'Street Address',
                                value: _profile?.streetAddress,
                                editedValue: _editedProfile.streetAddress,
                                onChanged: (value) => setState(() => _editedProfile.streetAddress = value),
                                multiline: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Emergency Contact
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.medical_services, size: 20, color: Color(0xFFDC2626)),
                                const SizedBox(width: 8),
                                const Text(
                                  'Emergency Contact',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => setState(() => _showEmergencyModal = true),
                              icon: const Icon(Icons.info, size: 20, color: Color(0xFFDC2626)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            children: [
                              _buildInfoItem(
                                label: 'Name',
                                value: _profile?.emergencyContactName,
                                editedValue: _editedProfile.emergencyContactName,
                                onChanged: (value) => setState(() => _editedProfile.emergencyContactName = value),
                              ),
                              _buildInfoItem(
                                label: 'Phone',
                                value: _profile?.emergencyContactPhone,
                                editedValue: _editedProfile.emergencyContactPhone,
                                onChanged: (value) => setState(() => _editedProfile.emergencyContactPhone = value),
                                keyboardType: TextInputType.phone,
                              ),
                              _buildInfoItem(
                                label: 'Relationship',
                                value: _profile?.emergencyContactRelationship,
                                editedValue: _editedProfile.emergencyContactRelationship,
                                onChanged: (value) => setState(() => _editedProfile.emergencyContactRelationship = value),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Row(
                    children: [
                      if (_isEditing)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _handleCancel,
                            icon: const Icon(Icons.close, size: 20, color: Color(0xFF1F2937)),
                            label: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.logout, size: 20, color: Color(0xFFDC2626)),
                          label: const Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: const Color(0xFFDC2626).withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Bottom Navigation - SAME AS HOMESCREEN
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
            ),
            child: Row(
              children: bottomNavItems.map((item) => _buildBottomNavItem(item)).toList(),
            ),
          ),
        ],
      ),
      // Emergency Modal
      bottomSheet: _showEmergencyModal ? _buildEmergencyModal() : null,
    );
  }
}

// Data Models
class UserProfile {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? region;
  String? province;
  String? city;
  String? barangay;
  String? postalCode;
  String? streetAddress;
  String? emergencyContactName;
  String? emergencyContactPhone;
  String? emergencyContactRelationship;
  String role;

  UserProfile({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.region,
    this.province,
    this.city,
    this.barangay,
    this.postalCode,
    this.streetAddress,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelationship,
    this.role = 'resident',
  });

  UserProfile copy() {
    return UserProfile(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      region: region,
      province: province,
      city: city,
      barangay: barangay,
      postalCode: postalCode,
      streetAddress: streetAddress,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelationship: emergencyContactRelationship,
      role: role,
    );
  }
}
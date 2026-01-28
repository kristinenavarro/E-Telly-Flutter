import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onSignUpSuccess;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onBackPressed;

  const SignUpScreen({
    Key? key,
    this.onSignUpSuccess,
    this.onLoginPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _streetDetailsController = TextEditingController();

  // State variables
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  bool _showBarangayModal = false;
  String? _selectedBarangay;

  // Validation errors
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _barangayError;
  String? _streetDetailsError;

  // Barangay options (Tanza 1 and Tanza 2 only)
  final List<Map<String, String>> _barangays = [
    {'id': 'tanza1', 'name': 'Tanza 1', 'value': 'Tanza 1'},
    {'id': 'tanza2', 'name': 'Tanza 2', 'value': 'Tanza 2'},
  ];

  // Safe margin helper
  EdgeInsets _safeMargin({double top = 0, double bottom = 0, double left = 0, double right = 0}) {
    return EdgeInsets.only(
      top: top < 0 ? 0.0 : top,
      bottom: bottom < 0 ? 0.0 : bottom,
      left: left < 0 ? 0.0 : left,
      right: right < 0 ? 0.0 : right,
    );
  }

  // Safe padding helper
  EdgeInsets _safePadding({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal < 0 ? 0.0 : horizontal,
      vertical: vertical < 0 ? 0.0 : vertical,
    );
  }

  bool _validateForm() {
    bool isValid = true;
    final errors = <String, String?>{};

    // Name validation
    if (_nameController.text.trim().isEmpty) {
      errors['name'] = 'Name is required';
      isValid = false;
    }

    // Email validation
    if (_emailController.text.trim().isEmpty) {
      errors['email'] = 'Email is required';
      isValid = false;
    } else if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
      errors['email'] = 'Please enter a valid email';
      isValid = false;
    }

    // Barangay validation - ONLY Tanza 1 or Tanza 2
    if (_selectedBarangay == null || _selectedBarangay!.isEmpty) {
      errors['barangay'] = 'Please select your barangay';
      isValid = false;
    } else if (!['Tanza 1', 'Tanza 2'].contains(_selectedBarangay!.trim())) {
      errors['barangay'] = 'Please select a valid barangay';
      isValid = false;
    }

    // Street Details validation
    if (_streetDetailsController.text.trim().isEmpty) {
      errors['streetDetails'] = 'Street details are required';
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.trim().isEmpty) {
      errors['password'] = 'Password is required';
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
      isValid = false;
    }

    // Confirm password validation
    if (_confirmPasswordController.text.trim().isEmpty) {
      errors['confirmPassword'] = 'Please confirm your password';
      isValid = false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      errors['confirmPassword'] = 'Passwords do not match';
      isValid = false;
    }

    setState(() {
      _nameError = errors['name'];
      _emailError = errors['email'];
      _barangayError = errors['barangay'];
      _streetDetailsError = errors['streetDetails'];
      _passwordError = errors['password'];
      _confirmPasswordError = errors['confirmPassword'];
    });

    return isValid;
  }

  Future<void> _handleSignUp() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Integrate with Supabase or your authentication service
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Combine barangay and street details into full address
      final fullAddress =
          '${_streetDetailsController.text.trim()}, ${_selectedBarangay!.trim()}';

      // Simulate successful registration
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful!'),
          content: Text(
            'Welcome to E-Telly, ${_nameController.text.trim()}!\n\n'
            'Please check your email (${_emailController.text.trim()}) '
            'to verify your account before signing in.\n\n'
            'Address: $fullAddress',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                if (widget.onSignUpSuccess != null) {
                  widget.onSignUpSuccess!();
                } else if (widget.onLoginPressed != null) {
                  widget.onLoginPressed!();
                } else {
                  Navigator.pop(context); // Go back
                }
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Error'),
          content: Text(
            error.toString().contains('already registered')
                ? 'This email is already registered. Please use a different email or sign in.'
                : 'An unexpected error occurred. Please try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateField(String field, String value) {
    // Clear error when user starts typing
    setState(() {
      switch (field) {
        case 'name':
          _nameError = null;
          break;
        case 'email':
          _emailError = null;
          break;
        case 'streetDetails':
          _streetDetailsError = null;
          break;
        case 'password':
          _passwordError = null;
          break;
        case 'confirmPassword':
          _confirmPasswordError = null;
          break;
      }
    });
  }

  void _selectBarangay(String barangay) {
    setState(() {
      _selectedBarangay = barangay;
      _barangayError = null;
      _showBarangayModal = false;
    });
  }

  String _getBarangayDisplayText() {
    return _selectedBarangay ?? 'Select barangay';
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String fieldName,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onTogglePassword,
    bool isRequired = true,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? '*' : ''}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: EdgeInsets.zero,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? const Color(0xFFDC2626) : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPassword && !showPassword,
                  keyboardType: keyboardType,
                  enabled: enabled && !_isLoading,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _getHintText(fieldName),
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  onChanged: (value) => _updateField(fieldName, value),
                ),
              ),
              if (isPassword && onTogglePassword != null)
                IconButton(
                  onPressed: enabled && !_isLoading ? onTogglePassword : null,
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFDC2626),
            ),
          ),
        ],
        if (fieldName == 'password') ...[
          const SizedBox(height: 6),
          const Text(
            'Must be at least 6 characters long.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ],
    );
  }

  String _getHintText(String fieldName) {
    switch (fieldName) {
      case 'name':
        return 'Enter your full name';
      case 'email':
        return 'Enter your email';
      case 'streetDetails':
        return 'House number, street, building, etc.';
      case 'password':
        return '6+ characters';
      case 'confirmPassword':
        return 'Confirm password';
      default:
        return '';
    }
  }

  Widget _buildBarangaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barangay*',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isLoading ? null : () => setState(() => _showBarangayModal = true),
          child: Container(
            margin: EdgeInsets.zero,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _barangayError != null ? const Color(0xFFDC2626) : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getBarangayDisplayText(),
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedBarangay == null
                          ? const Color(0xFF9CA3AF)
                          : Colors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        if (_barangayError != null) ...[
          const SizedBox(height: 6),
          Text(
            _barangayError!,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFDC2626),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBarangayModal() {
    return ModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Barangay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF666666)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available for:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ..._barangays.map((barangay) {
              final isSelected = _selectedBarangay == barangay['value'];
              return GestureDetector(
                onTap: () => _selectBarangay(barangay['value']!),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFDC2626).withOpacity(0.1)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFDC2626)
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: isSelected
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF666666),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          barangay['name']!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFFDC2626)
                                : Colors.black,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Color(0xFFDC2626),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: _safePadding(horizontal: 20),
            child: Column(
              children: [
                // Header
                Container(
                  margin: _safeMargin(top: 20, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (widget.onBackPressed != null) {
                                  widget.onBackPressed!();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      const SizedBox(width: 48), // For balance
                    ],
                  ),
                ),

                // Form
                Column(
                  children: [
                    // Name
                    _buildInputField(
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      controller: _nameController,
                      fieldName: 'name',
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 15),

                    // Email
                    _buildInputField(
                      label: 'Email Address',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      fieldName: 'email',
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 15),

                    // Barangay Selector
                    _buildBarangaySelector(),
                    const SizedBox(height: 15),

                    // Street Details
                    _buildInputField(
                      label: 'Street/Building Details',
                      icon: Icons.home_outlined,
                      controller: _streetDetailsController,
                      fieldName: 'streetDetails',
                      errorText: _streetDetailsError,
                    ),
                    const SizedBox(height: 15),

                    // Password
                    _buildInputField(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      fieldName: 'password',
                      isPassword: true,
                      showPassword: _showPassword,
                      onTogglePassword: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password
                    _buildInputField(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                      fieldName: 'confirmPassword',
                      isPassword: true,
                      showPassword: _showConfirmPassword,
                      onTogglePassword: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                      errorText: _confirmPasswordError,
                    ),
                    const SizedBox(height: 25),

                    // Sign Up Button with Gradient
                    Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Link
                    Container(
                      margin: _safeMargin(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    if (widget.onLoginPressed != null) {
                                      widget.onLoginPressed!();
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _streetDetailsController.dispose();
    super.dispose();
  }
}

// Custom ModalBottomSheet widget
class ModalBottomSheet extends StatelessWidget {
  final BuildContext context;
  final bool isScrollControlled;
  final Color backgroundColor;
  final WidgetBuilder builder;

  const ModalBottomSheet({
    Key? key,
    required this.context,
    this.isScrollControlled = false,
    this.backgroundColor = Colors.transparent,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void show() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: builder,
    );
  }
}
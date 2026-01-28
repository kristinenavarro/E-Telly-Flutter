import 'package:flutter/material.dart';

class Config {
  final String background_color;
  final String surface_color;
  final String text_color;
  final String primary_action_color;
  final String secondary_action_color;
  final String font_family;
  final double font_size;
  final String app_title;
  final String tagline;
  final String feature_1_title;
  final String feature_1_description;
  final String feature_2_title;
  final String feature_2_description;
  final String feature_3_title;
  final String feature_3_description;
  final String primary_button_text;
  final String secondary_button_text;

  Config({
    required this.background_color,
    required this.surface_color,
    required this.text_color,
    required this.primary_action_color,
    required this.secondary_action_color,
    required this.font_family,
    required this.font_size,
    required this.app_title,
    required this.tagline,
    required this.feature_1_title,
    required this.feature_1_description,
    required this.feature_2_title,
    required this.feature_2_description,
    required this.feature_3_title,
    required this.feature_3_description,
    required this.primary_button_text,
    required this.secondary_button_text,
  });
}

class WelcomeScreen extends StatefulWidget {
  final Config? config;
  final Function(Config)? onConfigChange;

  const WelcomeScreen({super.key, this.config, this.onConfigChange});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final defaultConfig = Config(
    background_color: "#FFFFFF",
    surface_color: "#F8FAFC",
    text_color: "#DC2626",
    primary_action_color: "#DC2626",
    secondary_action_color: "#EF4444",
    font_family: "Roboto",
    font_size: 16,
    app_title: "E-Telly",
    tagline: "Stay Safe, Stay Informed",
    feature_1_title: "Real-Time Alerts",
    feature_1_description: "Receive instant notifications about disasters in your area",
    feature_2_title: "Emergency Resources",
    feature_2_description: "Quick access to shelters, hospitals, and emergency contacts",
    feature_3_title: "Safety Tips",
    feature_3_description: "Expert guidance on how to prepare and respond to emergencies",
    primary_button_text: "Get Started",
    secondary_button_text: "Learn More",
  );

  late Config config;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _feature1Anim;
  late Animation<double> _feature2Anim;
  late Animation<double> _feature3Anim;
  late Animation<double> _buttonAnim;

  @override
  void initState() {
    super.initState();
    config = widget.config ?? defaultConfig;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Create staggered animations
    _feature1Anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _feature2Anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _feature3Anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _buttonAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _parseColor(String color) {
    return Color(int.parse(color.replaceAll('#', '0xFF')));
  }

  void _handlePrimaryButtonPress() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _parseColor(config.background_color),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              children: [
                // Logo and Title Section
                AnimatedBuilder(
                  animation: _fadeAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - _fadeAnim.value)),
                      child: Opacity(
                        opacity: _fadeAnim.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildLogoSection(),
                ),
                const SizedBox(height: 20),
                // Features List
                Column(
                  children: [
                    // Feature 1
                    _buildFeatureItem(
                      animation: _feature1Anim,
                      icon: Icons.notifications,
                      title: config.feature_1_title,
                      description: config.feature_1_description,
                    ),
                    const SizedBox(height: 18),
                    // Feature 2
                    _buildFeatureItem(
                      animation: _feature2Anim,
                      icon: Icons.local_hospital,
                      title: config.feature_2_title,
                      description: config.feature_2_description,
                    ),
                    const SizedBox(height: 18),
                    // Feature 3
                    _buildFeatureItem(
                      animation: _feature3Anim,
                      icon: Icons.security,
                      title: config.feature_3_title,
                      description: config.feature_3_description,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // CTA Button
                AnimatedBuilder(
                  animation: _buttonAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - _buttonAnim.value)),
                      child: Opacity(
                        opacity: _buttonAnim.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildButtonSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo Container - FIXED: Changed from negative margin to Transform.translate
        Transform.translate(
          offset: const Offset(0, -30),
          child: Image.asset(
            'assets/logo3.png',
            width: 240,
            height: 240,
            fit: BoxFit.contain,
          ),
        ),
        // App Title
        Text(
          config.app_title,
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: _parseColor(config.text_color),
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
        // Tagline
        Text(
          config.tagline,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required Animation<double> animation,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 64,
            height: 64,
            margin: EdgeInsets.zero, // Explicitly zero margin
            decoration: BoxDecoration(
              color: _parseColor(config.surface_color),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: _parseColor(config.primary_action_color),
            ),
          ),
          const SizedBox(width: 16),
          // Text Container
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _parseColor(config.text_color),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    height: 1.375,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handlePrimaryButtonPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: _parseColor(config.primary_action_color),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 8,
          shadowColor: _parseColor(config.primary_action_color).withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
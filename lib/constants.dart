// lib/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryOrange = Color(0xFFF59E0B);
  static const Color primaryGreen = Color(0xFF10B981);
  
  // Neutral Colors
  static const Color darkGray = Color(0xFF1F2937);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFFE5E7EB);
  static const Color backgroundGray = Color(0xFFF9FAFB);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  
  // Alert Type Colors
  static const Color flood = Color(0xFF06B6D4);
  static const Color rain = Color(0xFF3B82F6);
  static const Color evacuate = Color(0xFFDC2626);
  static const Color waterLevel = Color(0xFF8B5CF6);
  static const Color typhoon = Color(0xFFF59E0B);
  static const Color earthquake = Color(0xFFF59E0B);
  static const Color fire = Color(0xFFDC2626);
  static const Color medical = Color(0xFF10B981);
  static const Color defaultAlert = Color(0xFF666666);
}

class AppConstants {
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
}

class AppTextStyles {
  static const TextStyle headerTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
  );
  
  static const TextStyle headerSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.mediumGray,
  );
  
  static const TextStyle alertTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGray,
  );
  
  static const TextStyle alertMessage = TextStyle(
    fontSize: 14,
    color: AppColors.mediumGray,
    height: 1.4,
  );
  
  static const TextStyle alertLocation = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGray,
  );
  
  static const TextStyle alertType = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle alertTimestamp = TextStyle(
    fontSize: 12,
    color: AppColors.mediumGray,
  );
}
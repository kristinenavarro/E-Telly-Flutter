import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/alerts_screen.dart';  
import 'screens/evacuation_map_screen.dart';
import 'screens/flood_monitoring_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/report_emergency_screen.dart';
import 'screens/safety_tips_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Telly',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDC2626),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/alerts': (context) => AlertsScreen(),  
        '/evacuation-map': (context) => EvacuationMapScreen(),  
        '/flood-monitor': (context) => const FloodMonitoringScreen(),
        '/resources': (context) => const ResourcesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/report-emergency': (context) => const ReportEmergencyScreen(),
        '/safety-tips': (context) => SafetyTipsScreen(), 
      },
    );
  }
}
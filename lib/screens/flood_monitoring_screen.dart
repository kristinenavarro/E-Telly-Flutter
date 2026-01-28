import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class FloodMonitoringScreen extends StatefulWidget {
  const FloodMonitoringScreen({super.key});

  @override
  _FloodMonitoringScreenState createState() => _FloodMonitoringScreenState();
}

// Data Models
class MonitoringStation {
  final String id;
  final String name;
  final String location;
  final double currentLevel;
  final double maxCapacity;
  final String status;
  final String trend;
  final String lastUpdated;
  final double posX;
  final double posY;
  final String areaName;

  MonitoringStation({
    required this.id,
    required this.name,
    required this.location,
    required this.currentLevel,
    required this.maxCapacity,
    required this.status,
    required this.trend,
    required this.lastUpdated,
    required this.posX,
    required this.posY,
    required this.areaName,
  });
}

class FloodArea {
  final String id;
  final String name;
  final String status;
  final double waterLevel;
  final int affectedHouses;
  final double posX;
  final double posY;
  final double size;

  FloodArea({
    required this.id,
    required this.name,
    required this.status,
    required this.waterLevel,
    required this.affectedHouses,
    required this.posX,
    required this.posY,
    required this.size,
  });
}

class EvacuationCenter {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final int currentOccupants;
  final double posX;
  final double posY;
  final String contact;

  EvacuationCenter({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.currentOccupants,
    required this.posX,
    required this.posY,
    required this.contact,
  });
}

class _FloodMonitoringScreenState extends State<FloodMonitoringScreen> {
  String _activeTab = 'map';
  bool _loading = false;
  double _mapScale = 1.0;
  Offset _mapOffset = Offset(0, 0);
  bool _isDragging = false;
  Offset _lastOffset = Offset.zero;

  // Colors
  static const Color safeColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color dangerColor = Color(0xFFDC2626);
  static const Color criticalColor = Color(0xFFB91C1C);
  static const Color mainCenterColor = Color(0xFFDC2626);
  static const Color secondaryCenterColor = Color(0xFFF59E0B);
  static const Color medicalCenterColor = Color(0xFF3B82F6);

  // Flood areas data
  final List<FloodArea> _floodAreas = [
    FloodArea(
      id: '1',
      name: 'Tanza 1 & 2',
      status: 'critical',
      waterLevel: 2.1,
      affectedHouses: 150,
      posX: 100,
      posY: 150,
      size: 100,
    ),
    FloodArea(
      id: '2',
      name: 'Daanghari Riverside',
      status: 'danger',
      waterLevel: 1.8,
      affectedHouses: 85,
      posX: 200,
      posY: 250,
      size: 80,
    ),
    FloodArea(
      id: '3',
      name: 'Bangkulasi Coastal',
      status: 'warning',
      waterLevel: 1.3,
      affectedHouses: 45,
      posX: 300,
      posY: 100,
      size: 70,
    ),
    FloodArea(
      id: '4',
      name: 'San Roque Urban',
      status: 'safe',
      waterLevel: 0.5,
      affectedHouses: 12,
      posX: 150,
      posY: 350,
      size: 60,
    ),
    FloodArea(
      id: '5',
      name: 'Tangos West',
      status: 'safe',
      waterLevel: 0.3,
      affectedHouses: 8,
      posX: 250,
      posY: 400,
      size: 50,
    ),
  ];

  // Evacuation centers data
  final List<EvacuationCenter> _evacuationCenters = [
    EvacuationCenter(
      id: 'ec1',
      name: 'Navotas City Hall',
      type: 'main',
      capacity: 500,
      currentOccupants: 320,
      posX: 400,
      posY: 200,
      contact: '02883111',
    ),
    EvacuationCenter(
      id: 'ec2',
      name: 'Tanza Elementary School',
      type: 'main',
      capacity: 300,
      currentOccupants: 150,
      posX: 350,
      posY: 300,
      contact: '02883222',
    ),
    EvacuationCenter(
      id: 'ec3',
      name: 'Daanghari Health Center',
      type: 'medical',
      capacity: 100,
      currentOccupants: 45,
      posX: 250,
      posY: 200,
      contact: '02883333',
    ),
    EvacuationCenter(
      id: 'ec4',
      name: 'Bangkulasi Covered Court',
      type: 'secondary',
      capacity: 200,
      currentOccupants: 80,
      posX: 300,
      posY: 50,
      contact: '02883444',
    ),
    EvacuationCenter(
      id: 'ec5',
      name: 'San Roque Church',
      type: 'secondary',
      capacity: 150,
      currentOccupants: 60,
      posX: 150,
      posY: 450,
      contact: '02883555',
    ),
  ];

  // Monitoring stations data
  List<MonitoringStation> _stations = [
    MonitoringStation(
      id: '1',
      name: 'Navotas River Gauge',
      location: 'Navotas River, Tanza',
      currentLevel: 2.3,
      maxCapacity: 3.0,
      status: 'critical',
      trend: 'rising',
      lastUpdated: '15 min ago',
      posX: 120,
      posY: 170,
      areaName: 'Tanza',
    ),
    MonitoringStation(
      id: '2',
      name: 'Daanghari Station',
      location: 'North Bay Blvd South',
      currentLevel: 1.8,
      maxCapacity: 2.5,
      status: 'danger',
      trend: 'rising',
      lastUpdated: '20 min ago',
      posX: 220,
      posY: 270,
      areaName: 'Daanghari',
    ),
    MonitoringStation(
      id: '3',
      name: 'Bangkulasi Station',
      location: 'Coastal Area',
      currentLevel: 1.5,
      maxCapacity: 2.0,
      status: 'warning',
      trend: 'stable',
      lastUpdated: '25 min ago',
      posX: 320,
      posY: 120,
      areaName: 'Bangkulasi',
    ),
    MonitoringStation(
      id: '4',
      name: 'San Roque Station',
      location: 'Urban Area',
      currentLevel: 1.2,
      maxCapacity: 1.8,
      status: 'safe',
      trend: 'falling',
      lastUpdated: '30 min ago',
      posX: 170,
      posY: 370,
      areaName: 'San Roque',
    ),
    MonitoringStation(
      id: '5',
      name: 'Tangos Station',
      location: 'Navotas West',
      currentLevel: 0.9,
      maxCapacity: 1.5,
      status: 'safe',
      trend: 'stable',
      lastUpdated: '35 min ago',
      posX: 270,
      posY: 420,
      areaName: 'Tangos',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'safe':
        return safeColor;
      case 'warning':
        return warningColor;
      case 'danger':
        return dangerColor;
      case 'critical':
        return criticalColor;
      default:
        return Colors.grey;
    }
  }

  Color _getCenterTypeColor(String type) {
    switch (type) {
      case 'main':
        return mainCenterColor;
      case 'secondary':
        return secondaryCenterColor;
      case 'medical':
        return medicalCenterColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'safe':
        return 'SAFE';
      case 'warning':
        return 'WARNING';
      case 'danger':
        return 'DANGER';
      case 'critical':
        return 'CRITICAL';
      default:
        return 'UNKNOWN';
    }
  }

  void _handleAreaPress(FloodArea area) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(area.name, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow('🌊 Water Level', '${area.waterLevel}m'),
            _buildInfoRow('🏠 Affected Houses', area.affectedHouses.toString()),
            _buildInfoRow('🏷️ Status', _getStatusText(area.status)),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(area.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getStatusColor(area.status)),
              ),
              child: Text(
                area.status == 'critical'
                    ? '🚨 IMMEDIATE EVACUATION\nFlood depth: Chest-high'
                    : area.status == 'danger'
                        ? '⚠️ HIGH RISK AREA\nFlood depth: Waist-high'
                        : area.status == 'warning'
                            ? '🔔 MONITOR CLOSELY\nFlood depth: Knee-high'
                            : '✅ LOW RISK\nFlood depth: Ankle-deep',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final url = 'https://www.google.com/maps/search/?api=1&query=Navotas+${area.name.replaceAll(' ', '+')}';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Get Directions'),
          ),
        ],
      ),
    );
  }

  void _handleStationPress(MonitoringStation station) {
    final percentage = (station.currentLevel / station.maxCapacity) * 100;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(station.name, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow('📍 Location', station.location),
            SizedBox(height: 8),
            _buildInfoRow('🌊 Current Level', '${station.currentLevel}m'),
            _buildInfoRow('📏 Max Capacity', '${station.maxCapacity}m'),
            _buildInfoRow('📈 Trend', station.trend.toUpperCase()),
            _buildInfoRow('⏰ Last Updated', station.lastUpdated),
            _buildInfoRow('🏷️ Status', _getStatusText(station.status)),
            SizedBox(height: 12),
            
            // Water Level Visualization with Red Line
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50]!,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Water Level',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${station.currentLevel}m / ${station.maxCapacity}m',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(station.status),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // Visual Indicator
                  Stack(
                    children: [
                      // Background (Max Capacity)
                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue[50]!,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                      ),
                      
                      // Current Level Fill
                      Container(
                        height: 30,
                        width: (station.currentLevel / station.maxCapacity) * MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.blue[100]!,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      
                      // Current Level Red Line
                      Positioned(
                        left: (station.currentLevel / station.maxCapacity) * MediaQuery.of(context).size.width * 0.6 - 1,
                        child: Container(
                          width: 2,
                          height: 30,
                          color: _getStatusColor(station.status),
                        ),
                      ),
                      
                      // Current Level Indicator (Triangle)
                      Positioned(
                        left: (station.currentLevel / station.maxCapacity) * MediaQuery.of(context).size.width * 0.6 - 5,
                        top: 30,
                        child: Container(
                          width: 0,
                          height: 0,
                          child: CustomPaint(
                            size: Size(10, 8),
                            painter: _TrianglePainter(color: _getStatusColor(station.status)),
                          ),
                        ),
                      ),
                      
                      // Current Level Label
                      Positioned(
                        left: (station.currentLevel / station.maxCapacity) * MediaQuery.of(context).size.width * 0.6 - 20,
                        top: 40,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(station.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${station.currentLevel}m',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      // Start and End Labels
                      Positioned(
                        left: 0,
                        bottom: -20,
                        child: Text(
                          '0m',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]!),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: -20,
                        child: Text(
                          '${station.maxCapacity}m',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Progress Bar
                  LinearProgressIndicator(
                    value: station.currentLevel / station.maxCapacity,
                    backgroundColor: Colors.grey[200]!,
                    valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(station.status)),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}% of capacity',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]!),
                    ),
                  ),
                ],
              ),
            ),
            
            // Warning Message
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(station.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getStatusColor(station.status)),
              ),
              child: Text(
                station.status == 'critical'
                    ? '🚨 CRITICAL - Immediate action required'
                    : station.status == 'danger'
                        ? '⚠️ DANGER - High flood risk'
                        : station.status == 'warning'
                            ? '🔔 WARNING - Monitor closely'
                            : '✅ SAFE - Normal conditions',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: _getStatusColor(station.status),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getStatusColor(station.status),
            ),
            child: Text('View Details'),
          ),
        ],
      ),
    );
  }

  void _handleCenterPress(EvacuationCenter center) {
    final occupancyPercent = ((center.currentOccupants / center.capacity) * 100);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(center.name, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getCenterTypeColor(center.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getCenterTypeColor(center.type)),
              ),
              child: Text(
                '${center.type.toUpperCase()} CENTER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: _getCenterTypeColor(center.type),
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow('🏠 Capacity', '${center.capacity} people'),
            _buildInfoRow('👥 Current Occupants', '${center.currentOccupants}'),
            _buildInfoRow('📞 Contact', center.contact),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: center.currentOccupants / center.capacity,
              backgroundColor: Colors.grey[200]!,
              valueColor: AlwaysStoppedAnimation<Color>(
                occupancyPercent > 90
                    ? criticalColor
                    : occupancyPercent > 70
                        ? warningColor
                        : safeColor,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 8),
            Text(
              '${occupancyPercent.toStringAsFixed(0)}% occupied',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]!),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: occupancyPercent > 90
                    ? criticalColor.withOpacity(0.1)
                    : occupancyPercent > 70
                        ? warningColor.withOpacity(0.1)
                        : safeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: occupancyPercent > 90
                      ? criticalColor
                      : occupancyPercent > 70
                          ? warningColor
                          : safeColor,
                ),
              ),
              child: Text(
                occupancyPercent > 90
                    ? '🚨 NEAR CAPACITY - Limited space available'
                    : occupancyPercent > 70
                        ? '⚠️ MODERATELY FULL'
                        : '✅ SPACES AVAILABLE',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final url = 'https://www.google.com/maps/search/?api=1&query=${center.name.replaceAll(' ', '+')}+Navotas';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getCenterTypeColor(center.type),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Get Directions'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700]!,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]!,
            ),
          ),
        ],
      )
    );
  }

  void _handleRefresh() {
    setState(() {
      _loading = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      final random = Random(); // Create Random instance once
      
      setState(() {
        // Update stations with random values
        _stations = _stations.map((station) {
          double newLevelValue = station.currentLevel + (random.nextDouble() - 0.5) * 0.2;
          
          // Ensure it's within bounds using double values
          if (newLevelValue < 0) newLevelValue = 0;
          if (newLevelValue > station.maxCapacity) newLevelValue = station.maxCapacity;
          
          final percentage = (newLevelValue / station.maxCapacity) * 100;
          String status;
          
          if (percentage < 60) status = 'safe';
          else if (percentage < 75) status = 'warning';
          else if (percentage < 90) status = 'danger';
          else status = 'critical';
          
          return MonitoringStation(
            id: station.id,
            name: station.name,
            location: station.location,
            currentLevel: newLevelValue,
            maxCapacity: station.maxCapacity,
            status: status,
            trend: station.trend,
            lastUpdated: 'Just now',
            posX: station.posX,
            posY: station.posY,
            areaName: station.areaName,
          );
        }).toList();

        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Monitoring data updated successfully!'),
          backgroundColor: safeColor,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  int get _criticalAlertsCount {
    return _stations.where((s) => s.status == 'critical' || s.status == 'danger').length;
  }

  Widget _buildMapView() {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onScaleStart: (details) {
              _isDragging = true;
              _lastOffset = details.focalPoint;
            },
            onScaleUpdate: (details) {
              if (_isDragging) {
                setState(() {
                  _mapOffset += details.focalPoint - _lastOffset;
                  _lastOffset = details.focalPoint;
                });
              }
            },
            onScaleEnd: (details) {
              _isDragging = false;
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Background grid
                    CustomPaint(
                      painter: _GridPainter(),
                    ),
                    
                    // Rivers/waterways
                    Positioned(
                      left: 50,
                      top: 100,
                      child: _buildWaterway(150, 300, 30),
                    ),
                    Positioned(
                      left: 200,
                      top: 200,
                      child: _buildWaterway(100, 200, 25),
                    ),
                    
                    // Flood areas
                    for (final area in _floodAreas)
                      Positioned(
                        left: area.posX + _mapOffset.dx,
                        top: area.posY + _mapOffset.dy,
                        child: GestureDetector(
                          onTap: () => _handleAreaPress(area),
                          child: Transform.scale(
                            scale: _mapScale,
                            child: Container(
                              width: area.size,
                              height: area.size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(area.status).withOpacity(0.3),
                                border: Border.all(
                                  color: _getStatusColor(area.status),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(area.status).withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    area.name.split(' ')[0],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(area.status),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Monitoring stations
                    for (final station in _stations)
                      Positioned(
                        left: station.posX + _mapOffset.dx,
                        top: station.posY + _mapOffset.dy,
                        child: GestureDetector(
                          onTap: () => _handleStationPress(station),
                          child: Transform.scale(
                            scale: _mapScale,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(station.status),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.water_drop,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Map controls
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        children: [
                          _buildMapControlButton(
                            icon: Icons.add,
                            onPressed: () => setState(() => _mapScale = (_mapScale * 1.2).clamp(0.5, 3.0)),
                          ),
                          SizedBox(height: 8),
                          _buildMapControlButton(
                            icon: Icons.remove,
                            onPressed: () => setState(() => _mapScale = (_mapScale / 1.2).clamp(0.5, 3.0)),
                          ),
                          SizedBox(height: 8),
                          _buildMapControlButton(
                            icon: Icons.center_focus_strong,
                            onPressed: () => setState(() {
                              _mapOffset = Offset.zero;
                              _mapScale = 1.0;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildMapLegend(isEvacMap: false),
      ],
    );
  }

  Widget _buildWaterway(double width, double height, double curve) {
    return CustomPaint(
      size: Size(width, height),
      painter: _WaterwayPainter(curve: curve),
    );
  }

  Widget _buildMapControlButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.blue[700]!),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEvacMapView() {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onScaleStart: (details) {
              _isDragging = true;
              _lastOffset = details.focalPoint;
            },
            onScaleUpdate: (details) {
              if (_isDragging) {
                setState(() {
                  _mapOffset += details.focalPoint - _lastOffset;
                  _lastOffset = details.focalPoint;
                });
              }
            },
            onScaleEnd: (details) {
              _isDragging = false;
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFEF3C7), Color(0xFFFEFCE8)],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Background grid
                    CustomPaint(
                      painter: _GridPainter(color: Colors.orange[100]!),
                    ),
                    
                    // Roads
                    Positioned(
                      left: 50,
                      top: 200,
                      child: _buildRoad(300, 8, 'Main Highway'),
                    ),
                    Positioned(
                      left: 150,
                      top: 100,
                      child: _buildRoad(8, 200, '', isVertical: true),
                    ),
                    Positioned(
                      left: 250,
                      top: 300,
                      child: _buildRoad(8, 150, '', isVertical: true),
                    ),
                    
                    // Evacuation centers
                    for (final center in _evacuationCenters)
                      Positioned(
                        left: center.posX + _mapOffset.dx,
                        top: center.posY + _mapOffset.dy,
                        child: GestureDetector(
                          onTap: () => _handleCenterPress(center),
                          child: Transform.scale(
                            scale: _mapScale,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getCenterTypeColor(center.type),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  center.type == 'medical' 
                                    ? Icons.medical_services
                                    : center.type == 'main'
                                      ? Icons.account_balance
                                      : Icons.church,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Critical flood areas
                    for (final area in _floodAreas.where((a) => a.status == 'critical' || a.status == 'danger'))
                      Positioned(
                        left: area.posX + _mapOffset.dx,
                        top: area.posY + _mapOffset.dy,
                        child: Transform.scale(
                          scale: _mapScale,
                          child: Container(
                            width: area.size * 0.8,
                            height: area.size * 0.8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(area.status).withOpacity(0.4),
                              border: Border.all(
                                color: _getStatusColor(area.status),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.warning,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Evacuation routes (lines connecting areas to centers)
                    for (final area in _floodAreas.where((a) => a.status == 'critical' || a.status == 'danger'))
                      for (final center in _evacuationCenters)
                        if ((area.posX - center.posX).abs() < 200 && (area.posY - center.posY).abs() < 200)
                          CustomPaint(
                            painter: _RoutePainter(
                              start: Offset(area.posX + area.size/2 + _mapOffset.dx, 
                                          area.posY + area.size/2 + _mapOffset.dy),
                              end: Offset(center.posX + 25 + _mapOffset.dx, 
                                         center.posY + 25 + _mapOffset.dy),
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                    
                    // Map controls
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        children: [
                          _buildMapControlButton(
                            icon: Icons.add,
                            onPressed: () => setState(() => _mapScale = (_mapScale * 1.2).clamp(0.5, 3.0)),
                          ),
                          SizedBox(height: 8),
                          _buildMapControlButton(
                            icon: Icons.remove,
                            onPressed: () => setState(() => _mapScale = (_mapScale / 1.2).clamp(0.5, 3.0)),
                          ),
                          SizedBox(height: 8),
                          _buildMapControlButton(
                            icon: Icons.center_focus_strong,
                            onPressed: () => setState(() {
                              _mapOffset = Offset.zero;
                              _mapScale = 1.0;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildMapLegend(isEvacMap: true),
        SizedBox(height: 12),
        _buildRouteStatus(),
      ],
    );
  }

  Widget _buildRoad(double width, double height, String label, {bool isVertical = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300]!,
        border: Border.all(color: Colors.grey[500]!, width: 1),
      ),
      child: label.isNotEmpty
          ? Center(
              child: Transform.rotate(
                angle: isVertical ? 1.5708 : 0,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]!,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMapLegend({required bool isEvacMap}) {
    final List<Map<String, dynamic>> legendItems = isEvacMap
        ? [
            {'color': mainCenterColor, 'label': 'Main Center'},
            {'color': secondaryCenterColor, 'label': 'Secondary'},
            {'color': medicalCenterColor, 'label': 'Medical'},
            {'color': criticalColor, 'label': 'Critical Area'},
          ]
        : [
            {'color': safeColor, 'label': 'Safe'},
            {'color': warningColor, 'label': 'Warning'},
            {'color': dangerColor, 'label': 'Danger'},
            {'color': criticalColor, 'label': 'Critical'},
          ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEvacMap ? 'Evacuation Map Legend' : 'Flood Status Legend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: legendItems.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: item['color'],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStatus() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.route, size: 20, color: Color(0xFF1F2937)),
              SizedBox(width: 8),
              Text(
                'Route Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRouteCard('Main Evacuation Route', 'open', 1.2),
                SizedBox(width: 12),
                _buildRouteCard('Daanghari Emergency Route', 'congested', 0.8),
                SizedBox(width: 12),
                _buildRouteCard('Coastal Evacuation Path', 'open', 0.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(String name, String status, double distance) {
    Color statusColor;
    switch (status) {
      case 'open':
        statusColor = safeColor;
        break;
      case 'congested':
        statusColor = warningColor;
        break;
      case 'closed':
        statusColor = dangerColor;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      width: 180,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.directions, size: 14, color: Colors.grey[600]!),
                  SizedBox(width: 4),
                  Text(
                    '${distance} km',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFEF2F2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 24),
                      onPressed: () => Navigator.pop(context),
                      color: Color(0xFF1F2937),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Flood Monitoring',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Real-time Water Levels & Evacuation',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: _loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(dangerColor),
                              ),
                            )
                          : Icon(Icons.refresh, size: 24),
                      onPressed: _handleRefresh,
                      color: dangerColor,
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTab(
                        icon: Icons.map,
                        label: 'Flood Map',
                        isActive: _activeTab == 'map',
                        onTap: () => setState(() => _activeTab = 'map'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTab(
                        icon: Icons.exit_to_app,
                        label: 'Evac Map',
                        isActive: _activeTab == 'evac',
                        onTap: () => setState(() => _activeTab = 'evac'),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Summary Stats
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.warning,
                        count: _criticalAlertsCount,
                        label: 'Critical Alerts',
                        color: dangerColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.exit_to_app,
                        count: _evacuationCenters.length,
                        label: 'Centers',
                        color: warningColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.water_drop,
                        count: _stations.length,
                        label: 'Stations',
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Map Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _activeTab == 'map' ? _buildMapView() : _buildEvacMapView(),
                ),
              ),
              
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFFFEE2E2) : Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? dangerColor : Color(0xFFE5E7EB),
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: dangerColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? dangerColor : Color(0xFF6B7280),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? dangerColor : Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, size: 16, color: color),
                ),
              ),
              SizedBox(width: 6),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  
  _GridPainter({this.color = const Color(0xFFE0E0E0)});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WaterwayPainter extends CustomPainter {
  final double curve;
  
  _WaterwayPainter({required this.curve});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF3B82F6).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..cubicTo(
        curve, 0,
        size.width - curve, size.height,
        size.width, size.height / 2,
      )
      ..cubicTo(
        size.width - curve, size.height,
        curve, 0,
        0, size.height / 2,
      );
    
    canvas.drawPath(path, paint);
    
    // Add some wave lines
    final wavePaint = Paint()
      ..color = Color(0xFF2563EB).withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < 3; i++) {
      final wavePath = Path()
        ..moveTo(0, size.height / 2 + i * 5)
        ..cubicTo(
          curve, i * 5,
          size.width - curve, size.height - i * 5,
          size.width, size.height / 2 + i * 5,
        );
      canvas.drawPath(wavePath, wavePaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  
  _RoutePainter({
    required this.start,
    required this.end,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final dashPath = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
    
    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Create dashed line effect
    final pathMetrics = dashPath.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        final startOffset = pathMetric.getTangentForOffset(distance)!.position;
        distance += 10;
        if (distance > pathMetric.length) break;
        final endOffset = pathMetric.getTangentForOffset(distance)!.position;
        distance += 5; // gap
        canvas.drawLine(startOffset, endOffset, dashPaint);
      }
    }
    
    // Draw arrow at the end
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final arrowSize = 10.0;
    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * cos(angle - pi / 6),
        end.dy - arrowSize * sin(angle - pi / 6),
      )
      ..lineTo(
        end.dx - arrowSize * cos(angle + pi / 6),
        end.dy - arrowSize * sin(angle + pi / 6),
      )
      ..close();
    
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(arrowPath, arrowPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  
  _TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
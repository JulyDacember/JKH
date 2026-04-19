import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/user.dart';
import '../../models/meter.dart';
import '../../models/activity.dart';
import '../../widgets/header.dart';
import 'widgets/meter_card.dart';
import 'widgets/quick_capture_card.dart';
import '../activity/recent_activity_screen.dart';

class MeterReadingsScreen extends StatefulWidget {
  const MeterReadingsScreen({super.key});

  @override
  State<MeterReadingsScreen> createState() => _MeterReadingsScreenState();
}

class _MeterReadingsScreenState extends State<MeterReadingsScreen> {
  late User _currentUser;
  late List<Meter> _meters;
  late List<Activity> _recentActivities;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _currentUser = MockDataService.getCurrentUser();
    _meters = MockDataService.getMeters();
    _pendingCount = MockDataService.getPendingMeterCount();
    _recentActivities = MockDataService.getRecentActivities().take(1).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(user: _currentUser, showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: 'Make Payment',
                          onTap: () {
                            // TODO: Navigate to payment
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          label: 'Emergency',
                          backgroundColor: const Color(0xFFEF4444),
                          onTap: () {
                            // TODO: Handle emergency
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Meter Readings Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meter Readings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      if (_pendingCount > 0)
                        Text(
                          '$_pendingCount pending',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFA500),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Quick Capture Card
                  QuickCaptureCard(),
                  const SizedBox(height: 16),
                  // Meter Cards
                  ..._meters.map((meter) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MeterCard(meter: meter),
                      )),
                  const SizedBox(height: 24),
                  // Recent Activity Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RecentActivityScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Recent Activity Card
                  if (_recentActivities.isNotEmpty)
                    _buildActivityCard(_recentActivities.first),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    Color backgroundColor = const Color(0xFF1E3A8A),
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.domain,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: activity.status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        activity.status.displayName,
                        style: TextStyle(
                          color: activity.status.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


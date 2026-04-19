import 'package:flutter/material.dart';
import '../../../models/request.dart';

class RequestsCard extends StatefulWidget {
  final List<MaintenanceRequest> requests;

  const RequestsCard({super.key, required this.requests});

  @override
  State<RequestsCard> createState() => _RequestsCardState();
}

class _RequestsCardState extends State<RequestsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _getCountByStatus(RequestStatus status) {
    return widget.requests.where((r) => r.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.requests.length;
    final pending = _getCountByStatus(RequestStatus.pending);
    final inProgress = _getCountByStatus(RequestStatus.inProgress);
    final completed = _getCountByStatus(RequestStatus.completed);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: total.toString(),
                label: 'Total',
                valueColor: const Color(0xFF1E3A8A),
              ),
              _buildStatItem(
                value: pending.toString(),
                label: 'Pending',
                valueColor: const Color(0xFFFFA500),
              ),
              _buildStatItem(
                value: inProgress.toString(),
                label: 'In Progress',
                valueColor: const Color(0xFF1E3A8A),
              ),
              _buildStatItem(
                value: completed.toString(),
                label: 'Completed',
                valueColor: const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}


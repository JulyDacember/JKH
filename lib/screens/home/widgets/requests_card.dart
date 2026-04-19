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
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

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

  @override
  Widget build(BuildContext context) {
    final statusCounts = _getRequestsCountByStatus();
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
            _buildHeader(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  value: statusCounts['total']!.toString(),
                  label: 'Total',
                  valueColor: const Color(0xFF1E3A8A),
                ),
                _buildStatItem(
                  value: statusCounts['pending']!.toString(),
                  label: 'Pending',
                  valueColor: const Color(0xFFFFA500),
                ),
                _buildStatItem(
                  value: statusCounts['inProgress']!.toString(),
                  label: 'In Progress',
                  valueColor: const Color(0xFF1E3A8A),
                ),
                _buildStatItem(
                  value: statusCounts['completed']!.toString(),
                  label: 'Completed',
                  valueColor: const Color(0xFF10B981),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _getRequestsCountByStatus() {
    final total = widget.requests.length;
    final pending =
        widget.requests.where((r) => r.status == RequestStatus.pending).length;
    final inProgress = widget.requests
        .where((r) => r.status == RequestStatus.inProgress)
        .length;
    final completed = widget.requests
        .where((r) => r.status == RequestStatus.completed)
        .length;

    return {
      'total': total,
      'pending': pending,
      'inProgress': inProgress,
      'completed': completed,
    };
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Active Requests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
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
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

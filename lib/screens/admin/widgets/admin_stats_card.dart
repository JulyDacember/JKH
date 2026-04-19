import 'package:flutter/material.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/request.dart';

class AdminStatsCard extends StatelessWidget {
  const AdminStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = MockDataService.getRequests();
    final users = [MockDataService.getCurrentUser()]; // В реальности список пользователей
    final balance = MockDataService.getCurrentBalance();
    final meters = MockDataService.getMeters();

    final pendingRequests = requests.where((r) => r.status.displayName == 'PENDING').length;
    final totalUsers = users.length;
    final overdueBalances = balance.amount > 0 ? 1 : 0; // Упрощенная логика
    final pendingMeters = MockDataService.getPendingMeterCount();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Общая статистика',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: requests.length.toString(),
                label: 'Заявок',
                color: const Color(0xFF3B82F6),
              ),
              _buildStatItem(
                value: pendingRequests.toString(),
                label: 'Ожидают',
                color: const Color(0xFFFFA500),
              ),
              _buildStatItem(
                value: totalUsers.toString(),
                label: 'Пользователей',
                color: const Color(0xFF10B981),
              ),
              _buildStatItem(
                value: overdueBalances.toString(),
                label: 'Просрочено',
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: meters.length.toString(),
                label: 'Счетчиков',
                color: const Color(0xFF8B5CF6),
              ),
              _buildStatItem(
                value: pendingMeters.toString(),
                label: 'Требуют чтения',
                color: const Color(0xFFF59E0B),
              ),
              _buildStatItem(
                value: '\$${balance.formattedAmount}',
                label: 'Общий баланс',
                color: const Color(0xFF06B6D4),
              ),
              _buildStatItem(
                value: '3',
                label: 'Активных',
                color: const Color(0xFF84CC16),
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
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
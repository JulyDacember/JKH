import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/user.dart';
import '../../widgets/header.dart';
import 'widgets/admin_stats_card.dart';
import 'widgets/admin_navigation_card.dart';
import 'admin_requests_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late User _currentUser;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _currentUser = MockDataService.getCurrentUser();
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
                  const Text(
                    'Админ панель',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Управление системой ЖКХ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Статистика
                  AdminStatsCard(),
                  const SizedBox(height: 24),
                  // Навигационные карточки
                  const Text(
                    'Управление',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      AdminNavigationCard(
                        title: 'Заявки',
                        subtitle: 'Просмотр и управление',
                        icon: Icons.description,
                        color: const Color(0xFF3B82F6),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AdminRequestsScreen()),
                          );
                        },
                      ),
                      AdminNavigationCard(
                        title: 'Пользователи',
                        subtitle: 'Управление жильцами',
                        icon: Icons.people,
                        color: const Color(0xFF10B981),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Управление пользователями - в разработке')),
                          );
                        },
                      ),
                      AdminNavigationCard(
                        title: 'Балансы',
                        subtitle: 'Финансовая информация',
                        icon: Icons.account_balance_wallet,
                        color: const Color(0xFFFFA500),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Управление балансами - в разработке')),
                          );
                        },
                      ),
                      AdminNavigationCard(
                        title: 'Тарифы',
                        subtitle: 'Управление ценами',
                        icon: Icons.price_change,
                        color: const Color(0xFFEF4444),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Управление тарифами - в разработке')),
                          );
                        },
                      ),
                      AdminNavigationCard(
                        title: 'Платежи',
                        subtitle: 'История транзакций',
                        icon: Icons.payment,
                        color: const Color(0xFF8B5CF6),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('История платежей - в разработке')),
                          );
                        },
                      ),
                      AdminNavigationCard(
                        title: 'Отчеты',
                        subtitle: 'Аналитика и статистика',
                        icon: Icons.analytics,
                        color: const Color(0xFFF59E0B),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Отчеты и аналитика - в разработке')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
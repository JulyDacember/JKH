import 'package:flutter/material.dart';
import '../../repositories/app_repository.dart';
import '../../models/user.dart';
import '../../widgets/header.dart';
import 'widgets/admin_stats_card.dart';
import 'widgets/admin_navigation_card.dart';
import 'admin_requests_screen.dart';
import '../../services/session_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late User _currentUser;
  bool _isCheckingAccess = true;
  bool _hasAccess = false;
  final SessionService _sessionService = SessionService();
  final AppRepository _repository = AppRepository.instance;

  @override
  void initState() {
    super.initState();
    _loadDataAndAccess();
  }

  Future<void> _loadDataAndAccess() async {
    _currentUser = _repository.getCurrentUser();
    final role = await _sessionService.getCurrentRole();
    if (!mounted) return;
    setState(() {
      _hasAccess = role == UserRole.admin;
      _isCheckingAccess = false;
    });
  }

  Widget _buildAccessDenied() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'Доступ запрещен. Требуются права администратора.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFEF4444),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          AppHeader(user: _currentUser, showBackButton: true),
          Expanded(
            child: !_hasAccess
                ? _buildAccessDenied()
                : SingleChildScrollView(
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
                          style: TextStyle(fontSize: 16, color: Colors.grey),
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
                                  MaterialPageRoute(
                                    builder: (_) => const AdminRequestsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Скоро',
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
                            const AdminNavigationCard(
                              title: 'Пользователи',
                              subtitle: 'Скоро доступно',
                              icon: Icons.people,
                              color: Color(0xFF10B981),
                              isEnabled: false,
                              onTap: _noop,
                            ),
                            const AdminNavigationCard(
                              title: 'Балансы',
                              subtitle: 'Скоро доступно',
                              icon: Icons.account_balance_wallet,
                              color: Color(0xFFFFA500),
                              isEnabled: false,
                              onTap: _noop,
                            ),
                            const AdminNavigationCard(
                              title: 'Тарифы',
                              subtitle: 'Скоро доступно',
                              icon: Icons.price_change,
                              color: Color(0xFFEF4444),
                              isEnabled: false,
                              onTap: _noop,
                            ),
                            const AdminNavigationCard(
                              title: 'Платежи',
                              subtitle: 'Скоро доступно',
                              icon: Icons.payment,
                              color: Color(0xFF8B5CF6),
                              isEnabled: false,
                              onTap: _noop,
                            ),
                            const AdminNavigationCard(
                              title: 'Отчеты',
                              subtitle: 'Скоро доступно',
                              icon: Icons.analytics,
                              color: Color(0xFFF59E0B),
                              isEnabled: false,
                              onTap: _noop,
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

  static void _noop() {}
}

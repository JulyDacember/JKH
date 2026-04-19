import 'package:flutter/material.dart';

import '../../repositories/app_repository.dart';
import '../../widgets/header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppRepository.instance.getCurrentUser();
    return Scaffold(
      body: Column(
        children: [
          AppHeader(user: user, showBackButton: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Настройки',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Уведомления',
                  subtitle: 'Управление push и email уведомлениями',
                ),
                _buildTile(
                  icon: Icons.lock_outline,
                  title: 'Безопасность',
                  subtitle: 'Смена пароля и контроль сессий',
                ),
                _buildTile(
                  icon: Icons.language_outlined,
                  title: 'Язык приложения',
                  subtitle: 'Русский',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1E3A8A)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

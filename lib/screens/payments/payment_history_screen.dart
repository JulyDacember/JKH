import 'package:flutter/material.dart';
import '../../repositories/app_repository.dart';
import '../../models/user.dart';
import '../../widgets/header.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  late User _currentUser;
  final AppRepository _repository = AppRepository.instance;
  String _selectedFilter = 'Все';
  final List<String> _filterOptions = [
    'Все',
    'Последний месяц',
    'Последние 3 месяца',
    'Последний год',
  ];

  // Моковые данные платежей
  final List<Map<String, dynamic>> _payments = [
    {
      'id': '1',
      'title': 'Ежемесячная оплата',
      'amount': 1250.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'rent',
      'status': 'completed',
    },
    {
      'id': '2',
      'title': 'Оплата электричества',
      'amount': 85.50,
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'type': 'electricity',
      'status': 'completed',
    },
    {
      'id': '3',
      'title': 'Оплата воды',
      'amount': 45.20,
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'type': 'water',
      'status': 'completed',
    },
    {
      'id': '4',
      'title': 'Оплата газа',
      'amount': 120.00,
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'type': 'gas',
      'status': 'completed',
    },
    {
      'id': '5',
      'title': 'Ежемесячная оплата',
      'amount': 1250.00,
      'date': DateTime.now().subtract(const Duration(days: 60)),
      'type': 'rent',
      'status': 'completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = _repository.getCurrentUser();
  }

  List<Map<String, dynamic>> get _filteredPayments {
    if (_selectedFilter == 'Все') return _payments;

    final now = DateTime.now();
    DateTime cutoffDate;

    switch (_selectedFilter) {
      case 'Последний месяц':
        cutoffDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'Последние 3 месяца':
        cutoffDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'Последний год':
        cutoffDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        return _payments;
    }

    return _payments
        .where((payment) => payment['date'].isAfter(cutoffDate))
        .toList();
  }

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'rent':
        return Icons.home;
      case 'electricity':
        return Icons.flash_on;
      case 'water':
        return Icons.water_drop;
      case 'gas':
        return Icons.local_fire_department;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentColor(String type) {
    switch (type) {
      case 'rent':
        return const Color(0xFF1E3A8A);
      case 'electricity':
        return const Color(0xFFFFA500);
      case 'water':
        return const Color(0xFF3B82F6);
      case 'gas':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF10B981);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дней назад';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'неделя' : 'недель'} назад';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'месяц' : 'месяцев'} назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(user: _currentUser, showBackButton: true),
          Expanded(
            child: Column(
              children: [
                // Фильтр
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'История платежей',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFilter = newValue;
                              });
                            }
                          },
                          items: _filterOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          underline: const SizedBox(),
                          icon: const Icon(Icons.filter_list, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                // Список платежей
                Expanded(
                  child: _filteredPayments.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payment, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Нет платежей за выбранный период',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredPayments.length,
                          itemBuilder: (context, index) {
                            final payment = _filteredPayments[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
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
                                      color: _getPaymentColor(
                                        payment['type'],
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getPaymentIcon(payment['type']),
                                      color: _getPaymentColor(payment['type']),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          payment['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E3A8A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatDate(payment['date']),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '-\$${payment['amount'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF10B981,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          'Оплачено',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF10B981),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

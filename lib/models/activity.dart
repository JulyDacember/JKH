import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityStatus status;
  final DateTime timestamp;
  final ActivityType type;
  final IconData icon;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
    required this.type,
    required this.icon,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

enum ActivityStatus {
  pending,
  inProgress,
  completed,
  success,
}

extension ActivityStatusExtension on ActivityStatus {
  String get displayName {
    switch (this) {
      case ActivityStatus.pending:
        return 'PENDING';
      case ActivityStatus.inProgress:
        return 'IN_PROGRESS';
      case ActivityStatus.completed:
        return 'COMPLETED';
      case ActivityStatus.success:
        return 'SUCCESS';
    }
  }

  Color get color {
    switch (this) {
      case ActivityStatus.pending:
        return const Color(0xFFFFA500);
      case ActivityStatus.inProgress:
        return const Color(0xFFFFA500);
      case ActivityStatus.completed:
        return const Color(0xFF10B981);
      case ActivityStatus.success:
        return const Color(0xFF10B981);
    }
  }
}

enum ActivityType {
  request,
  payment,
  meter,
  maintenance,
}


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

  factory Activity.fromJson(Map<String, dynamic> json) {
    final type = ActivityTypeExtension.fromValue(json['type']?.toString());
    return Activity(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: ActivityStatusExtension.fromValue(json['status']?.toString()),
      timestamp: DateTime.tryParse((json['timestamp'] ?? '').toString()) ??
          DateTime.now(),
      type: type,
      icon: ActivityTypeExtension.defaultIcon(type),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'status': status.displayName,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name.toUpperCase(),
    };
  }

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

enum ActivityStatus { pending, inProgress, completed, success }

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

  static ActivityStatus fromValue(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'PENDING':
        return ActivityStatus.pending;
      case 'IN_PROGRESS':
        return ActivityStatus.inProgress;
      case 'COMPLETED':
        return ActivityStatus.completed;
      case 'SUCCESS':
        return ActivityStatus.success;
      default:
        return ActivityStatus.pending;
    }
  }
}

enum ActivityType { request, payment, meter, maintenance }

extension ActivityTypeExtension on ActivityType {
  static ActivityType fromValue(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'REQUEST':
        return ActivityType.request;
      case 'PAYMENT':
        return ActivityType.payment;
      case 'METER':
        return ActivityType.meter;
      case 'MAINTENANCE':
        return ActivityType.maintenance;
      default:
        return ActivityType.request;
    }
  }

  static IconData defaultIcon(ActivityType type) {
    switch (type) {
      case ActivityType.request:
        return Icons.document_scanner;
      case ActivityType.payment:
        return Icons.payment;
      case ActivityType.meter:
        return Icons.speed;
      case ActivityType.maintenance:
        return Icons.build;
    }
  }
}

import 'package:flutter/material.dart';

class MaintenanceRequest {
  final String id;
  final String title;
  final String description;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String location;
  final List<String>? photos; // URLs или пути к фото

  MaintenanceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.location,
    this.photos,
  });
}

enum RequestStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

extension RequestStatusExtension on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'PENDING';
      case RequestStatus.inProgress:
        return 'IN_PROGRESS';
      case RequestStatus.completed:
        return 'COMPLETED';
      case RequestStatus.cancelled:
        return 'CANCELLED';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return const Color(0xFFFFA500);
      case RequestStatus.inProgress:
        return const Color(0xFF1E3A8A);
      case RequestStatus.completed:
        return const Color(0xFF10B981);
      case RequestStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}


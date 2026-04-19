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

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: RequestStatusExtension.fromValue(json['status']?.toString()),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.tryParse(json['completedAt'].toString()),
      location: (json['location'] ?? '').toString(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'status': status.displayName,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'location': location,
      'photos': photos,
    };
  }
}

enum RequestStatus { pending, inProgress, completed, cancelled }

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

  static RequestStatus fromValue(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'PENDING':
        return RequestStatus.pending;
      case 'IN_PROGRESS':
        return RequestStatus.inProgress;
      case 'COMPLETED':
        return RequestStatus.completed;
      case 'CANCELLED':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.pending;
    }
  }
}

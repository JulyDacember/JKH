import 'package:flutter/material.dart';

class Meter {
  final String id;
  final String number;
  final MeterType type;
  final String location;
  final double lastReading;
  final int daysUntilDue;
  final bool isOverdue;

  Meter({
    required this.id,
    required this.number,
    required this.type,
    required this.location,
    required this.lastReading,
    required this.daysUntilDue,
    this.isOverdue = false,
  });

  String get dueText {
    if (isOverdue) {
      return 'Due: ${daysUntilDue.abs()} days ago';
    } else if (daysUntilDue == 0) {
      return 'Due: today';
    } else {
      return 'Due: in $daysUntilDue days';
    }
  }

  String get formattedReading => lastReading.toStringAsFixed(2);
}

enum MeterType {
  electricity,
  water,
  gas,
}

extension MeterTypeExtension on MeterType {
  String get displayName {
    switch (this) {
      case MeterType.electricity:
        return 'ELECTRICITY';
      case MeterType.water:
        return 'WATER';
      case MeterType.gas:
        return 'GAS';
    }
  }

  Color get iconColor {
    switch (this) {
      case MeterType.electricity:
        return const Color(0xFFFFD700);
      case MeterType.water:
        return const Color(0xFF3B82F6);
      case MeterType.gas:
        return const Color(0xFFEF4444);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case MeterType.electricity:
        return const Color(0xFFFFF9C4);
      case MeterType.water:
        return const Color(0xFFDBEAFE);
      case MeterType.gas:
        return const Color(0xFFFEE2E2);
    }
  }

  IconData get icon {
    switch (this) {
      case MeterType.electricity:
        return Icons.bolt;
      case MeterType.water:
        return Icons.water_drop;
      case MeterType.gas:
        return Icons.local_fire_department;
    }
  }
}


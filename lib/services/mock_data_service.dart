import '../models/user.dart';
import '../models/balance.dart';
import '../models/request.dart';
import '../models/activity.dart';
import '../models/meter.dart';
import 'package:flutter/material.dart';

class MockDataService {
  static User getCurrentUser() {
    return User(
      id: '1',
      name: 'Иван Иванов',
      email: 'ivan@example.com',
      phone: '+7 (999) 123-45-67',
      property: Property(
        id: '1',
        name: 'Sunset Apartments',
        unit: 'Unit 4B',
      ),
    );
  }

  static Balance getCurrentBalance() {
    return Balance(
      amount: 1250.00,
      status: 'CURRENT',
      daysUntilDue: 14,
    );
  }

  static List<MaintenanceRequest> getRequests() {
    return [
      MaintenanceRequest(
        id: '1',
        title: 'Plumbing Issue',
        description: 'Kitchen sink leak',
        status: RequestStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Kitchen',
      ),
      MaintenanceRequest(
        id: '2',
        title: 'HVAC Inspection',
        description: 'Annual maintenance check',
        status: RequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        location: 'Living Room',
      ),
      MaintenanceRequest(
        id: '3',
        title: 'Light Bulb Replacement',
        description: 'Hallway light not working',
        status: RequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        location: 'Hallway',
      ),
      MaintenanceRequest(
        id: '4',
        title: 'Door Lock Repair',
        description: 'Front door lock jamming',
        status: RequestStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        location: 'Front Door',
      ),
      MaintenanceRequest(
        id: '5',
        title: 'Painting Request',
        description: 'Living room wall needs repainting',
        status: RequestStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Living Room',
      ),
    ];
  }

  static List<Activity> getRecentActivities() {
    return [
      Activity(
        id: '1',
        title: 'Plumbing Issue Resol...',
        description: 'Kitchen sink leak has been fixed by maintenance team',
        status: ActivityStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: ActivityType.request,
        icon: Icons.document_scanner,
      ),
      Activity(
        id: '2',
        title: 'Monthly Rent Payment',
        description: 'Payment of \$1,250.00 processed successfully',
        status: ActivityStatus.success,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: ActivityType.payment,
        icon: Icons.payment,
      ),
      Activity(
        id: '3',
        title: 'Electricity Meter Reading',
        description: 'Reading submitted: 1,234.56 kWh',
        status: ActivityStatus.pending,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: ActivityType.meter,
        icon: Icons.speed,
      ),
      Activity(
        id: '4',
        title: 'HVAC Inspection Sc...',
        description: 'Annual maintenance check scheduled for next week',
        status: ActivityStatus.inProgress,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: ActivityType.maintenance,
        icon: Icons.build,
      ),
    ];
  }

  static List<Meter> getMeters() {
    return [
      Meter(
        id: '1',
        number: 'ELE001234',
        type: MeterType.electricity,
        location: 'Main Panel - Kitchen',
        lastReading: 1234.56,
        daysUntilDue: 2,
        isOverdue: false,
      ),
      Meter(
        id: '2',
        number: 'WAT005678',
        type: MeterType.water,
        location: 'Utility Room',
        lastReading: 567.89,
        daysUntilDue: -1,
        isOverdue: true,
      ),
      Meter(
        id: '3',
        number: 'GAS009012',
        type: MeterType.gas,
        location: 'Basement',
        lastReading: 890.12,
        daysUntilDue: 4,
        isOverdue: false,
      ),
    ];
  }

  static int getPendingMeterCount() {
    return getMeters().where((m) => m.daysUntilDue <= 2 || m.isOverdue).length;
  }
}


import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import '../models/activity.dart';
import '../models/balance.dart';
import '../models/meter.dart';
import '../models/meter_ocr_result.dart';
import '../models/request.dart';
import '../models/user.dart';
import '../services/api/api_client.dart';
import '../services/mock_data_service.dart';

enum DataSource { mock, remote }

class AppRepository {
  AppRepository._internal()
      : _apiClient = ApiClient(),
        _dataSource = DataSource.mock;

  static final AppRepository instance = AppRepository._internal();

  final ApiClient _apiClient;
  DataSource _dataSource;

  DataSource get dataSource => _dataSource;

  void setDataSource(DataSource source) {
    _dataSource = source;
  }

  void setDataSourceFromString(String value) {
    if (value.toLowerCase() == 'remote') {
      _dataSource = DataSource.remote;
      return;
    }
    _dataSource = DataSource.mock;
  }

  void setAuthToken(String? token) {
    _apiClient.setAuthToken(token);
  }

  Future<User> loadCurrentUser() async {
    if (_dataSource == DataSource.mock) {
      return MockDataService.getCurrentUser();
    }

    final response = await _apiClient.get('/user/me');
    final payload = _extractPayload(response);
    return User.fromJson(payload);
  }

  Future<Balance> loadCurrentBalance() async {
    if (_dataSource == DataSource.mock) {
      return MockDataService.getCurrentBalance();
    }

    final response = await _apiClient.get('/balances/current');
    final payload = _extractPayload(response);
    return Balance.fromJson(payload);
  }

  Future<List<MaintenanceRequest>> loadRequests() async {
    if (_dataSource == DataSource.mock) {
      return MockDataService.getRequests();
    }

    final response = await _apiClient.get('/requests');
    final list = _extractListPayload(response);
    return list
        .whereType<Map<String, dynamic>>()
        .map(MaintenanceRequest.fromJson)
        .toList();
  }

  Future<List<Activity>> loadRecentActivities() async {
    if (_dataSource == DataSource.mock) {
      return MockDataService.getRecentActivities();
    }

    final response = await _apiClient.get('/activities/recent');
    final list = _extractListPayload(response);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
  }

  Future<List<Meter>> loadMeters() async {
    if (_dataSource == DataSource.mock) {
      return MockDataService.getMeters();
    }

    final response = await _apiClient.get('/meters');
    final list = _extractListPayload(response);
    return list.whereType<Map<String, dynamic>>().map(Meter.fromJson).toList();
  }

  Future<MeterOcrResult> recognizeMeterReading(XFile photo) async {
    if (_dataSource == DataSource.mock) {
      final nowSeed = DateTime.now().millisecondsSinceEpoch % 1000;
      final mockedValue = (1000 + nowSeed / 10).toStringAsFixed(2);
      return MeterOcrResult(reading: mockedValue, confidence: 0.91);
    }

    final bytes = await photo.readAsBytes();
    final response = await _apiClient.post(
      '/meters/ocr',
      body: <String, dynamic>{
        'fileName': photo.name,
        'imageBase64': base64Encode(bytes),
      },
    );
    return MeterOcrResult.fromJson(_extractPayload(response));
  }

  Future<void> submitMeterReading({
    required String meterId,
    required double reading,
    XFile? photo,
  }) async {
    if (_dataSource == DataSource.mock) {
      return;
    }

    String? encodedImage;
    String? fileName;
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      encodedImage = base64Encode(bytes);
      fileName = photo.name;
    }

    await _apiClient.post(
      '/meters/readings',
      body: <String, dynamic>{
        'meterId': meterId,
        'reading': reading,
        'fileName': fileName,
        'imageBase64': encodedImage,
      },
    );
  }

  User getCurrentUser() {
    switch (_dataSource) {
      case DataSource.mock:
        return MockDataService.getCurrentUser();
      case DataSource.remote:
        // TODO(JHK-103): Replace with remote DTO mapping.
        return MockDataService.getCurrentUser();
    }
  }

  Balance getCurrentBalance() {
    switch (_dataSource) {
      case DataSource.mock:
        return MockDataService.getCurrentBalance();
      case DataSource.remote:
        // TODO(JHK-103): Replace with remote DTO mapping.
        return MockDataService.getCurrentBalance();
    }
  }

  List<MaintenanceRequest> getRequests() {
    switch (_dataSource) {
      case DataSource.mock:
        return MockDataService.getRequests();
      case DataSource.remote:
        // TODO(JHK-103): Replace with remote DTO mapping.
        return MockDataService.getRequests();
    }
  }

  List<Activity> getRecentActivities() {
    switch (_dataSource) {
      case DataSource.mock:
        return MockDataService.getRecentActivities();
      case DataSource.remote:
        // TODO(JHK-103): Replace with remote DTO mapping.
        return MockDataService.getRecentActivities();
    }
  }

  List<Meter> getMeters() {
    switch (_dataSource) {
      case DataSource.mock:
        return MockDataService.getMeters();
      case DataSource.remote:
        // TODO(JHK-103): Replace with remote DTO mapping.
        return MockDataService.getMeters();
    }
  }

  int getPendingMeterCount() {
    return getMeters().where((m) => m.daysUntilDue <= 2 || m.isOverdue).length;
  }

  Map<String, dynamic> _extractPayload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return response;
  }

  List<dynamic> _extractListPayload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is List<dynamic>) {
      return data;
    }
    return <dynamic>[];
  }
}

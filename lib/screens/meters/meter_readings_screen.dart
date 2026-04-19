import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../repositories/app_repository.dart';
import '../../models/user.dart';
import '../../models/meter.dart';
import '../../models/activity.dart';
import '../../models/meter_ocr_result.dart';
import '../../widgets/header.dart';
import 'widgets/meter_card.dart';
import 'widgets/quick_capture_card.dart';
import '../activity/recent_activity_screen.dart';
import '../payments/payments_screen.dart';
import '../../widgets/snackbar_helper.dart';

class MeterReadingsScreen extends StatefulWidget {
  const MeterReadingsScreen({super.key});

  @override
  State<MeterReadingsScreen> createState() => _MeterReadingsScreenState();
}

class _MeterReadingsScreenState extends State<MeterReadingsScreen> {
  late User _currentUser;
  late List<Meter> _meters;
  late List<Activity> _recentActivities;
  int _pendingCount = 0;
  bool _isDataLoading = true;
  bool _isRecognizing = false;
  bool _isSubmittingReading = false;
  String? _ocrErrorMessage;
  String? _submitErrorMessage;
  XFile? _selectedMeterPhoto;
  MeterOcrResult? _ocrResult;
  final TextEditingController _recognizedReadingController =
      TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final AppRepository _repository = AppRepository.instance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _recognizedReadingController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      _currentUser = await _repository.loadCurrentUser();
      _meters = await _repository.loadMeters();
      _pendingCount =
          _meters.where((m) => m.daysUntilDue <= 2 || m.isOverdue).length;
      _recentActivities =
          (await _repository.loadRecentActivities()).take(1).toList();
    } catch (_) {
      _currentUser = _repository.getCurrentUser();
      _meters = _repository.getMeters();
      _pendingCount = _repository.getPendingMeterCount();
      _recentActivities = _repository.getRecentActivities().take(1).toList();
    } finally {
      if (!mounted) return;
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  Future<void> _showImageSourcePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать фото'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Выбрать из галереи'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;
      setState(() {
        _selectedMeterPhoto = image;
        _ocrResult = null;
        _ocrErrorMessage = null;
        _submitErrorMessage = null;
        _recognizedReadingController.clear();
      });
      SnackbarHelper.showSuccess(context, 'Фото счетчика выбрано');
    } catch (_) {
      if (!mounted) return;
      SnackbarHelper.showError(context, 'Не удалось выбрать фото');
    }
  }

  Future<void> _recognizeFromPhoto() async {
    if (_selectedMeterPhoto == null) return;
    setState(() {
      _isRecognizing = true;
      _ocrErrorMessage = null;
    });

    try {
      final result =
          await _repository.recognizeMeterReading(_selectedMeterPhoto!);
      if (!mounted) return;
      setState(() {
        _ocrResult = result;
        _recognizedReadingController.text = result.reading;
      });
      SnackbarHelper.showSuccess(context, 'Показания распознаны');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _ocrErrorMessage =
            'Не удалось распознать показания. Проверьте фото и повторите.';
      });
      SnackbarHelper.showError(context, 'Не удалось распознать показания');
    } finally {
      if (!mounted) return;
      setState(() {
        _isRecognizing = false;
      });
    }
  }

  Future<void> _submitReading() async {
    if (_recognizedReadingController.text.trim().isEmpty) {
      SnackbarHelper.showError(context, 'Введите показания перед отправкой');
      return;
    }
    final parsed = double.tryParse(
      _recognizedReadingController.text.trim().replaceAll(',', '.'),
    );
    if (parsed == null) {
      SnackbarHelper.showError(context, 'Показания должны быть числом');
      return;
    }
    if (_meters.isEmpty) {
      SnackbarHelper.showError(context, 'Нет доступных счетчиков для отправки');
      return;
    }

    setState(() {
      _isSubmittingReading = true;
      _submitErrorMessage = null;
    });
    try {
      final targetMeter = _meters.first;
      await _repository.submitMeterReading(
        meterId: targetMeter.id,
        reading: parsed,
        photo: _selectedMeterPhoto,
      );
      if (!mounted) return;
      _applySuccessfulReading(targetMeter.id, parsed);
      await _reloadActivityFeed();
      SnackbarHelper.showSuccess(context, 'Показания отправлены');
      setState(() {
        _selectedMeterPhoto = null;
        _ocrResult = null;
        _ocrErrorMessage = null;
        _submitErrorMessage = null;
        _recognizedReadingController.clear();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitErrorMessage = 'Ошибка отправки. Попробуйте снова.';
      });
      SnackbarHelper.showError(context, 'Ошибка отправки показаний');
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingReading = false;
      });
    }
  }

  void _applySuccessfulReading(String meterId, double reading) {
    final now = DateTime.now();
    final updatedMeters = _meters.map((meter) {
      if (meter.id != meterId) return meter;
      return Meter(
        id: meter.id,
        number: meter.number,
        type: meter.type,
        location: meter.location,
        lastReading: reading,
        daysUntilDue: 30,
        isOverdue: false,
      );
    }).toList();

    setState(() {
      _meters = updatedMeters;
      _pendingCount =
          _meters.where((m) => m.daysUntilDue <= 2 || m.isOverdue).length;
      _recentActivities = [
        Activity(
          id: 'local_${now.millisecondsSinceEpoch}',
          title: 'Показания отправлены',
          description:
              'Значение ${reading.toStringAsFixed(2)} передано в систему',
          status: ActivityStatus.success,
          timestamp: now,
          type: ActivityType.meter,
          icon: ActivityTypeExtension.defaultIcon(ActivityType.meter),
        ),
        ..._recentActivities,
      ].take(1).toList();
    });
  }

  Future<void> _reloadActivityFeed() async {
    try {
      final activities = await _repository.loadRecentActivities();
      if (!mounted || activities.isEmpty) return;
      setState(() {
        _recentActivities = activities.take(1).toList();
      });
    } catch (_) {
      // Keep optimistic local activity if reload fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDataLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          AppHeader(user: _currentUser, showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: 'Make Payment',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PaymentsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          label: 'Emergency',
                          backgroundColor: const Color(0xFFEF4444),
                          onTap: () {
                            SnackbarHelper.showError(
                              context,
                              'Экстренный вызов отправлен диспетчеру',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Meter Readings Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meter Readings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      if (_pendingCount > 0)
                        Text(
                          '$_pendingCount pending',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFA500),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Quick Capture Card
                  QuickCaptureCard(
                    onCapture: _showImageSourcePicker,
                    selectedPhotoName: _selectedMeterPhoto?.name,
                  ),
                  if (_selectedMeterPhoto != null) ...[
                    const SizedBox(height: 12),
                    _buildSelectedPhotoPreview(),
                    const SizedBox(height: 12),
                    _buildOcrActions(),
                  ],
                  const SizedBox(height: 16),
                  // Meter Cards
                  ..._meters.map(
                    (meter) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MeterCard(
                        meter: meter,
                        onCaptureTap: _showImageSourcePicker,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent Activity Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RecentActivityScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Recent Activity Card
                  if (_recentActivities.isNotEmpty)
                    _buildActivityCard(_recentActivities.first),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    Color backgroundColor = const Color(0xFF1E3A8A),
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSelectedPhotoPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Предпросмотр фото',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FutureBuilder<Uint8List>(
              future: _selectedMeterPhoto!.readAsBytes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Image.memory(
                  snapshot.data!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedMeterPhoto = null;
                  _ocrResult = null;
                  _recognizedReadingController.clear();
                  _ocrErrorMessage = null;
                  _submitErrorMessage = null;
                });
              },
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
              label: const Text(
                'Удалить фото',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOcrActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Распознавание показаний',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isRecognizing ? null : _recognizeFromPhoto,
              icon: _isRecognizing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label:
                  Text(_isRecognizing ? 'Распознаем...' : 'Распознать по фото'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          if (_ocrResult != null) ...[
            const SizedBox(height: 12),
            Text(
              'Точность: ${(_ocrResult!.confidence * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
          if (_ocrErrorMessage != null) ...[
            const SizedBox(height: 10),
            _buildErrorWithRetry(
              message: _ocrErrorMessage!,
              onRetry: _isRecognizing ? null : _recognizeFromPhoto,
            ),
          ],
          const SizedBox(height: 8),
          TextField(
            controller: _recognizedReadingController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Показания (можно отредактировать)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmittingReading ? null : _submitReading,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: _isSubmittingReading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Отправить показания'),
            ),
          ),
          if (_submitErrorMessage != null) ...[
            const SizedBox(height: 10),
            _buildErrorWithRetry(
              message: _submitErrorMessage!,
              onRetry: _isSubmittingReading ? null : _submitReading,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWithRetry({
    required String message,
    required VoidCallback? onRetry,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Повторить')),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
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
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon, color: const Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: activity.status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        activity.status.displayName,
                        style: TextStyle(
                          color: activity.status.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

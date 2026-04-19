import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zhkh_app/repositories/app_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('OCR mock flow: recognize and submit reading', () async {
    final repository = AppRepository.instance;
    repository.setDataSource(DataSource.mock);

    final tempDir = await Directory.systemTemp.createTemp('ocr_flow_test_');
    final imageFile = File('${tempDir.path}/meter.jpg');
    await imageFile.writeAsBytes(List<int>.generate(64, (i) => i % 256));
    final xFile = XFile(imageFile.path);

    final result = await repository.recognizeMeterReading(xFile);
    expect(result.reading.isNotEmpty, true);
    expect(result.confidence > 0, true);

    await repository.submitMeterReading(
      meterId: '1',
      reading: double.parse(result.reading),
      photo: xFile,
    );

    await tempDir.delete(recursive: true);
  });
}

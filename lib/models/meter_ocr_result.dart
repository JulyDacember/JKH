class MeterOcrResult {
  final String reading;
  final double confidence;

  const MeterOcrResult({
    required this.reading,
    required this.confidence,
  });

  factory MeterOcrResult.fromJson(Map<String, dynamic> json) {
    return MeterOcrResult(
      reading: (json['reading'] ?? '').toString(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reading': reading,
      'confidence': confidence,
    };
  }
}

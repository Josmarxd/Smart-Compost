class MeasurementModel {
  final double ph;
  final double tds;
  final DateTime fecha;

  MeasurementModel({
    required this.ph,
    required this.tds,
    required this.fecha,
  });

  // ✅ AGREGAR ESTE MÉTODO
  Map<String, dynamic> toMap() {
    return {
      'ph': ph,
      'tds': tds,
      'fecha': fecha.toIso8601String(),
    };
  }

  // ✅ AGREGAR ESTE MÉTODO
  factory MeasurementModel.fromMap(Map<String, dynamic> map) {
    return MeasurementModel(
      ph: map['ph'],
      tds: map['tds'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}

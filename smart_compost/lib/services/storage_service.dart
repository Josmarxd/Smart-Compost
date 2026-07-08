import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/measurement_model.dart';

class StorageService {
  static const String _medicionesKey = 'mediciones';

  static Future<void> guardarMedicion(MeasurementModel medicion) async {
    final prefs = await SharedPreferences.getInstance();
    List<MeasurementModel> mediciones = await obtenerTodasLasMediciones();
    mediciones.add(medicion);

    List<String> medicionesJson =
        mediciones.map((m) => jsonEncode(m.toMap())).toList();
    await prefs.setStringList(_medicionesKey, medicionesJson);
  }

  static Future<List<MeasurementModel>> obtenerTodasLasMediciones() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? medicionesJson = prefs.getStringList(_medicionesKey);
    if (medicionesJson == null) return [];
    return medicionesJson
        .map((json) => MeasurementModel.fromMap(jsonDecode(json)))
        .toList();
  }

  static Future<MeasurementModel?> obtenerUltimaMedicion() async {
    final mediciones = await obtenerTodasLasMediciones();
    if (mediciones.isEmpty) return null;
    return mediciones.last;
  }

  static Future<Map<String, double>> obtenerEstadisticas() async {
    final mediciones = await obtenerTodasLasMediciones();
    if (mediciones.isEmpty) {
      return {'phPromedio': 0, 'tdsPromedio': 0, 'totalMediciones': 0};
    }

    double phSum = 0;
    double tdsSum = 0;

    for (var m in mediciones) {
      phSum += m.ph;
      tdsSum += m.tds;
    }

    return {
      'phPromedio': phSum / mediciones.length,
      'tdsPromedio': tdsSum / mediciones.length,
      'totalMediciones': mediciones.length.toDouble(),
    };
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/measurement_model.dart';
import '../services/storage_service.dart';

class Esp32Service {
  static const String baseUrl = "http://192.168.4.1";
  static const String medicionEndpoint = "/medicion";

  // Esta variable guardará el dato para que TipsScreen lo pueda leer
  static MeasurementModel? ultimaMedicion;

  static Future<MeasurementModel> obtenerMedicion() async {
    try {
      final url = Uri.parse("$baseUrl$medicionEndpoint");
      final response = await http.get(url).timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nuevaMedicion = MeasurementModel(
          ph: (data["ph"] as num).toDouble(),
          tds: (data["tds"] as num).toDouble(),
          fecha: DateTime.now(),
        );

        // Guardamos antes de retornar
        ultimaMedicion = nuevaMedicion;
        await StorageService.guardarMedicion(nuevaMedicion);
        return nuevaMedicion;
      } else {
        throw Exception("Error del ESP32");
      }
    } catch (e) {
      // Simulación en caso de error
      final simulado = MeasurementModel(
        ph: 6.2,
        tds: 850,
        fecha: DateTime.now(),
      );
      ultimaMedicion = simulado;
      return simulado;
    }
  }
}

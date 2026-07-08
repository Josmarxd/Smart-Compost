import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/tip_card.dart';
import '../models/tip_model.dart';
import '../models/measurement_model.dart';
import '../services/storage_service.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  MeasurementModel? ultima;

  @override
  void initState() {
    super.initState();
    cargarUltimaMedicion();
  }

  Future<void> cargarUltimaMedicion() async {
    final ultimaGuardada = await StorageService.obtenerUltimaMedicion();
    setState(() {
      ultima = ultimaGuardada;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generar consejos inteligentes solo si hay datos
    final sugerenciasSensores = (ultima != null)
        ? generarConsejosDesdeMedicion(ultima!.ph, ultima!.tds)
        : <TipModel>[];

    // Obtener 3 consejos aleatorios de la lista general para que siempre haya contenido
    final sugerenciasGenerales = getConsejosAleatorios(3);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Sugerencias Inteligentes',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (ultima != null) ...[
            _buildInfoCard(),
            const SizedBox(height: 25),
            const Text("Prioritario para tu mezcla",
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 10),
            ...sugerenciasSensores.map((tip) => TipCard(
                  titulo: tip.titulo,
                  descripcion: tip.descripcion,
                  icon: tip.icono,
                )),
            const SizedBox(height: 30),
          ] else ...[
            _buildNoDataPrompt(),
            const SizedBox(height: 30),
          ],
          const Text("Consejos de mantenimiento",
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 10),
          ...sugerenciasGenerales.map((tip) => TipCard(
                titulo: tip.titulo,
                descripcion: tip.descripcion,
                icon: tip.icono,
              )),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amberAccent),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Último análisis detectado",
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
              Text("pH: ${ultima!.ph}  |  TDS: ${ultima!.tds.toInt()} ppm",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNoDataPrompt() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: const Text(
        "Realiza una medición en el Monitor para activar las sugerencias automáticas.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ),
    );
  }
}

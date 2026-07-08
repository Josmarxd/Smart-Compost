import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/measurement_model.dart';
import '../services/storage_service.dart';

class GraphsScreen extends StatefulWidget {
  const GraphsScreen({super.key});

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  List<MeasurementModel> mediciones = [];
  bool cargando = true;
  Map<String, double> estadisticas = {};

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    setState(() => cargando = true);
    try {
      final datos = await StorageService.obtenerTodasLasMediciones();
      final stats = await StorageService.obtenerEstadisticas();
      setState(() {
        mediciones = datos;
        estadisticas = stats;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Análisis de Datos",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        centerTitle: true,
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent))
          : mediciones.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSummary(),
                      const SizedBox(height: 25),
                      const Text("Tendencia de pH",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildChartContainer(
                        child: _buildLineChart(
                          spots: mediciones
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.ph))
                              .toList(),
                          color: Colors.blueAccent,
                          minY: 0,
                          maxY: 14,
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Text("Concentración TDS (ppm)",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildChartContainer(
                        child: _buildLineChart(
                          spots: mediciones
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.tds))
                              .toList(),
                          color: Colors.greenAccent,
                          minY: 0,
                          maxY: 2000,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.show_chart, size: 80, color: Colors.white24),
          const SizedBox(height: 20),
          const Text(
            "Sin datos aún",
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            "Realiza al menos una medición\nen la pantalla Monitor",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSummary() {
    if (mediciones.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.green.withOpacity(0.2),
            Colors.blue.withOpacity(0.2)
          ]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryItem("Promedio pH", "0", Icons.water_drop, Colors.blue),
            const VerticalDivider(color: Colors.white24),
            _summaryItem("Promedio TDS", "0", Icons.science, Colors.green),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.green.withOpacity(0.2),
          Colors.blue.withOpacity(0.2)
        ]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(
            "Promedio pH",
            estadisticas['phPromedio']?.toStringAsFixed(1) ?? "0",
            Icons.water_drop,
            Colors.blue,
          ),
          const VerticalDivider(color: Colors.white24),
          _summaryItem(
            "Promedio TDS",
            estadisticas['tdsPromedio']?.toInt().toString() ?? "0",
            Icons.science,
            Colors.green,
          ),
          const VerticalDivider(color: Colors.white24),
          _summaryItem(
            "Mediciones",
            estadisticas['totalMediciones']?.toInt().toString() ?? "0",
            Icons.history,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildChartContainer({required Widget child}) {
    return Container(
      height: 280,
      padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C23),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
        ],
      ),
      child: child,
    );
  }

  Widget _buildLineChart(
      {required List<FlSpot> spots,
      required Color color,
      required double minY,
      required double maxY}) {
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.white10, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("M${value.toInt() + 1}",
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 10)),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
                  style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                        radius: 4,
                        color: color,
                        strokeWidth: 2,
                        strokeColor: Colors.white)),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot touchedSpot) =>
                const Color(0xFF2E323F),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/esp32_service.dart';

enum MeasurementState { idle, measuring, success, error }

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen>
    with SingleTickerProviderStateMixin {
  MeasurementState estado = MeasurementState.idle;
  double ph = 0;
  double tds = 0;

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  Future<void> iniciarMedicion() async {
    bool conectado = await WiFiForIoTPlugin.isConnected() ?? false;

    if (!conectado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Primero debes conectarte al dispositivo'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => estado = MeasurementState.measuring);

    try {
      final medicion = await Esp32Service.obtenerMedicion();

      setState(() {
        ph = medicion.ph;
        tds = medicion.tds;
        estado = MeasurementState.success;
      });
    } catch (e) {
      setState(() {
        estado = MeasurementState.error;
      });
    }
  }

  String get mensajeEstado {
    if (ph < 5.5) return "Mezcla muy ácida";
    if (ph > 7.5) return "Mezcla muy alcalina";
    if (tds > 1200) return "Muy concentrada";
    if (tds < 400) return "Muy diluida";
    return "Mezcla en estado óptimo";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Monitor de Nutrientes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (estado) {
      case MeasurementState.idle:
        return pantallaInicial();
      case MeasurementState.measuring:
        return pantallaMidiendo();
      case MeasurementState.success:
        return pantallaResultado();
      case MeasurementState.error:
        return pantallaError();
    }
  }

  Widget pantallaInicial() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.waves_rounded, size: 80, color: Colors.blueAccent),
          const SizedBox(height: 20),
          const Text("Sistema Listo",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const Text("Coloca los sensores en la solución",
              style: TextStyle(fontSize: 16, color: Colors.white54)),
          const SizedBox(height: 60),
          ScaleTransition(
            scale: _pulseAnimation,
            child: GestureDetector(
              onTap: iniciarMedicion,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00C853), Color(0xFF64DD17)]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text("INICIAR",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pantallaMidiendo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              ),
              const Icon(Icons.science_rounded,
                  size: 70, color: Colors.greenAccent),
            ],
          ),
          const SizedBox(height: 40),
          const Text("Analizando solución...",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          const Text("Extrayendo datos del ESP32",
              style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget pantallaResultado() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text("Resultados del Análisis",
              style: TextStyle(
                  color: Colors.white70, fontSize: 16, letterSpacing: 1.2)),
          const SizedBox(height: 25),
          _tarjetaPro("Nivel de pH", ph.toString(), Icons.opacity, Colors.blue),
          const SizedBox(height: 20),
          _tarjetaPro(
              "Sólidos (TDS)", "$tds ppm", Icons.blur_on, Colors.orange),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(mensajeEstado,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      setState(() => estado = MeasurementState.idle),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Repetir",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Guardar"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tarjetaPro(String label, String valor, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 8),
              Text(valor,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, size: 50, color: color.withOpacity(0.8)),
        ],
      ),
    );
  }

  Widget pantallaError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 100, color: Colors.redAccent),
          const SizedBox(height: 20),
          const Text("Error de Lectura",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Revisa la conexión de los sensores",
              style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () => setState(() => estado = MeasurementState.idle),
            child: const Text("Reintentar",
                style: TextStyle(color: Colors.blueAccent, fontSize: 18)),
          )
        ],
      ),
    );
  }
}

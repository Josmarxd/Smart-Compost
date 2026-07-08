import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/tip_card.dart';
import '../models/tip_model.dart';
import 'connection_screen.dart';
import 'measurement_screen.dart';
import 'graphs_screen.dart';
import 'tips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TipModel> consejosMostrar = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    consejosMostrar = getConsejosAleatorios(3);
    _iniciarRotacion();
  }

  void _iniciarRotacion() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          consejosMostrar = getConsejosAleatorios(3);
        });
      }
    });
  }

  // Función para mostrar información del desarrollador
  void _mostrarAcercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'LixiControl',
      applicationVersion: '1.0.0',
      applicationIcon:
          const Icon(Icons.eco, color: Color(0xFF00C853), size: 40),
      children: [
        const SizedBox(height: 15),
        const Text(
          "Desarrollado por Josmar\nIngeniero en Sistemas Computacionales",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Esta aplicación permite el monitoreo en tiempo real de lixiviados orgánicos mediante hardware basado en ESP32.",
          style: TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF0F1117);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('LixiControl',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _mostrarAcercaDe(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Acciones rápidas",
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.4,
              children: [
                _buildMenuButton(
                  icon: Icons.wifi_find_rounded,
                  label: 'Conectar\nWiFi',
                  color: const Color(0xFF2196F3),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConnectionScreen())),
                ),
                _buildMenuButton(
                  icon: Icons.analytics_outlined,
                  label: 'Iniciar\nMedición',
                  color: const Color(0xFF00C853),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MeasurementScreen())),
                ),
                _buildMenuButton(
                  icon: Icons.auto_graph_rounded,
                  label: 'Ver\nGráficas',
                  color: Colors.orangeAccent,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GraphsScreen())),
                ),
                _buildMenuButton(
                  icon: Icons.tips_and_updates_outlined,
                  label: 'Consejos\nExpertos',
                  color: Colors.purpleAccent,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TipsScreen())),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Row(
              children: const [
                Icon(Icons.auto_awesome, color: Colors.yellowAccent, size: 20),
                SizedBox(width: 10),
                Text('Tips para tu Lixiviado',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            const SizedBox(height: 15),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: Column(
                key: ValueKey(consejosMostrar),
                children: consejosMostrar
                    .map((tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TipCard(
                              titulo: tip.titulo,
                              descripcion: tip.descripcion,
                              icon: tip.icono),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildMenuButton(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1C23),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

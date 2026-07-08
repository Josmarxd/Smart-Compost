import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'wifi_details_screen.dart'; // Importa la nueva pantalla
import '../widgets/bottom_nav_bar.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  List<WifiNetwork> redes = [];
  bool conectado = false;
  String redActual = '';

  @override
  void initState() {
    super.initState();
    verificarConexionActual();
    escanearWifi();
  }

  Future<void> verificarConexionActual() async {
    final conectadoAhora = await WiFiForIoTPlugin.isConnected();
    final ssid = await WiFiForIoTPlugin.getSSID();
    setState(() {
      conectado = conectadoAhora ?? false;
      redActual = ssid ?? '';
    });
  }

  Future<void> escanearWifi() async {
    final lista = await WiFiForIoTPlugin.loadWifiList();
    setState(() {
      redes = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración WiFi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: escanearWifi,
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SECCIÓN: RED ACTUAL
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("RED ACTUAL",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  _buildCurrentNetworkCard(),
                ],
              ),
            ),
          ),

          // SECCIÓN: REDES DISPONIBLES
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: const Text("REDES DISPONIBLES",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2)),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: redes.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  )))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final red = redes[index];
                        // No mostrar la red a la que ya estamos conectados en la lista de disponibles
                        if (conectado && red.ssid == redActual)
                          return const SizedBox.shrink();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side:
                                BorderSide(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: ListTile(
                            leading:
                                const Icon(Icons.wifi, color: Colors.blueGrey),
                            title: Text(red.ssid ?? 'Red desconocida'),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WifiDetailsScreen(ssid: red.ssid ?? ''),
                              ),
                            ).then((_) =>
                                verificarConexionActual()), // Al volver, refrescar estado
                          ),
                        );
                      },
                      childCount: redes.length,
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildCurrentNetworkCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: conectado
            ? LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade400])
            : const LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(conectado ? Icons.wifi_lock : Icons.wifi_off,
              color: Colors.white, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conectado ? redActual : "Desconectado",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(conectado ? "Conexión segura" : "Sin conexión activa",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          if (conectado)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await WiFiForIoTPlugin.disconnect();
                verificarConexionActual();
              },
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiDetailsScreen extends StatefulWidget {
  final String ssid;
  const WifiDetailsScreen({super.key, required this.ssid});

  @override
  State<WifiDetailsScreen> createState() => _WifiDetailsScreenState();
}

class _WifiDetailsScreenState extends State<WifiDetailsScreen> {
  final TextEditingController _passController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  Future<void> _intentarConectar() async {
    setState(() => _isLoading = true);

    bool result = await WiFiForIoTPlugin.connect(
      widget.ssid,
      password: _passController.text,
      security: NetworkSecurity.WPA,
    );

    setState(() => _isLoading = false);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("¡Conexión exitosa!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Regresa a la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error al conectar. Revisa la clave."),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conectar")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Configurar conexión para:",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(widget.ssid,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(
              controller: _passController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: const Icon(Icons.lock_outline),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                suffixIcon: IconButton(
                  icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _intentarConectar,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.blue,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("CONECTAR AHORA",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

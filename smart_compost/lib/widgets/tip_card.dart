import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icon;

  const TipCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10), // antes 12
      elevation: 2, // antes 3
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // antes 12
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 34, // antes 40 (solo un poco más pequeño)
          color: Colors.green,
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15, // antes 16
          ),
        ),
        subtitle: Text(
          descripcion,
          style: const TextStyle(
            fontSize: 13, // tamaño ligeramente menor
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, // antes 16
          vertical: 6, // antes 8
        ),
      ),
    );
  }
}

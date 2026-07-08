import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/connection_screen.dart';
import '../screens/measurement_screen.dart';
import '../screens/graphs_screen.dart';
import '../screens/tips_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  void _navigate(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ConnectionScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MeasurementScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GraphsScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TipsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _navigate(index, context),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.white54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          // INICIO
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: '',
          ),

          // WIFI
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi, size: 28),
            label: '',
          ),

          // NUEVO BOTÓN - MEDICIÓN
          BottomNavigationBarItem(
            icon: Icon(Icons.science, size: 28),
            label: '',
          ),

          // GRÁFICAS
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart, size: 28),
            label: '',
          ),

          // CONSEJOS
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb, size: 28),
            label: '',
          ),
        ],
      ),
    );
  }
}

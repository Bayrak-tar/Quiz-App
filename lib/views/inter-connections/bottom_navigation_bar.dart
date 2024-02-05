import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  CustomBottomNavigationBar({required this.selectedIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(Icons.school, 'Öğren', 0),
          buildNavItem(Icons.create_outlined, 'Test Et', 1),

        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: index == selectedIndex ? 38 : 35, color: Colors.white),
          onPressed: () => onTabTapped(index),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

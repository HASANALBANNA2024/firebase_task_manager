import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AppLogo({super.key, this.size = 72.0, this.iconSize = 40.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFA5).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.check, color: Colors.white, size: iconSize),
    );
  }
}

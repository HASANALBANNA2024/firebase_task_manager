import 'package:flutter/material.dart';

class RemindMe extends StatelessWidget {
  final bool remindMe;
  final ValueChanged<bool> onChanged;

  const RemindMe({super.key, required this.remindMe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E9E8), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Remind me",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF101828),
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Push notification at the set time",
                style: TextStyle(color: Color(0xFF667085), fontSize: 12),
              ),
            ],
          ),
          Switch(
            value: remindMe,
            activeThumbColor: const Color(0xFF0E9F8E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

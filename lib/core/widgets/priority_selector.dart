import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    const priorities = ["Low", "Medium", "High"];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEFF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: priorities.map((prio) {
          bool isSelected = selectedPriority == prio;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPrioritySelected(prio),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  prio,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? const Color(0xFF101828)
                        : const Color(0xFF667085),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

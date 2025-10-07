import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String option;
  final bool isCorrect;

  const OptionTile({super.key, required this.option, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.85) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: ListTile(
        title: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            color: isCorrect ? Colors.white : Colors.black87,
            fontWeight:
                isCorrect ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: null,
      ),
    );
  }
}

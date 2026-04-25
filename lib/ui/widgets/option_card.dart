import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const OptionCard({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getBorderColor() {
      if (isCorrect) return Colors.green;
      if (isWrong) return Colors.red;
      if (isSelected) return Colors.blue;
      return Colors.grey.shade300;
    }

    Color getBackgroundColor() {
      if (isCorrect) return Colors.green.withOpacity(0.2);
      if (isWrong) return Colors.red.withOpacity(0.2);
      if (isSelected) return Colors.blue.withOpacity(0.1);
      return Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          border: Border.all(color: getBorderColor(), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (isCorrect)
              const Icon(Icons.check_circle, color: Colors.green)
            else if (isWrong)
              const Icon(Icons.cancel, color: Colors.red)
            else if (isSelected)
              const Icon(Icons.radio_button_checked, color: Colors.blue)
            else
              const Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

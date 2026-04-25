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
      if (isCorrect) return const Color(0xFF10B981); // Emerald
      if (isWrong) return const Color(0xFFEF4444); // Red
      if (isSelected) return const Color(0xFF6366F1); // Indigo
      return Colors.white.withOpacity(0.15);
    }

    Color getBackgroundColor() {
      if (isCorrect) return const Color(0xFF10B981).withOpacity(0.15);
      if (isWrong) return const Color(0xFFEF4444).withOpacity(0.15);
      if (isSelected) return const Color(0xFF6366F1).withOpacity(0.15);
      return Colors.white.withOpacity(0.03);
    }

    IconData getIcon() {
      if (isCorrect) return Icons.check_circle_outline_rounded;
      if (isWrong) return Icons.cancel_outlined;
      if (isSelected) return Icons.radio_button_checked_rounded;
      return Icons.radio_button_unchecked_rounded;
    }

    Color getIconColor() {
      if (isCorrect) return const Color(0xFF10B981);
      if (isWrong) return const Color(0xFFEF4444);
      if (isSelected) return const Color(0xFF818CF8);
      return Colors.white.withOpacity(0.5);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          border: Border.all(color: getBorderColor(), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected || isCorrect || isWrong
              ? [
                  BoxShadow(
                    color: getBorderColor().withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: -2,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              getIcon(),
              color: getIconColor(),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

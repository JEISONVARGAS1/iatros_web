import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function() onTap;

  const CustomElevatedButton({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
        foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      child: Text(label),
    );
  }
}

                        
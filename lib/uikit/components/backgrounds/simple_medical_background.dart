import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SimpleMedicalBackground extends StatelessWidget {
  final Widget child;
  final bool showElements;

  const SimpleMedicalBackground({
    super.key,
    required this.child,
    this.showElements = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.medicalBlue.withOpacity(0.5),
            AppColors.primary.withOpacity(0.5),
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}

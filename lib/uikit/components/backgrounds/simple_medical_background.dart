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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.medicalBlue,
            AppColors.background,
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: Stack(
        children: [
          if (showElements) ...[
            // Elementos decorativos sutiles
            Positioned(
              top: 50,
              right: 50,
              child: _DecorativeElement(
                color: AppColors.leafGreen.withOpacity(0.1),
                size: 80,
              ),
            ),
            Positioned(
              bottom: 100,
              left: 30,
              child: _DecorativeElement(
                color: AppColors.turquoise.withOpacity(0.08),
                size: 120,
              ),
            ),
            Positioned(
              top: 200,
              left: 20,
              child: _DecorativeElement(
                color: AppColors.coral.withOpacity(0.06),
                size: 60,
              ),
            ),
            Positioned(
              bottom: 200,
              right: 20,
              child: _DecorativeElement(
                color: AppColors.peach.withOpacity(0.07),
                size: 90,
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _DecorativeElement extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorativeElement({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

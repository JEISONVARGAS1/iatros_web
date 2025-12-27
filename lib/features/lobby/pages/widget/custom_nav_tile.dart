import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/components/cards/glassmorphism_card.dart';
import 'package:iatros_web/uikit/index.dart';

class CustomNavTile extends StatelessWidget {
  final String title;
  final bool selected;
  final bool isLogout;
  final IconData icon;
  final VoidCallback onTap;

  const CustomNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.selected = false,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: GlassmorphismCard(
          blur: selected ? 15.0 : 12.0,
          opacity: selected ? 0.25 : 0.2,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.gray100.withOpacity(0.9)
                : isLogout
                ? AppColors.error.withOpacity(0.9)
                : AppColors.primary.withOpacity(0.4),
            width: selected
                ? 2.0
                : isLogout
                ? 2.0
                : 1.5,
          ),
          backgroundColor: selected
              ? AppColors.gray100.withOpacity(0.08)
              : isLogout
              ? AppColors.error.withOpacity(0.08)
              : AppColors.primary.withOpacity(0.12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              icon,
              color: isLogout
                  ? AppColors.error
                  : selected
                  ? AppColors.gray100.withOpacity(0.9)
                  : AppColors.primary,
              size: isLogout ? 24 : 22,
            ),
            title: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: isLogout
                    ? AppColors.error
                    : selected
                    ? AppColors.gray100.withOpacity(0.8)
                    : AppColors.primary,
                fontWeight: selected
                    ? FontWeight.w600
                    : isLogout
                    ? FontWeight.w500
                    : FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
            hoverColor: AppColors.primary.withOpacity(0.08),
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

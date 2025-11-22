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
          blur: selected ? 15.0 : 8.0,
          opacity: selected ? 0.25 : 0.15,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary.withOpacity(0.3)
                : isLogout
                ? AppColors.error.withOpacity(0.9)
                : AppColors.white.withOpacity(0.1),
            width: selected
                ? 2.0
                : isLogout
                ? 2.0
                : 1.5,
          ),
          backgroundColor: selected
              ? AppColors.primary.withOpacity(0.1)
              : isLogout
              ? AppColors.error.withOpacity(0.05)
              : AppColors.surface.withOpacity(0.05),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              icon,
              color: isLogout
                  ? AppColors.error
                  : selected
                  ? AppColors.primaryDark
                  : AppColors.gray500,
              size: isLogout ? 24 : 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isLogout
                    ? AppColors.error
                    : selected
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
                fontWeight: selected
                    ? FontWeight.w900
                    : isLogout
                    ? FontWeight.w600
                    : FontWeight.w300,
                fontSize: selected
                    ? 16
                    : isLogout
                    ? 16
                    : 15,
                letterSpacing: 0.1,
              ),
            ),
            hoverColor: AppColors.primary.withOpacity(0.05),
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

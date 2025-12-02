import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SimpleMedicalBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: BaseCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingLG),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    UIHelpers.verticalSpaceMD,
                    Text(
                      'Página no encontrada',
                      style: AppTypography.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    UIHelpers.verticalSpaceSM,
                    Text(
                      'La página que buscas no existe o ha sido movida.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    UIHelpers.verticalSpaceLG,
                    PrimaryButton(
                      label: 'Ir al inicio',
                      onPressed: () => context.go('/lobby'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

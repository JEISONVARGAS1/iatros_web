import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/uikit/index.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    final name = '${authState.user?.name ?? ''} ${authState.user?.lastName ?? ''}'.trim();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perfil', style: AppTypography.h3),
          UIHelpers.verticalSpaceLG,
          BaseCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                UIHelpers.horizontalSpaceLG,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.isEmpty ? 'Usuario' : name, style: AppTypography.h4),
                      UIHelpers.verticalSpaceSM,
                      Text('Correo: ${authState.user?.email ?? '-'}', style: AppTypography.bodyMedium),
                      if (authState.user?.medicalLicense != null) ...[
                        UIHelpers.verticalSpaceSM,
                        Text('Licencia médica: ${authState.user?.medicalLicense}', style: AppTypography.bodyMedium),
                      ],
                      if (authState.user?.specialization != null) ...[
                        UIHelpers.verticalSpaceSM,
                        Text('Especialización: ${authState.user?.specialization}', style: AppTypography.bodyMedium),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



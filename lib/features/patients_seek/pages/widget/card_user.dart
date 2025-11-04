import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/user_model.dart';

class CardUser extends ConsumerWidget {
  final UserModel user;
  final Function(UserModel) goToPatient;

  const CardUser({super.key, required this.user, required this.goToPatient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseCard(
      backgroundColor: AppColors.surface,
      child: Row(
        children: [
          const CircleAvatar(radius: 22, child: Icon(Icons.person)),
          UIHelpers.horizontalSpaceMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${user.name} ${user.lastName}", style: AppTypography.h6),
                Text(user.email, style: AppTypography.bodySmall),
              ],
            ),
          ),
          SecondaryButton(
            label: 'Iniciar Historia',
            onPressed: () => goToPatient(user),
          ),
        ],
      ),
    );
  }
}

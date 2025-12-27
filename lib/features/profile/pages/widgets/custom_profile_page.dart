import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/features/profile/provider/model/profile_state.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';
import 'package:iatros_web/uikit/index.dart';

class CustomProfilePage extends StatelessWidget {
  const CustomProfilePage({
    super.key,
    required this.state,
    required this.controller,
  });

  final ProfileState state;
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perfil', style: AppTypography.h3),
          UIHelpers.verticalSpaceLG,
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      child: Icon(Icons.person, size: 36),
                    ),
                    UIHelpers.horizontalSpaceLG,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.myUser.name.isEmpty
                                ? 'Usuario'
                                : '${state.myUser.name} ${state.myUser.lastName}',
                            style: AppTypography.h4,
                          ),
                          UIHelpers.verticalSpaceMD,
                          Row(
                            children: [
                              const Icon(Icons.email, size: 20),
                              UIHelpers.horizontalSpaceSM,
                              Text(
                                state.myUser.email,
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                          UIHelpers.verticalSpaceSM,
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 20),
                              UIHelpers.horizontalSpaceSM,
                              Text(
                                state.myUser.phone,
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                          if (state.myUser.medicalLicense.isNotEmpty) ...[
                            UIHelpers.verticalSpaceSM,
                            Row(
                              children: [
                                const Icon(Icons.description, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  'Licencia médica: ${state.myUser.medicalLicense}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                          if (state.myUser.specialization.isNotEmpty) ...[
                            UIHelpers.verticalSpaceSM,
                            Row(
                              children: [
                                const Icon(Icons.local_hospital, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  'Especialización: ${state.myUser.specialization}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpaceLG,
                const Divider(),
                UIHelpers.verticalSpaceLG,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      child: Icon(Icons.business, size: 36),
                    ),
                    UIHelpers.horizontalSpaceLG,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.userCompany.company != null
                                ? 'Compañía Seleccionada'
                                : 'Compañía',
                            style: AppTypography.h4,
                          ),
                          UIHelpers.verticalSpaceMD,
                          if (state.userCompany.company != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.business, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  state.userCompany.company!.companyName,
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                            UIHelpers.verticalSpaceSM,
                            Row(
                              children: [
                                const Icon(Icons.badge, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  'NIT: ${state.userCompany.company!.nit}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                            UIHelpers.verticalSpaceSM,
                            Row(
                              children: [
                                const Icon(Icons.category, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  'Tipo: ${state.userCompany.company!.companyType.value}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                            UIHelpers.verticalSpaceSM,
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  'Rol: ${state.userCompany.rolUser.toName}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                const Icon(Icons.business_center, size: 20),
                                UIHelpers.horizontalSpaceSM,
                                Text(
                                  'No hay compañía seleccionada',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    UIHelpers.horizontalSpaceLG,
                    PrimaryButton(
                      label: state.userCompany.company != null
                          ? 'Cambiar Compañia'
                          : 'Seleccionar Compañia',
                      onPressed: controller.openCompanySelectionPanel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

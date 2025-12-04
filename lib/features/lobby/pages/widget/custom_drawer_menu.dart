import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';
import 'package:iatros_web/features/lobby/provider/model/lobby_state.dart';
import 'package:iatros_web/features/lobby/pages/widget/custom_nav_tile.dart';

class CustomDrawerMenu extends StatelessWidget {
  final LobbyState state;
  final LobbyController controller;

  const CustomDrawerMenu({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: state.width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.medicalBlue, AppColors.primary],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Visibility(
            visible: state.isMenuVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      UIHelpers.horizontalSpaceMD,
                      Text(
                        "Iatros",
                        style: AppTypography.h4.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  UIHelpers.verticalSpaceLG,
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surface.withOpacity(0.9),
                          AppColors.surface.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.paddingLG),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        UIHelpers.horizontalSpaceMD,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Usuario",
                                style: AppTypography.label.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              UIHelpers.verticalSpaceXS,
                              Text(
                                "${state.myUser.name} ${state.myUser.lastName}",
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIHelpers.verticalSpaceLG,

                  // --- NAV ITEMS ---
                  CustomNavTile(
                    title: "Agendamiento",
                    icon: Icons.dashboard_outlined,
                    selected: state.selectedIndex == 0,
                    onTap: () => controller.changeIndex(0),
                  ),
                  CustomNavTile(
                    title: "Pacientes",
                    icon: Icons.people_outline,
                    selected: state.selectedIndex == 1,
                    onTap: () => controller.changeIndex(1),
                  ),
                  CustomNavTile(
                    title: "Perfil",
                    icon: Icons.person_outline,
                    selected: state.selectedIndex == 2,
                    onTap: () => controller.changeIndex(2),
                  ),

                  const Spacer(),

                  // Modern divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.white.withOpacity(0.3),
                                  AppColors.white.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Cuenta",
                            style: AppTypography.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.white.withOpacity(0.1),
                                  AppColors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  CustomNavTile(
                    isLogout: true,
                    icon: Icons.logout,
                    title: "Cerrar sesión",
                    onTap: () => controller.showLogoutConfirmation(context),
                  ),
                  UIHelpers.verticalSpaceLG,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

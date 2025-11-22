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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: state.width,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryLight.withOpacity(0.9),
                      AppColors.primaryDark.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Visibility(
                visible: state.isMenuVisible,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.white.withOpacity(0.1),
                            AppColors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border(
                          right: BorderSide(
                            color: AppColors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- LOGO / HEADER ---
                            Text(
                              "Iatros",
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            UIHelpers.verticalSpaceLG,
                            BaseCard(
                              backgroundColor: AppColors.medicalBlue,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusXL,
                              ),
                              padding: const EdgeInsets.all(
                                AppSpacing.paddingLG,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: Icon(Icons.person, size: 15),
                                          ),
                                          UIHelpers.horizontalSpaceSM,
                                          Text(
                                            "Nombre",
                                            style: AppTypography.h5,
                                          ),
                                        ],
                                      ),

                                      UIHelpers.verticalSpaceSM,
                                      Text(
                                        "${state.myUser.name} ${state.myUser.lastName}",
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

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

                            // Glassmorphism divider
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.gray300.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            CustomNavTile(
                              isLogout: true,
                              icon: Icons.logout,
                              title: "Cerrar sesión",
                              onTap: () =>
                                  controller.showLogoutConfirmation(context),
                            ),
                            UIHelpers.verticalSpaceLG,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
          child: InkWell(
            onTap: () => controller.changeMenuWidth(state.width != 0 ? 0 : 280),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Material(
              color: AppColors.primaryDark.withOpacity(0.6),
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              ),
              child: Container(
                height: 50,
                width: 50,
                child: Icon(
                  state.width != 0 ? Icons.arrow_back : Icons.arrow_forward,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

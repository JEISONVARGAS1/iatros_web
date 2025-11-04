import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/uikit/components/cards/glassmorphism_card.dart';
import 'package:iatros_web/features/home/pages/home_page.dart';
import 'package:iatros_web/features/profile/pages/profile_page.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';
import 'package:iatros_web/features/patients_seek/pages/patients_page.dart';

class LobbyPage extends ConsumerStatefulWidget {
  const LobbyPage({super.key});

  @override
  ConsumerState<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends ConsumerState<LobbyPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lobbyControllerProvider).value!;
    final controller = ref.read(lobbyControllerProvider.notifier);

    if (_tabController.index != state.selectedIndex) {
      _tabController.animateTo(state.selectedIndex);
    }


    return Scaffold(
      body: SimpleMedicalBackground(
        child: Scaffold(
          backgroundColor: AppColors.gray50,
          body: Row(
            children: [
              Container(
                width: 280,
                child: Stack(
                  children: [
                    // Background with subtle gradient
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
                    // Glassmorphism effect
                    ClipRRect(
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
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // --- NAV ITEMS ---
                                _buildNavTile(
                                  title: "Inicio",
                                  icon: Icons.dashboard_outlined,
                                  selected: state.selectedIndex == 0,
                                  onTap: () => controller.changeIndex(0),
                                ),
                                _buildNavTile(
                                  title: "Pacientes",
                                  icon: Icons.people_outline,
                                  selected: state.selectedIndex == 1,
                                  onTap: () => controller.changeIndex(1),
                                ),
                                _buildNavTile(
                                  title: "Perfil",
                                  icon: Icons.person_outline,
                                  selected: state.selectedIndex == 2,
                                  onTap: () => controller.changeIndex(2),
                                ),

                                const Spacer(),

                                // Glassmorphism divider
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
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

                                _buildNavTile(
                                  title: "Cerrar sesión",
                                  icon: Icons.logout,
                                  isLogout: true,
                                  onTap: () => controller.logout(),
                                ),
                                SizedBox(height: context.sizeHeight(0.02)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 30),

              // --- MAIN CONTENT ---
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: context.sizeHeight(0.07),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: const [HomePage(), PatientsPage(), ProfilePage()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool selected = false,
    bool isLogout = false,
  }) {
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
                : AppColors.white.withOpacity(0.1),
            width: selected ? 2.0 : 1.5,
          ),
          backgroundColor: selected
              ? AppColors.primary.withOpacity(0.1)
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
              size: 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isLogout
                    ? AppColors.error
                    : selected
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w300,
                fontSize: selected ? 16 : 15,
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

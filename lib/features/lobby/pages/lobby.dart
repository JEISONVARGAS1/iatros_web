import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/home/pages/home_page.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/features/profile/pages/profile_page.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';
import 'package:iatros_web/features/patients_seek/pages/patients_page.dart';
import 'package:iatros_web/features/lobby/pages/widget/custom_drawer_menu.dart';
import 'package:iatros_web/features/lobby/pages/widget/company_selection_panel.dart';

class LobbyPage extends ConsumerStatefulWidget {
  const LobbyPage({super.key});

  @override
  ConsumerState<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends ConsumerState<LobbyPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ref.read(lobbyControllerProvider.notifier).initPage(this),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lobbyState = ref.watch(lobbyControllerProvider);

    if (lobbyState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (lobbyState.hasError) {
      return Scaffold(body: Center(child: Text('Error: ${lobbyState.error}')));
    }

    final state = lobbyState.value!;
    final controller = ref.read(lobbyControllerProvider.notifier);

    if (state.tabController != null &&
        state.tabController!.index != state.selectedIndex) {
      state.tabController!.animateTo(state.selectedIndex);
    }

    return SlidingUpPanel(
      minHeight: 0,
      isDraggable: false,
      backdropEnabled: true,
      backdropTapClosesPanel: false,
      controller: state.panelController,
      maxHeight: context.sizeHeight(0.7),
      panel: const CompanySelectionPanel(),
      backdropColor: Colors.black.withOpacity(0.5),
      body: Scaffold(
        backgroundColor: AppColors.gray50,
        body: Stack(
          children: [
            Row(
              children: [
                CustomDrawerMenu(state: state, controller: controller),
                Expanded(
                  child: state.tabController != null
                      ? TabBarView(
                          controller: state.tabController,
                          children: [
                            SimpleMedicalBackground(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.3),
                                      AppColors.primaryDark,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 500,
                                      width: 500,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: AssetImage(
                                            "assets/image/iatros2.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "IAtros: Tecnología al servicio del bienestar.",
                                          style: AppTypography.h1.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                        Text(
                                          "Innovación que cuida: La nueva era del bienestar con IAtros.",
                                          style: AppTypography.h5.copyWith(
                                            color: AppColors.primaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            HomePage(),
                            PatientsPage(),
                            ProfilePage(),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: state.width,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () =>
                        controller.changeMenuWidth(state.width != 0 ? 0 : 280),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Material(
                      elevation: 2,
                      color: AppColors.primaryDark.withOpacity(0.55),
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10),
                        bottomEnd: Radius.circular(10),
                      ),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          state.width != 0
                              ? Icons.arrow_back
                              : Icons.arrow_forward,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

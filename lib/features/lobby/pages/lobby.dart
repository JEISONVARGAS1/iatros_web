import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/home/pages/home_page.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/features/profile/pages/profile_page.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';
import 'package:iatros_web/features/patients_seek/pages/patients_page.dart';
import 'package:iatros_web/features/lobby/pages/widget/custom_drawer_menu.dart';

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
    final state = ref.watch(lobbyControllerProvider).value!;
    final controller = ref.read(lobbyControllerProvider.notifier);

    if (state.tabController!.index != state.selectedIndex) {
      state.tabController!.animateTo(state.selectedIndex);
    }

    return Scaffold(
      body: SimpleMedicalBackground(
        child: Scaffold(
          backgroundColor: AppColors.gray50,
          body: Row(
            children: [
              CustomDrawerMenu(state: state, controller: controller),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: context.sizeHeight(0.07),
                  ),
                  child: TabBarView(
                    controller: state.tabController,
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
}

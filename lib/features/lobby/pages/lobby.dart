import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/home/pages/home_page.dart';
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
      backgroundColor: AppColors.gray50,
      body: Stack(
        children: [
          Row(
            children: [
              CustomDrawerMenu(state: state, controller: controller),
              Expanded(
                child: TabBarView(
                  controller: state.tabController,
                  children: const [HomePage(), PatientsPage(), ProfilePage()],
                ),
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
                padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () =>
                      controller.changeMenuWidth(state.width != 0 ? 0 : 280),
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
                        state.width != 0
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

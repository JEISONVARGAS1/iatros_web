import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';
import 'package:iatros_web/features/profile/pages/widgets/settings_widget.dart';
import 'package:iatros_web/features/profile/pages/widgets/user_edit_widget.dart';
import 'package:iatros_web/features/profile/pages/widgets/custom_profile_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ref.read(profileControllerProvider.notifier).init(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider).value!;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Perfil'),
              Tab(text: 'Editar Usuario'),
              Tab(text: 'Configuración'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Profile Tab
                CustomProfilePage(controller: controller, state: state),

                // Edit User Tab
                const UserEditWidget(),

                // Settings Tab
                SettingsWidget(controller: controller, state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

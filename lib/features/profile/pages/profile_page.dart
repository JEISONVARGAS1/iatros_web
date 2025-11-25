import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';
import 'package:iatros_web/features/profile/pages/widgets/settings_widget.dart';
import 'package:iatros_web/features/profile/pages/widgets/user_edit_widget.dart';

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

    final authState = ref.watch(authControllerProvider);

    final name =
        '${authState.user?.name ?? ''} ${authState.user?.lastName ?? ''}'
            .trim();

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
                Padding(
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
                                    name.isEmpty ? 'Usuario' : name,
                                    style: AppTypography.h4,
                                  ),
                                  UIHelpers.verticalSpaceSM,
                                  Text(
                                    'Correo: ${authState.user?.email ?? '-'}',
                                    style: AppTypography.bodyMedium,
                                  ),
                                  if (authState.user?.medicalLicense !=
                                      null) ...[
                                    UIHelpers.verticalSpaceSM,
                                    Text(
                                      'Licencia médica: ${authState.user?.medicalLicense}',
                                      style: AppTypography.bodyMedium,
                                    ),
                                  ],
                                  if (authState.user?.specialization !=
                                      null) ...[
                                    UIHelpers.verticalSpaceSM,
                                    Text(
                                      'Especialización: ${authState.user?.specialization}',
                                      style: AppTypography.bodyMedium,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

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

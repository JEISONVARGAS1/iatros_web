import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/patients_seek/pages/widget/card_user.dart';
import 'package:iatros_web/features/patients_seek/provider/patients_seek_controller.dart';

class PatientsPage extends ConsumerStatefulWidget {
  const PatientsPage({super.key});

  @override
  ConsumerState<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends ConsumerState<PatientsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientsSeekControllerProvider).value!;
    final controller = ref.read(patientsSeekControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UIHelpers.verticalSpaceXL,
          // Título
          Text('paciente', style: AppTypography.h3),
          UIHelpers.verticalSpaceLG,
          // Buscador estilo Google
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Material(
                elevation: 4,
                shadowColor: Colors.black12,
                borderRadius: BorderRadius.circular(32),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Buscar paciente por documento...',
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: 
                    
                    state.users.isEmpty ?
                    IconButton(
                      tooltip: 'Buscar',
                      icon: const Icon(Icons.send, color: Colors.grey),
                      onPressed: () {
                        controller.searchUsers(_searchController.text);
                      },
                    ) :
                     IconButton(
                      tooltip: 'Limpiar',
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        controller.cleanSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: const BorderSide(color: AppColors.gray200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: const BorderSide(color: AppColors.gray200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          UIHelpers.verticalSpaceXL,
          state.users.isNotEmpty
              ? Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.users.length,
                        separatorBuilder: (_, __) => UIHelpers.verticalSpaceSM,
                        itemBuilder: (context, index) => CardUser(
                          user: state.users[index],
                          goToPatient: (user) =>
                              controller.goToPatient(context, user),
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          UIHelpers.verticalSpaceLG,
          SecondaryButton(
            label: "Crear nuevo usuario",
            onPressed: () async {
              await controller.showCreatePatients(
                context,
                title: "Crear paciente",
                goToPatient: (user) {
                  if (user.id != null && context.mounted) {
                    controller.goToPatient(context, user);
                  }
                },
                description:
                    "Ingresa los datos iniciales de un paciente para poder dar inicio con su historial medico",
              );
            },
          ),
        ],
      ),
    );
  }
}

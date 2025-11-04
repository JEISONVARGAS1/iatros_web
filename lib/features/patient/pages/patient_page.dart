import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:iatros_web/features/patient/provider/patient_controller.dart';
import 'package:iatros_web/features/patient/pages/widget/objective_physical_examination.dart';

class PatientPage extends ConsumerStatefulWidget {
  final String userId;

  const PatientPage({super.key, required this.userId});

  @override
  ConsumerState<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends ConsumerState<PatientPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) =>
          ref.read(patientControllerProvider.notifier).initPage(widget.userId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientControllerProvider).value!;
    final controller = ref.watch(patientControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelpers.verticalSpaceLG,
            Text("Paciente", style: AppTypography.h1),
            UIHelpers.verticalSpaceLG,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna de datos personales
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.paddingMD),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Datos Personales', style: AppTypography.h4),
                              UIHelpers.verticalSpaceMD,
                              if (state.selectedPatient != null) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildPersonalDataRow(
                                        'Nombre',
                                        state.selectedPatient!.name,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildPersonalDataRow(
                                        'Apellido',
                                        state.selectedPatient!.lastName,
                                      ),
                                    ),
                                  ],
                                ),
                                UIHelpers.verticalSpaceLG,
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildPersonalDataRow(
                                        'Número de Cédula',
                                        state
                                            .selectedPatient!
                                            .identificationNumber,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildPersonalDataRow(
                                        'Número Telefónico',
                                        state.selectedPatient!.phone,
                                      ),
                                    ),
                                  ],
                                ),

                                UIHelpers.verticalSpaceLG,
                                _buildPersonalDataRow(
                                  'Correo Electrónico',
                                  state.selectedPatient!.email,
                                ),
                                UIHelpers.verticalSpaceLG,
                              ] else ...[
                                const Center(
                                  child: Text('Seleccione un paciente'),
                                ),
                              ],

                              UIHelpers.verticalSpaceLG,

                              Text('Diagnósticos', style: AppTypography.h4),

                              UIHelpers.verticalSpaceMD,
                              MultiSelectDropdown<DiagnosisModel>(
                                options: state.diagnosesFound,
                                hint: 'Buscar y seleccionar diagnósticos...',
                                selectedItems: state.selectedDiagnoses,
                                onChanged: (diagnoses) {
                                  controller.updateSelectedDiagnoses(diagnoses);
                                },
                                displayText: (diagnosis) =>
                                    '${diagnosis.name} (${diagnosis.code})',
                                onSearch: (query) async =>
                                    await controller.searchDiagnoses(query),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  UIHelpers.horizontalSpaceLG,
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.paddingMD),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Consulta Médica', style: AppTypography.h4),
                              UIHelpers.verticalSpaceLG,
                              ObjectivePhysicalExamination(
                                state: state,
                                controller: controller,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Wrap(
        children: [
          Text('$label: ', style: AppTypography.label),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

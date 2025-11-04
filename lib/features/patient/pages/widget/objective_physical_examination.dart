import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iatros_web/features/patient/provider/model/patient_state.dart';
import 'package:iatros_web/features/patient/provider/patient_controller.dart';
import 'package:iatros_web/uikit/index.dart' hide TextInput;
import 'package:iatros_web/uikit/components/inputs/text_input.dart'
    as CustomTextInput;

class ObjectivePhysicalExamination extends StatelessWidget {
  final PatientState state;
  final PatientController controller;

  const ObjectivePhysicalExamination({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextInput.TextInput(
            label: 'Motivo de la consulta',
            controller: state.reasonController,
            maxLines: 3,
          ),
          UIHelpers.verticalSpaceMD,
          CustomTextInput.TextInput(
            label: 'Enfermedad actual y revisión por sistemas',
            controller: state.diseaseAndReviewBySystemsController,
            maxLines: 3,
          ),
          UIHelpers.verticalSpaceMD,
          CustomTextInput.TextInput(
            label: 'Antecedentes',
            controller: state.backgroundController,
            maxLines: 3,
          ),
          UIHelpers.verticalSpaceLG,
          Text('Objetivo - Examen fisico', style: AppTypography.h5),
          UIHelpers.verticalSpaceMD,

          Row(
            children: [
              Expanded(
                child: CustomTextInput.TextInput(
                  label: 'FC',
                  maxLength: 3,
                  hint: "Frecuencia cardíaca",
                  controller: state.fcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(text: "TA", style: AppTypography.label),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextInput.TextInput(
                            maxLength: 3,
                            hint: "Sistólica",
                            keyboardType: TextInputType.number,
                            controller: state.systolicController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        UIHelpers.horizontalSpaceMD,
                        Expanded(
                          child: CustomTextInput.TextInput(
                            hint: "Diastólica",
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            controller: state.diastolicController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: CustomTextInput.TextInput(
                  label: 'TAM',
                  maxLength: 3,
                  isReadOnly: true,
                  hint: "Tension arterial media",
                  controller: state.tamController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: CustomTextInput.TextInput(
                  label: 'FR',
                  maxLength: 2,
                  controller: state.frController,
                  hint: "Frecuencia respiratoria",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: CustomTextInput.TextInput(
                  label: 'T',
                  maxLength: 2,
                  hint: "Temperatura corporal",
                  controller: state.tController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),

          UIHelpers.verticalSpaceMD,
          Row(
            children: [
              Expanded(
                child: CustomTextInput.TextInput(
                  maxLength: 2,
                  label: 'SO2 (%)',
                  hint: "Saturación de oxígeno",
                  controller: state.so2Controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: CustomTextInput.TextInput(
                  maxLength: 3,
                  label: 'Altura',
                  hint: "Metros",
                  controller: state.heightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: CustomTextInput.TextInput(
                  hint: "Kg",
                  label: 'Peso',
                  controller: state.weightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: CustomTextInput.TextInput(
                  label: 'IMC',
                  hint: "Índice de masa corporal",
                  controller: state.imcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),

          UIHelpers.verticalSpaceLG,

          // Paraclínicos
          CustomTextInput.TextInput(
            label: 'Paraclínicos',
            controller: state.paraclinicalController,
            maxLines: 5,
          ),
          UIHelpers.verticalSpaceLG,

          Center(
            child: PrimaryButton(
              label: 'Guardar Consulta',
              onPressed: () => controller.saveConsultation(context),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';

class DoctorFilterCard extends StatelessWidget {
  final Function() cleanFilter;
  final UserModel? doctorSelected;
  final String selectedSpecialization;
  final List<UserCompanyModel> doctors;
  final Function(String?) selectSpecialization;
  final Function(UserCompanyModel) onDoctorSelected;
  final TextEditingController searchDoctorController;

  const DoctorFilterCard({
    super.key,
    required this.doctors,
    required this.cleanFilter,
    required this.doctorSelected,
    required this.onDoctorSelected,
    required this.selectSpecialization,
    required this.selectedSpecialization,
    required this.searchDoctorController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.sizeHeight(0.04)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          minHeight: context.sizeHeight(0.5),
          maxHeight: context.sizeHeight(0.5),
        ),

        child: BaseCard(
          elevation: 4.0,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filtros de Médicos', style: AppTypography.h5),
                    IconButton(
                      onPressed: cleanFilter,
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                UIHelpers.verticalSpaceSM,
                TextField(
                  controller: searchDoctorController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                UIHelpers.verticalSpaceLG,
                SpecializationSelector(
                  onChanged: selectSpecialization,
                  selectedSpecialization: selectedSpecialization,
                ),
                UIHelpers.verticalSpaceLG,
                const Text('Doctores filtrados:', style: AppTypography.label),
                UIHelpers.verticalSpaceXS,
                if (doctors.isEmpty)
                  Column(
                    children: [
                      UIHelpers.verticalSpaceXL,
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryDark,
                            width: 2,
                          ),
                        ),
                        child: Icon(Icons.person_off_outlined),
                      ),
                      UIHelpers.verticalSpaceMD,
                      Text('No hay doctores'),
                      UIHelpers.verticalSpaceXL,
                    ],
                  )
                else
                  ...doctors.map(_cardDoctor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardDoctor(UserCompanyModel doctor) {
    return Material(
      color: _backgroundColor(doctor.user!, doctorSelected),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onDoctorSelected(doctor),
        child: Container(
          padding: EdgeInsetsGeometry.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor(doctor.user!, doctorSelected)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${doctor.user!.name} ${doctor.user!.lastName}",
                    style: AppTypography.h5,
                  ),
                  Text(doctor.user!.email, style: AppTypography.bodySmall),
                ],
              ),
              Visibility(
                visible: doctorSelected?.id == doctor.id,
                child: Icon(Icons.check_circle, color: AppColors.primaryDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _backgroundColor(UserModel doctor, UserModel? doctorSelected) {
  if (doctorSelected != null && doctor.id == doctorSelected.id) {
    return AppColors.primary.withOpacity(0.3);
  }
  return AppColors.white;
}

Color _borderColor(UserModel doctor, UserModel? doctorSelected) {
  if (doctorSelected != null && doctor.id == doctorSelected.id) {
    return AppColors.primaryDark;
  }
  return AppColors.primary.withOpacity(0.3);
}

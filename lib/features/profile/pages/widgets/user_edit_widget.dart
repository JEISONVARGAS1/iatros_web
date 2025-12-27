import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/uikit/index.dart';

class UserEditWidget extends ConsumerStatefulWidget {
  const UserEditWidget({super.key});

  @override
  ConsumerState<UserEditWidget> createState() => _UserEditWidgetState();
}

class _UserEditWidgetState extends ConsumerState<UserEditWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _specializationController;
  late TextEditingController _medicalLicenseController;
  late TextEditingController _yearsExperienceController;
  late TextEditingController _biographyController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).value!.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _specializationController = TextEditingController(text: user?.specialization ?? '');
    _medicalLicenseController = TextEditingController(text: user?.medicalLicense ?? '');
    _yearsExperienceController = TextEditingController(text: user?.yearsOfExperience.toString() ?? '');
    _biographyController = TextEditingController(text: user?.professionalBiography ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _medicalLicenseController.dispose();
    _yearsExperienceController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {/* 
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier); */

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingLG),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Editar Información Personal', style: AppTypography.h4),
            UIHelpers.verticalSpaceLG,

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo requerido';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                  return 'Correo inválido';
                }
                return null;
              },
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _specializationController,
              decoration: const InputDecoration(
                labelText: 'Especialización',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _medicalLicenseController,
              decoration: const InputDecoration(
                labelText: 'Licencia Médica',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _yearsExperienceController,
              decoration: const InputDecoration(
                labelText: 'Años de Experiencia',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo requerido';
                final num = int.tryParse(value!);
                if (num == null || num < 0) return 'Número inválido';
                return null;
              },
            ),

            UIHelpers.verticalSpaceMD,

            TextFormField(
              controller: _biographyController,
              decoration: const InputDecoration(
                labelText: 'Biografía Profesional',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),

            UIHelpers.verticalSpaceLG,

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Update user logic here
                    // For now, just show success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Información actualizada')),
                    );
                  }
                },
                child: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
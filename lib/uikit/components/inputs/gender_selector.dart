import 'package:flutter/material.dart';
import '../../../core/models/gender.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class GenderSelector extends StatelessWidget {
  final ValueNotifier<Gender?>? selectedGenderNotifier;
  final ValueChanged<Gender?>? onChanged;
  final String? errorText;
  final bool isRequired;

  const GenderSelector({
    super.key,
    this.selectedGenderNotifier,
    this.onChanged,
    this.errorText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Gender?>(
      valueListenable: selectedGenderNotifier ?? ValueNotifier<Gender?>(null),
      builder: (context, selectedGender, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            RichText(
              text: TextSpan(
                text: 'Sexo',
                style: AppTypography.label,
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorText != null ? AppColors.error : AppColors.gray300,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                color: AppColors.surface,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Gender>(
                  value: selectedGender,
                  hint: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
                    child: Text('Selecciona tu sexo'),
                  ),
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
                        child: Text(gender.displayName),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (selectedGenderNotifier != null) {
                      selectedGenderNotifier!.value = value;
                    }
                    onChanged?.call(value);
                  },
                  style: AppTypography.bodyMedium.copyWith(
                    color: selectedGender == null
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSM),
                ),
              ),
            ),

            // Error text
            if (errorText != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                errorText!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}


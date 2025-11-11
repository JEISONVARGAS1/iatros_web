import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class IdentificationSelector extends StatefulWidget {
  final ValueNotifier<String?>? selectedTypeNotifier;
  final TextEditingController? numberController;
  final ValueChanged<String?>? onTypeChanged;
  final ValueChanged<String>? onNumberChanged;
  final String? errorText;
  final bool isRequired;

  const IdentificationSelector({
    super.key,
    this.selectedTypeNotifier,
    this.numberController,
    this.onTypeChanged,
    this.onNumberChanged,
    this.errorText,
    this.isRequired = false,
  });

  @override
  State<IdentificationSelector> createState() => _IdentificationSelectorState();
}

class _IdentificationSelectorState extends State<IdentificationSelector> {
  late TextEditingController _numberController;
  late ValueNotifier<String?> _typeNotifier;

  final List<String> _identificationTypes = ['CC', 'NIT', 'CE'];

  @override
  void initState() {
    super.initState();
    _numberController = widget.numberController ?? TextEditingController();
    _typeNotifier = widget.selectedTypeNotifier ?? ValueNotifier<String?>(null);

    _typeNotifier.addListener(() {
      widget.onTypeChanged?.call(_typeNotifier.value);
    });
  }

  @override
  void dispose() {
    if (widget.numberController == null) {
      _numberController.dispose();
    }
    if (widget.selectedTypeNotifier == null) {
      _typeNotifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: 'Identificación',
            style: AppTypography.label,
            children: [
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Row with type selector and number input
        Row(
          children: [
            // Type selector
            Container(
              width: 80,
              height: 45, // Match TextField height
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.errorText != null ? AppColors.error : AppColors.gray300,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                color: AppColors.surface,
              ),
              child: ValueListenableBuilder<String?>(
                valueListenable: _typeNotifier,
                builder: (context, selectedType, child) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedType,
                      hint: const Text('Tipo'),
                      items: _identificationTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSM),
                            child: Text(type),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _typeNotifier.value = value;
                      },
                      style: AppTypography.bodyMedium,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSM),
                      isExpanded: true,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Number input
            Expanded(
              child: TextFormField(
                controller: _numberController,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Número de identificación',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.error, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingMD,
                    vertical: AppSpacing.paddingMD,
                  ),
                ),
                keyboardType: TextInputType.number,
                enableInteractiveSelection: true,
                showCursor: true,
                onChanged: (value) {
                  widget.onNumberChanged?.call(value);
                },
              ),
            ),
          ],
        ),

        // Error text
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTypography.caption.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
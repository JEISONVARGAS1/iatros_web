import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class IdentificationSelector extends StatefulWidget {
  final String? selectedType;
  final String? identificationNumber;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String> onNumberChanged;
  final String? errorText;
  final bool isRequired;

  const IdentificationSelector({
    super.key,
    this.selectedType,
    this.identificationNumber,
    required this.onTypeChanged,
    required this.onNumberChanged,
    this.errorText,
    this.isRequired = false,
  });

  @override
  State<IdentificationSelector> createState() => _IdentificationSelectorState();
}

class _IdentificationSelectorState extends State<IdentificationSelector> {
  final TextEditingController _numberController = TextEditingController();

  final List<String> _identificationTypes = ['CC', 'NIT', 'CE'];

  @override
  void initState() {
    super.initState();
    _numberController.text = widget.identificationNumber ?? '';
    _numberController.addListener(() {
      widget.onNumberChanged(_numberController.text);
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.selectedType,
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
                    widget.onTypeChanged(value);
                  },
                  style: AppTypography.bodyMedium,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSM),
                  isExpanded: true,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Number input
            Expanded(
              child: TextField(
                controller: _numberController,
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
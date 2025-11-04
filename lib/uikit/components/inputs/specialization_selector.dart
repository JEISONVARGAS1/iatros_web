import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/medical_specialization.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class SpecializationSelector extends StatefulWidget {
  final String? selectedSpecialization;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final bool isRequired;

  const SpecializationSelector({
    super.key,
    this.selectedSpecialization,
    required this.onChanged,
    this.errorText,
    this.isRequired = false,
  });

  @override
  State<SpecializationSelector> createState() => _SpecializationSelectorState();
}

class _SpecializationSelectorState extends State<SpecializationSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<MedicalSpecialization> _filteredSpecializations = MedicalSpecializations.list;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSpecializations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSpecializations() {
    setState(() {
      _filteredSpecializations = MedicalSpecializations.search(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedSpec = widget.selectedSpecialization != null
        ? MedicalSpecializations.getById(widget.selectedSpecialization!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: 'Especialización Médica',
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

        // Selector
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.errorText != null ? AppColors.error : AppColors.gray300,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: Column(
            children: [
              // Selected item display
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingMD),
                  child: Row(
                    children: [
                      if (selectedSpec != null) ...[
                        Text(
                          selectedSpec.icon ?? '🏥',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedSpec.name,
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                selectedSpec.description,
                                style: AppTypography.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.medical_services,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Selecciona tu especialización',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),

              // Dropdown content
              if (_isExpanded) ...[
                const Divider(height: 1),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: Column(
                    children: [
                      // Search field
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.paddingSM),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar especialización...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.paddingSM,
                              vertical: AppSpacing.paddingXS,
                            ),
                          ),
                        ),
                      ),

                      // Specializations list
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredSpecializations.length,
                          itemBuilder: (context, index) {
                            final spec = _filteredSpecializations[index];
                            final isSelected = spec.id == widget.selectedSpecialization;

                            return InkWell(
                              onTap: () {
                                widget.onChanged(spec.id);
                                setState(() {
                                  _isExpanded = false;
                                  _searchController.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.paddingMD),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      spec.icon ?? '🏥',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            spec.name,
                                            style: AppTypography.bodyMedium.copyWith(
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            spec.description,
                                            style: AppTypography.caption,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
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


import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../utils/ui_helpers.dart';

class MultiSelectDropdown<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final List<T> options;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onChanged;
  final String Function(T) displayText;
  final String? errorText;
  final bool isRequired;
  final Future<void> Function(String)? onSearch;

  const MultiSelectDropdown({
    super.key,
    this.hint,
    this.label,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
    required this.displayText,
    this.errorText,
    this.isRequired = false,
    this.onSearch,
  });

  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = widget.options.where((option) {
      return widget
          .displayText(option)
          .toLowerCase()
          .contains(_searchText.toLowerCase());
    }).toList();

    final showDropdown = true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        widget.label != null
            ? RichText(
                text: TextSpan(
                  text: widget.label,
                  style: AppTypography.label,
                  children: [
                    if (widget.isRequired)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.error),
                      ),
                  ],
                ),
              )
            : Container(),
        widget.label != null ? SizedBox(height: AppSpacing.sm) : Container(),

        // Search input (always visible) - Google-style
        Material(
          elevation: 4,
          shadowColor: Colors.black12,
          borderRadius: BorderRadius.circular(32),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: widget.hint,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 20,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchText.isNotEmpty
                  ? IconButton(
                      tooltip: 'Limpiar',
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchText = '';
                        });
                        if (widget.onSearch != null) {
                          widget.onSearch!('');
                        }
                      },
                    )
                  : null,
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
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
              if (widget.onSearch != null) {
                widget.onSearch!(value);
              }
            },
          ),
        ),

        // Selected items display (below search)
        if (widget.selectedItems.isNotEmpty) ...[
          UIHelpers.verticalSpaceSM,
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: widget.selectedItems.map((item) {
              return Chip(
                label: Text(
                  widget.displayText(item),
                  style: AppTypography.caption,
                ),
                onDeleted: () {
                  final newSelected = List<T>.from(widget.selectedItems)
                    ..remove(item);
                  widget.onChanged(newSelected);
                },
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                deleteIconColor: AppColors.primary,
              );
            }).toList(),
          ),
        ],

        // Dropdown content
        if (showDropdown) ...[
          UIHelpers.verticalSpaceSM,
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              border: Border.all(
                color: AppColors.textSecondary.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                final option = filteredOptions[index];
                final isSelected = widget.selectedItems.contains(option);

                return InkWell(
                  onTap: () {
                    final newSelected = List<T>.from(widget.selectedItems);
                    if (isSelected) {
                      newSelected.remove(option);
                    } else {
                      newSelected.add(option);
                    }
                    widget.onChanged(newSelected);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingMD),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            final newSelected = List<T>.from(
                              widget.selectedItems,
                            );
                            if (value == true) {
                              newSelected.add(option);
                            } else {
                              newSelected.remove(option);
                            }
                            widget.onChanged(newSelected);
                          },
                          activeColor: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            widget.displayText(option),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],

        // Error text
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}


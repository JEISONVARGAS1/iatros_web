import 'package:flutter/material.dart';
import 'package:iatros_web/core/services/google_places_service.dart';
import 'package:iatros_web/core/models/address_location_model.dart';
import 'package:iatros_web/core/models/place_details.dart';
import 'package:iatros_web/core/util/debouncer_util.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class AddressAutocompleteInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String> onAddressSelected;
  final ValueChanged<PlaceDetails>? onPlaceDetailsSelected;
  final String? errorText;
  final bool isRequired;
  final TextEditingController? controller;

  const AddressAutocompleteInput({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    required this.onAddressSelected,
    this.onPlaceDetailsSelected,
    this.errorText,
    this.isRequired = false,
    this.controller,
  });

  @override
  State<AddressAutocompleteInput> createState() => _AddressAutocompleteInputState();
}

class _AddressAutocompleteInputState extends State<AddressAutocompleteInput> {
  late TextEditingController _controller;
  late DebouncerUtil _debouncer;
  List<AddressLocationModel> _predictions = [];
  bool _isLoading = false;
  bool _showPredictions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debouncer = DebouncerUtil(seconds: 1); // 1 segundo de delay
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _removeOverlay();
    _debouncer.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showPredictions = false;
      });
      _removeOverlay();
      return;
    }

    _debouncer.run(() {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showPredictions = false;
      });
      _removeOverlay();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final  predictions = await GooglePlacesService().searchAddressWeb(query);
      
      if (mounted) {
        setState(() {
          _predictions = predictions;
          _isLoading = false;
          _showPredictions = predictions.isNotEmpty;
        });
        
        if (_showPredictions) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showPredictions = false;
        });
        _removeOverlay();
        print('Error al buscar direcciones: $e');
      }
    }
  }

  Future<void> _selectPrediction(AddressLocationModel prediction) async {
    _controller.text = prediction.description;
    setState(() {
      _showPredictions = false;
      _predictions = [];
    });
    _removeOverlay();

    // Obtener detalles completos del lugar
    try {
      final placeDetails = await GooglePlacesService.getPlaceDetails(prediction.placeId);
      if (placeDetails != null) {
        widget.onAddressSelected(placeDetails.formattedAddress);
        widget.onPlaceDetailsSelected?.call(placeDetails);
      } else {
        widget.onAddressSelected(prediction.description);
      }
    } catch (e) {
      print('Error al obtener detalles del lugar: $e');
      widget.onAddressSelected(prediction.description);
    }
  }

  void _showOverlay() {
    _removeOverlay();
    
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, renderBox.size.height + 4.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                border: Border.all(color: AppColors.gray300),
              ),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.paddingMD),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return InkWell(
                          onTap: () => _selectPrediction(prediction),
                          child: ListTile(
                            leading: const Icon(Icons.location_on, color: AppColors.primary),
                            title: Text(
                              prediction.mainText,
                              style: AppTypography.bodyMedium,
                            ),
                            subtitle: Text(
                              prediction.secondaryText,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            hoverColor: AppColors.gray50,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          RichText(
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
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        // Input field
        CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hint ?? 'Busca tu dirección',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppColors.error : AppColors.gray300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppColors.error : AppColors.gray300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppColors.error : AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMD,
                vertical: AppSpacing.paddingMD,
              ),
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.search, color: AppColors.textSecondary),
              errorText: widget.errorText,
            ),
            onTap: () {
              if (_predictions.isNotEmpty) {
                _showOverlay();
              }
            },
            onChanged: (value) {
              // El listener se encarga de la búsqueda
            },
            onEditingComplete: () {
              _removeOverlay();
            },
          ),
        ),
      ],
    );
  }
}


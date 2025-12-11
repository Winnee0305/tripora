import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/lodging_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/services/place_details_service.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';
import 'package:tripora/features/exploration/views/widgets/location_search_bar.dart';
import 'package:tripora/features/exploration/views/widgets/search_suggestion_section.dart';
import 'package:intl/intl.dart';

class AddEditLodgingBottomSheet extends StatefulWidget {
  final LodgingData? lodging;
  const AddEditLodgingBottomSheet({super.key, this.lodging});

  @override
  State<AddEditLodgingBottomSheet> createState() =>
      _AddEditLodgingBottomSheetState();
}

class _AddEditLodgingBottomSheetState extends State<AddEditLodgingBottomSheet> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedPlaceId = '';
  DateTime? _checkInDateTime;
  DateTime? _checkOutDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.lodging != null) {
      _nameController.text = widget.lodging!.name;
      _checkInDateTime = widget.lodging!.checkInDateTime;
      _checkOutDateTime = widget.lodging!.checkOutDateTime;

      // Load place name from place ID
      if (widget.lodging!.placeId.isNotEmpty) {
        _selectedPlaceId = widget.lodging!.placeId;
        _loadPlaceName(widget.lodging!.placeId);
      }
    }
  }

  Future<void> _loadPlaceName(String placeId) async {
    try {
      final placeDetails = await PlaceDetailsService().fetchPlaceDetails(
        placeId,
      );
      if (mounted && placeDetails != null) {
        setState(() {
          _locationController.text = placeDetails['name'] ?? 'Unknown location';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationController.text = 'Location selected';
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isCheckIn) async {
    final currentDateTime = isCheckIn
        ? (_checkInDateTime ?? DateTime.now())
        : (_checkOutDateTime ?? DateTime.now().add(const Duration(days: 1)));

    // Select date
    final date = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date == null) return;

    if (!mounted) return;

    // Select time
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDateTime),
    );

    if (time == null) return;

    setState(() {
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      if (isCheckIn) {
        _checkInDateTime = selectedDateTime;
        // Auto-adjust checkout if it's before checkin
        if (_checkOutDateTime != null &&
            _checkOutDateTime!.isBefore(selectedDateTime)) {
          _checkOutDateTime = selectedDateTime.add(const Duration(hours: 24));
        }
      } else {
        _checkOutDateTime = selectedDateTime;
      }
    });
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Select date & time';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.of(context).viewInsets;

    final isEditing = widget.lodging?.id.isNotEmpty ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: AppWidgetStyles.cardDecoration(context).copyWith(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFF8A3D), Color(0xFFFF6B3D)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.hotel,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? "Edit Lodging" : "Add Lodging",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lodging name field
              AppTextField(label: "Lodging Name", controller: _nameController),
              const SizedBox(height: 20),

              // Location field with search
              GestureDetector(
                onTap: () async {
                  final result =
                      await showModalBottomSheet<Map<String, String>>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (_) => _LocationSearchSheet(),
                      );

                  if (result != null) {
                    setState(() {
                      _locationController.text = result['name'] ?? '';
                      _selectedPlaceId = result['placeId'] ?? '';
                    });
                  }
                },
                child: AbsorbPointer(
                  child: AppTextField(
                    label: "Location",
                    controller: _locationController,
                    icon: Icons.search,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Check-in DateTime
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Check-in",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDateTime(context, true),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDateTime(_checkInDateTime),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _checkInDateTime == null
                                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Check-out DateTime
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Check-out",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDateTime(context, false),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDateTime(_checkOutDateTime),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _checkOutDateTime == null
                                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  if (isEditing) ...[
                    Expanded(
                      child: AppButton.textOnly(
                        text: 'Delete',
                        radius: 12,
                        minHeight: 48,
                        backgroundVariant: BackgroundVariant.danger,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete Lodging'),
                              content: const Text(
                                'Are you sure you want to delete this lodging?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.pop(context, 'delete');
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton.textOnly(
                      text: isEditing ? 'Update' : 'Add Lodging',
                      radius: 12,
                      minHeight: 48,
                      onPressed: () {
                        if (_nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter lodging name'),
                            ),
                          );
                          return;
                        }

                        if (_checkInDateTime == null ||
                            _checkOutDateTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select check-in and check-out times',
                              ),
                            ),
                          );
                          return;
                        }

                        if (_checkOutDateTime!.isBefore(_checkInDateTime!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Check-out must be after check-in'),
                            ),
                          );
                          return;
                        }

                        final lodging = LodgingData(
                          id: widget.lodging?.id ?? '',
                          name: _nameController.text,
                          placeId: _selectedPlaceId,
                          date: widget.lodging?.date ?? DateTime.now(),
                          checkInDateTime: _checkInDateTime!,
                          checkOutDateTime: _checkOutDateTime!,
                          sequence: widget.lodging?.sequence ?? 0,
                          lastUpdated: DateTime.now(),
                        );

                        Navigator.pop(context, lodging);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Location search sheet
class _LocationSearchSheet extends StatefulWidget {
  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => SearchSuggestionViewModel(),
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: AppWidgetStyles.cardDecoration(context).copyWith(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title
              Text(
                "Search Location",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Search bar
              const LocationSearchBar(),
              const SizedBox(height: 16),

              // Search suggestions
              Expanded(
                child: SearchSuggestionSection(
                  onItemSelected: (description, suggestion) {
                    if (!mounted) return;
                    final result = <String, String>{
                      'name': description,
                      'placeId': (suggestion['place_id'] as String?) ?? '',
                    };
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && Navigator.canPop(context)) {
                        Navigator.pop(context, result);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

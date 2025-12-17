import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/services/flight_autocomplete_service.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:intl/intl.dart';

class AddEditFlightBottomSheet extends StatefulWidget {
  final FlightData? flight;
  const AddEditFlightBottomSheet({super.key, this.flight});

  @override
  State<AddEditFlightBottomSheet> createState() =>
      _AddEditFlightBottomSheetState();
}

class _AddEditFlightBottomSheetState extends State<AddEditFlightBottomSheet> {
  final _flightNumberController = TextEditingController();
  final _airlineController = TextEditingController();
  final _departureAirportController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  DateTime? _departureDateTime;
  DateTime? _arrivalDateTime;

  final _flightService = FlightAutocompleteService();
  Timer? _debounceTimer;
  bool _isSearching = false;
  List<Map<String, dynamic>> _flightSuggestions = [];

  @override
  void initState() {
    super.initState();
    if (widget.flight != null) {
      _flightNumberController.text = widget.flight!.flightNumber;
      _airlineController.text = widget.flight!.airline;
      _departureAirportController.text = widget.flight!.departureAirport;
      _arrivalAirportController.text = widget.flight!.arrivalAirport;
      _departureDateTime = widget.flight!.departureDateTime;
      _arrivalDateTime = widget.flight!.arrivalDateTime;
    }

    // Add listener to flight number field for autocomplete
    _flightNumberController.addListener(_onFlightNumberChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _flightNumberController.removeListener(_onFlightNumberChanged);
    _flightNumberController.dispose();
    _airlineController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    super.dispose();
  }

  void _onFlightNumberChanged() {
    _debounceTimer?.cancel();

    final flightNumber = _flightNumberController.text.trim();
    if (flightNumber.isEmpty) {
      setState(() {
        _flightSuggestions = [];
        _isSearching = false;
      });
      return;
    }

    // Debounce the search by 800ms
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _searchFlight(flightNumber);
    });
  }

  Future<void> _searchFlight(String flightNumber) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _flightService.searchFlightByNumber(flightNumber);
      if (mounted) {
        setState(() {
          _flightSuggestions = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _selectFlightSuggestion(Map<String, dynamic> flight) {
    setState(() {
      _airlineController.text = flight['airline'] ?? '';
      _departureAirportController.text =
          '${flight['departureAirport']} (${flight['departureIata']})';
      _arrivalAirportController.text =
          '${flight['arrivalAirport']} (${flight['arrivalIata']})';

      // Parse scheduled times if available
      if (flight['departureScheduled'] != null) {
        try {
          _departureDateTime = DateTime.parse(flight['departureScheduled']);
        } catch (e) {
          print('Error parsing departure time: $e');
        }
      }

      if (flight['arrivalScheduled'] != null) {
        try {
          _arrivalDateTime = DateTime.parse(flight['arrivalScheduled']);
        } catch (e) {
          print('Error parsing arrival time: $e');
        }
      }

      _flightSuggestions = [];
    });
  }

  Future<void> _selectDateTime(bool isDeparture) async {
    if (!mounted) return;

    final base = isDeparture
        ? (_departureDateTime ?? DateTime.now())
        : (_arrivalDateTime ?? DateTime.now().add(const Duration(hours: 2)));

    // DATE POPUP (styled dialog)
    final DateTime? date = await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _StyledCalendarDialog(
        initialDate: base,
        title: isDeparture ? 'Select Departure Date' : 'Select Arrival Date',
      ),
    );

    if (date == null || !mounted) return;

    // TIME POPUP (Cupertino wheel dialog)
    final TimeOfDay? time = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _StyledTimePickerDialog(
        initialTime: TimeOfDay.fromDateTime(base),
        title: isDeparture ? 'Select Departure Time' : 'Select Arrival Time',
      ),
    );

    if (time == null || !mounted) return;

    setState(() {
      final selected = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      if (isDeparture) {
        _departureDateTime = selected;
        if (_arrivalDateTime != null && _arrivalDateTime!.isBefore(selected)) {
          _arrivalDateTime = selected.add(const Duration(hours: 2));
        }
      } else {
        _arrivalDateTime = selected;
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

    final isEditing = widget.flight?.id.isNotEmpty ?? false;

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
                        colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? "Edit Flight" : "Add Flight",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Flight number field with autocomplete
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      AppTextField(
                        label: "Flight Number",
                        controller: _flightNumberController,
                      ),
                      if (_isSearching)
                        Positioned(
                          right: 12,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Flight suggestions
                  if (_flightSuggestions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _flightSuggestions.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                        itemBuilder: (context, index) {
                          final flight = _flightSuggestions[index];
                          return ListTile(
                            dense: true,
                            onTap: () => _selectFlightSuggestion(flight),
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A90E2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.flight,
                                size: 16,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                            title: Text(
                              flight['airline'] ?? 'Unknown Airline',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${flight['departureIata']} → ${flight['arrivalIata']}',
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              // Airline field
              AppTextField(label: "Airline", controller: _airlineController),
              const SizedBox(height: 20),

              // Departure Airport field
              AppTextField(
                label: "Departure Airport",
                controller: _departureAirportController,
              ),
              const SizedBox(height: 20),

              // Arrival Airport field
              AppTextField(
                label: "Arrival Airport",
                controller: _arrivalAirportController,
              ),
              const SizedBox(height: 20),

              // Departure DateTime
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Departure Time",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDateTime(true),
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
                            _formatDateTime(_departureDateTime),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _departureDateTime == null
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

              // Arrival DateTime
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Arrival Time",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDateTime(false),
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
                            _formatDateTime(_arrivalDateTime),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _arrivalDateTime == null
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
                              title: const Text('Delete Flight'),
                              content: const Text(
                                'Are you sure you want to delete this flight?',
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
                      text: isEditing ? 'Update' : 'Add Flight',
                      radius: 12,
                      minHeight: 48,
                      onPressed: () {
                        if (_airlineController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter airline name'),
                            ),
                          );
                          return;
                        }

                        if (_departureAirportController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter departure airport'),
                            ),
                          );
                          return;
                        }

                        if (_arrivalAirportController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter arrival airport'),
                            ),
                          );
                          return;
                        }

                        if (_departureDateTime == null ||
                            _arrivalDateTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select departure and arrival times',
                              ),
                            ),
                          );
                          return;
                        }

                        if (_arrivalDateTime!.isBefore(_departureDateTime!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Arrival must be after departure'),
                            ),
                          );
                          return;
                        }

                        final flight = FlightData(
                          id: widget.flight?.id ?? '',
                          flightNumber: _flightNumberController.text,
                          airline: _airlineController.text,
                          departureAirport: _departureAirportController.text,
                          arrivalAirport: _arrivalAirportController.text,
                          departureDateTime: _departureDateTime!,
                          arrivalDateTime: _arrivalDateTime!,
                          date: widget.flight?.date ?? DateTime.now(),
                          sequence: widget.flight?.sequence ?? 0,
                          lastUpdated: DateTime.now(),
                        );

                        Navigator.pop(context, flight);
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

class _StyledTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final String title;

  const _StyledTimePickerDialog({
    required this.initialTime,
    required this.title,
  });

  @override
  State<_StyledTimePickerDialog> createState() =>
      _StyledTimePickerDialogState();
}

class _StyledTimePickerDialogState extends State<_StyledTimePickerDialog> {
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 5,
                initialDateTime: DateTime(0, 1, 1, _time.hour, _time.minute),
                onDateTimeChanged: (dt) {
                  _time = TimeOfDay.fromDateTime(dt);
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _time),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StyledCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  final String title;

  const _StyledCalendarDialog({required this.initialDate, required this.title});

  @override
  State<_StyledCalendarDialog> createState() => _StyledCalendarDialogState();
}

class _StyledCalendarDialogState extends State<_StyledCalendarDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              onDateChanged: (d) => _selectedDate = d,
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _selectedDate),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

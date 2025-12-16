import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/lodging_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/reusable_widgets/app_calendar_picker.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';
import 'package:tripora/features/exploration/views/widgets/location_search_bar.dart';
import 'package:tripora/features/exploration/views/widgets/search_suggestion_section.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/services/flight_autocomplete_service.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

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
    final value = _flightNumberController.text.trim();

    if (value.isEmpty) {
      setState(() {
        _flightSuggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _searchFlight(value);
    });
  }

  Future<void> _searchFlight(String flightNumber) async {
    setState(() => _isSearching = true);

    try {
      final results = await _flightService.searchFlightByNumber(flightNumber);
      if (mounted) {
        setState(() {
          _flightSuggestions = results;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  /// 🚫 NO bottom sheets here
  /// ✅ Cupertino modal popup (safe)
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

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Select date & time';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: AppWidgetStyles.cardDecoration(context).copyWith(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            Text(
              widget.flight == null ? 'Add Flight' : 'Edit Flight',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            AppTextField(
              label: 'Flight Number',
              controller: _flightNumberController,
            ),
            const SizedBox(height: 16),
            AppTextField(label: 'Airline', controller: _airlineController),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Departure Airport',
              controller: _departureAirportController,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Arrival Airport',
              controller: _arrivalAirportController,
            ),

            const SizedBox(height: 20),

            _dateTile(
              theme,
              'Departure Time',
              _formatDateTime(_departureDateTime),
              () => _selectDateTime(true),
            ),
            const SizedBox(height: 16),
            _dateTile(
              theme,
              'Arrival Time',
              _formatDateTime(_arrivalDateTime),
              () => _selectDateTime(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTile(
    ThemeData theme,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                Text(value),
              ],
            ),
          ),
        ),
      ],
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
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
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
              initialDate: _selected,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              onDateChanged: (d) => _selected = d,
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
                    onPressed: () => Navigator.pop(context, _selected),
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

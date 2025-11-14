import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';
import 'package:tripora/features/exploration/views/widgets/location_search_bar.dart';
import 'package:tripora/features/exploration/views/widgets/search_suggestion_section.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';

class AddEditItineraryBottomSheet extends StatefulWidget {
  final ItineraryData? itinerary;
  const AddEditItineraryBottomSheet({super.key, this.itinerary});

  @override
  State<AddEditItineraryBottomSheet> createState() =>
      _AddEditItineraryBottomSheetState();
}

class _AddEditItineraryBottomSheetState
    extends State<AddEditItineraryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryViewModel>();
    final theme = Theme.of(context);
    final padding = MediaQuery.of(context).viewInsets;

    final isEditing = widget.itinerary?.placeId.isNotEmpty ?? false;

    // Populate form if editing
    if (widget.itinerary != null && !vm.isEditingInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.populateFromItinerary(widget.itinerary!);
      });
    }

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
              // --- Handle bar
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
                isEditing ? "Edit Itinerary" : "Add New Itinerary",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // ----------------------------
              // Destination field with search
              // ----------------------------
              GestureDetector(
                onTap: () async {
                  final selected = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => _DestinationSearchSheet(vm: vm),
                  );

                  if (selected != null) {
                    vm.destinationController.text = selected;
                  }
                },
                child: AbsorbPointer(
                  child: AppTextField(
                    label: "Destination",
                    controller: vm.destinationController,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Notes
              AppTextField(label: "Notes", controller: vm.notesController),
              const SizedBox(height: 30),

              // Submit button
              Center(
                child: AppButton.textOnly(
                  text: isEditing ? "Update Itinerary" : "Add Itinerary",
                  minWidth: 150,
                  minHeight: 40,
                  onPressed: () {
                    if (!vm.validateForm()) {
                      return;
                    }

                    if (isEditing) {
                      print(
                        'Updating itinerary ${widget.itinerary!.toString()}',
                      );
                      vm.updateItinerary(widget.itinerary!);
                    } else {
                      print(
                        'Adding itinerary ${vm.destinationController.text}',
                      );

                      vm.addItinerary(widget.itinerary!);
                    }

                    vm.clearForm();
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (!vm.validateForm())
                Center(
                  child: Text(
                    "Please fill in all required fields.",
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------------
/// Destination Search Sheet
/// ------------------------------
class _DestinationSearchSheet extends StatefulWidget {
  final ItineraryViewModel vm;

  const _DestinationSearchSheet({super.key, required this.vm});

  @override
  State<_DestinationSearchSheet> createState() =>
      _DestinationSearchSheetState();
}

class _DestinationSearchSheetState extends State<_DestinationSearchSheet> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchSuggestionViewModel(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80),
              // Search bar
              LocationSearchBar(focusNode: _focusNode),
              const SizedBox(height: 12),

              // Search results
              Expanded(
                child: SearchSuggestionSection(
                  onItemSelected: (description, suggestion) {
                    // Update the passed-in ViewModel
                    widget.vm.destinationController.text = description;
                    widget.vm.selectedPlaceId =
                        suggestion['place_id'] as String;
                    Navigator.pop(context); // Close the modal
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

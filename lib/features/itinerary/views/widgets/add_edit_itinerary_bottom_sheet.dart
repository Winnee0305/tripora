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
  final bool isEditing;
  const AddEditItineraryBottomSheet({
    super.key,
    this.itinerary,
    this.isEditing = false,
  });

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

    // Use explicit isEditing parameter passed from caller
    final isEditing = widget.isEditing;

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
                widget.itinerary?.isNote ?? false
                    ? (isEditing ? "Edit Note" : "Add Note")
                    : (isEditing ? "Edit Itinerary" : "Add New Itinerary"),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // ----------------------------
              // Destination field with search (skip for notes)
              // ----------------------------
              if (!(widget.itinerary?.isNote ?? false)) ...[
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
                      readOnly: isEditing,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Notes
              AppTextField(
                label: widget.itinerary?.isNote ?? false ? "Note" : "Notes",
                controller: vm.notesController,
                maxLines: 5, // allow the field to grow up to 5 lines
                minLines: 3, // start with 3 lines height
                textInputAction:
                    TextInputAction.newline, // optional, allows Enter key
              ),
              const SizedBox(height: 30),

              // Submit button
              Center(
                child: isEditing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          AppButton.textOnly(
                            text: widget.itinerary?.isNote ?? false
                                ? "Delete Note"
                                : "Delete Itinerary",
                            minWidth: 150,
                            minHeight: 40,
                            backgroundColorOverride:
                                theme.colorScheme.errorContainer,
                            textColorOverride: theme.colorScheme.onPrimary,
                            onPressed: () async {
                              final isNote = widget.itinerary?.isNote ?? false;
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      isNote
                                          ? "Delete Note"
                                          : "Delete Itinerary",
                                    ),
                                    content: Text(
                                      isNote
                                          ? "Are you sure you want to delete this note? This action cannot be undone."
                                          : "Are you sure you want to delete this itinerary? This action cannot be undone.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                vm.deleteItinerary(widget.itinerary!);
                                vm.clearForm();
                                Navigator.pop(context); // close the screen
                              }
                            },
                          ),
                          AppButton.textOnly(
                            text: widget.itinerary?.isNote ?? false
                                ? "Update Note"
                                : "Update Itinerary",
                            minWidth: 150,
                            minHeight: 40,
                            onPressed: () {
                              final isNote = widget.itinerary?.isNote ?? false;
                              if (!vm.validateForm(isNote: isNote)) {
                                return;
                              }

                              // For notes, create updated note with new text
                              if (isNote) {
                                final updatedNote = widget.itinerary!.copyWith(
                                  userNotes: vm.notesController.text.trim(),
                                  lastUpdated: DateTime.now(),
                                );
                                vm.updateItinerary(updatedNote);
                              } else {
                                print(
                                  'Updating itinerary ${widget.itinerary!.toString()}',
                                );
                                vm.updateItinerary(widget.itinerary!);
                              }

                              vm.clearForm();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    : AppButton.textOnly(
                        text: widget.itinerary?.isNote ?? false
                            ? "Add Note"
                            : "Add Itinerary",
                        minWidth: 150,
                        minHeight: 40,
                        onPressed: () {
                          final isNote = widget.itinerary?.isNote ?? false;
                          if (!vm.validateForm(isNote: isNote)) {
                            return;
                          }

                          // For notes, return the itinerary with updated notes
                          if (isNote) {
                            final updatedNote = widget.itinerary!.copyWith(
                              userNotes: vm.notesController.text.trim(),
                              lastUpdated: DateTime.now(),
                            );
                            vm.clearForm();
                            Navigator.pop(context, updatedNote);
                          } else {
                            print(
                              'Adding itinerary ${vm.destinationController.text}',
                            );
                            vm.addItinerary(widget.itinerary!);
                            vm.clearForm();
                            Navigator.pop(context);
                          }
                        },
                      ),
              ),
              const SizedBox(height: 10),
              if (!vm.validateForm(isNote: widget.itinerary?.isNote ?? false))
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

  const _DestinationSearchSheet({required this.vm});

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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/expense/models/expense.dart';
import 'package:tripora/features/expense/viewmodels/expense_viewmodel.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';

// This bottom sheet is used for both adding and editing an expense.
class AddEditItineraryBottomSheet extends StatelessWidget {
  final ItineraryData? itinerary;
  const AddEditItineraryBottomSheet({super.key, this.itinerary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.of(context).viewInsets;
    final vm = context.watch<ItineraryViewModel>();

    // To populate the form if editing an existing expense
    if (itinerary != null && !vm.isEditingInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.populateFromItinerary(itinerary!);
      });
    }

    // Determine if we are adding or editing
    final isEditing = itinerary != null;

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
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // ----- Title
              Text(
                isEditing ? "Edit Itinerary" : "Add New Itinerary",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // // --- Amount
              // AppTextField(
              //   label: "Amount *",
              //   controller: vm.amountController,
              //   isNumber: true,
              // ),
              // const SizedBox(height: 20),

              // --- Expense Name
              AppTextField(
                label: "Destination *",
                controller: vm.destinationController,
              ),

              // const SizedBox(height: 20),

              // --- Description
              AppTextField(label: "Notes", controller: vm.notesController),
              const SizedBox(height: 20),

              // // --- Category Dropdown
              // AppTextField(
              //   label: "Category",
              //   controller: vm.categoryController,
              //   readOnly: true,
              //   chooseButton: true,
              //   onTap: () async {
              //     final selected = await showModalBottomSheet<ExpenseCategory>(
              //       context: context,
              //       shape: const RoundedRectangleBorder(
              //         borderRadius: BorderRadius.vertical(
              //           top: Radius.circular(20),
              //         ),
              //       ),
              //       builder: (context) {
              //         return ListView(
              //           padding: const EdgeInsets.all(20),
              //           shrinkWrap: true,
              //           children: vm.categories.map((category) {
              //             return ListTile(
              //               title: Text(category.name.capitalize()),
              //               onTap: () {
              //                 // Return the selected category to the caller
              //                 Navigator.pop(context, category);
              //               },
              //             );
              //           }).toList(),
              //         );
              //       },
              //     );

              //     // Handle the returned selection
              //     if (selected != null) {
              //       vm.setCategory(selected); // update ViewModel
              //       vm.categoryController.text = selected.name
              //           .capitalize(); // update field
              //     }
              //   },
              // ),
              const SizedBox(height: 30),

              // --- Submit Button
              Center(
                child: AppButton.textOnly(
                  text: isEditing ? "Update Itinerary" : "Add Itinerary",
                  textStyleVariant: TextStyleVariant.medium,
                  minWidth: 150,
                  minHeight: 40,
                  onPressed: () {
                    if (!vm.validateForm()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all required fileds."),
                        ),
                      );
                      return;
                    }

                    if (isEditing) {
                      vm.updateItinerary(itinerary!);
                    } else {
                      vm.addItinerary();
                    }
                    vm.clearForm();
                    Navigator.pop(context);
                  },
                  backgroundVariant: BackgroundVariant.primaryFilled,
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

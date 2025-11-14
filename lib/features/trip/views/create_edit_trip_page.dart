import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_change_picture_sheet.dart';
import 'package:tripora/core/reusable_widgets/app_toast.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/trip/views/widgets/create_trip/choose_travel_partner_page.dart';
import '../viewmodels/trip_viewmodel.dart';
import 'widgets/create_trip/choose_destination_page.dart';
import 'widgets/create_trip/choose_travel_style_page.dart';
import '../../../core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import '../../../core/reusable_widgets/calendar_range_picker.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';

class CreateEditTripPage extends StatefulWidget {
  final TripData? tripToEdit;

  const CreateEditTripPage({super.key, this.tripToEdit});

  @override
  State<CreateEditTripPage> createState() => _CreateEditTripPageState();
}

class _CreateEditTripPageState extends State<CreateEditTripPage> {
  late TripData draftTrip;
  DateTime? startDate;
  DateTime? endDate;
  DateTime focusedDay = DateTime.now();
  bool showOptionalFields = false;
  bool changedImage = false;

  bool get isEditing => draftTrip.tripId.isNotEmpty;

  @override
  void initState() {
    super.initState();
    draftTrip = widget.tripToEdit != null
        ? widget.tripToEdit!.copyWith()
        : TripData.empty();
    startDate = draftTrip.startDate;
    endDate = draftTrip.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final tripVm = context.watch<TripViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tripVm.isUploading) {
        AppToast(context, "Uploading trip...");
      }
    });

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky Header
            SliverPersistentHeader(
              pinned: true,
              delegate: AppStickyHeaderDelegate(
                minHeight: 80,
                maxHeight: 80,
                child: AppStickyHeader(
                  title: isEditing ? 'Edit Trip' : 'Create New Trip',
                  showRightButton: false,
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    //  1️⃣ Date Range
                    CalendarRangePicker(
                      startDate: startDate,
                      endDate: endDate,
                      onDateRangeChanged: (start, end) {
                        setState(() {
                          startDate = start;
                          endDate = end;
                          draftTrip = draftTrip.copyWith(
                            startDate: start,
                            endDate: end,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    //  2️⃣ Trip Name
                    AppTextField(
                      label: "Trip Name",
                      text: draftTrip.tripName,
                      onChanged: (v) => setState(() {
                        draftTrip = draftTrip.copyWith(tripName: v);
                      }),
                    ),
                    const SizedBox(height: 30),

                    // 3️⃣ Destination
                    AppTextField(
                      label: "Destination",
                      text: draftTrip.destination,
                      readOnly: true,
                      chooseButton: true,
                      onTap: () async {
                        final selectedDestination =
                            await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChooseDestinationPage(),
                              ),
                            );
                        if (selectedDestination != null) {
                          setState(() {
                            draftTrip = draftTrip.copyWith(
                              destination: selectedDestination,
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 30),

                    // 4️⃣ Trip Image
                    Text(
                      "Pick an image for your trip",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final imagePath = await AppChangePictureSheet.show(
                          context,
                        );
                        if (imagePath != null) {
                          setState(() {
                            draftTrip = draftTrip.copyWith(
                              tripImageUrl: imagePath,
                            );
                            changedImage = true;
                          });
                        }
                      },

                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                          image:
                              draftTrip.tripImageUrl != null &&
                                  draftTrip.tripImageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: changedImage
                                      ? FileImage(File(draftTrip.tripImageUrl!))
                                      : NetworkImage(draftTrip.tripImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child:
                            draftTrip.tripImageUrl == null ||
                                draftTrip.tripImageUrl!.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 5️⃣ Optional Fields Toggle
                    GestureDetector(
                      onTap: () => setState(
                        () => showOptionalFields = !showOptionalFields,
                      ),
                      child: Row(
                        children: [
                          Text(
                            showOptionalFields
                                ? "Hide Optional Info"
                                : "Show Optional Info",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Icon(
                            showOptionalFields
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Optional Fields
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: showOptionalFields
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  label: "Travel Style",
                                  text: draftTrip.travelStyle,
                                  readOnly: true,
                                  chooseButton: true,
                                  onTap: () async {
                                    final selectedStyle =
                                        await Navigator.push<String>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ChooseTravelStylePage(),
                                          ),
                                        );
                                    if (selectedStyle != null) {
                                      setState(() {
                                        draftTrip = draftTrip.copyWith(
                                          travelStyle: selectedStyle,
                                        );
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                AppTextField(
                                  label: "Travel Partner",
                                  text: draftTrip.travelPartnerType,
                                  readOnly: true,
                                  chooseButton: true,
                                  onTap: () async {
                                    final selectedPartner =
                                        await Navigator.push<String>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ChooseTravelPartnerPage(),
                                          ),
                                        );
                                    if (selectedPartner != null) {
                                      setState(() {
                                        draftTrip = draftTrip.copyWith(
                                          travelPartnerType: selectedPartner,
                                        );
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                AppTextField(
                                  label: "Number of Travelers",
                                  text: draftTrip.travelersCount.toString(),
                                  isNumber: true,
                                  onChanged: (v) => setState(() {
                                    draftTrip = draftTrip.copyWith(
                                      travelersCount: int.tryParse(v) ?? 0,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 30),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // 6️⃣ Action Buttons
                    Row(
                      children: [
                        if (isEditing)
                          Expanded(
                            child: AppButton.primary(
                              text: 'Delete Trip',
                              textStyleVariant: TextStyleVariant.medium,
                              backgroundVariant: BackgroundVariant.danger,
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Trip'),
                                    content: const Text(
                                      'Are you sure you want to delete this trip?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                          context,
                                          true,
                                        ), // pass true here
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await tripVm.deleteTrip(draftTrip.tripId);
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                }
                              },
                            ),
                          ),
                        if (isEditing) const SizedBox(width: 20),
                        Expanded(
                          child: Center(
                            child: AppButton.primary(
                              textStyleVariant: TextStyleVariant.medium,
                              text: isEditing ? 'Save Changes' : 'Create Trip',
                              onPressed: () async {
                                if (draftTrip.tripName.trim().isEmpty ||
                                    draftTrip.destination.trim().isEmpty ||
                                    draftTrip.startDate == null ||
                                    draftTrip.endDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please complete all required fields.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (isEditing) {
                                  await tripVm.writeTrip(draftTrip, false);
                                } else {
                                  print("Creating trip: $draftTrip");
                                  await tripVm.writeTrip(draftTrip, true);
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

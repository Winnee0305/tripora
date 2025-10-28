import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/trip/models/trip_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/trip/views/widgets/create_trip/choose_travel_partner_page.dart';
import '../viewmodels/trip_viewmodel.dart';
import 'widgets/create_trip/choose_destination_page.dart';
import 'widgets/create_trip/choose_travel_style_page.dart';
import '../../../core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import '../../../core/reusable_widgets/calendar_range_picker.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  // local form state (temporary)
  TripData draftTrip = TripData.empty();

  DateTime? startDate;
  DateTime? endDate;
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tripVm = context.read<TripViewModel>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: AppStickyHeaderDelegate(
                minHeight: 80,
                maxHeight: 80,
                child: AppStickyHeader(
                  title: 'Create New Trip',
                  showRightButton: false,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // ----- Date range picker
                    CalendarRangePicker(
                      focusedDay: focusedDay,
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
                      onFocusedDayChanged: (day) => setState(() {
                        focusedDay = day;
                      }),
                    ),

                    const SizedBox(height: 30),

                    AppTextField(
                      label: "Trip Name",
                      onChanged: (v) => setState(() {
                        draftTrip = draftTrip.copyWith(tripName: v);
                      }),
                    ),

                    const SizedBox(height: 30),

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

                    AppTextField(
                      label: "Travel Style (Optional)",
                      text: draftTrip.travelStyle,
                      readOnly: true,
                      chooseButton: true,
                      onTap: () async {
                        final selectedStyle = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChooseTravelStylePage(),
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

                    const SizedBox(height: 30),

                    AppTextField(
                      label: "Travel Partner (Optional)",
                      text: draftTrip.travelPartnerType,
                      readOnly: true,
                      chooseButton: true,
                      onTap: () async {
                        final selectedPartner = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChooseTravelPartnerPage(),
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

                    const SizedBox(height: 30),

                    AppTextField(
                      label: "Number of Travelers (Optional)",
                      isNumber: true,

                      onChanged: (v) => setState(() {
                        final count = int.tryParse(v) ?? 0;
                        draftTrip = draftTrip.copyWith(travelersCount: count);
                      }),
                    ),

                    const SizedBox(height: 50),

                    AppButton.primary(
                      text: 'Done',
                      onPressed: () async {
                        // validate required fields
                        if (draftTrip.tripName.isEmpty ||
                            draftTrip.destination.isEmpty ||
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

                        tripVm.createTrip(draftTrip);
                        Navigator.pop(context);
                      },
                    ),
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

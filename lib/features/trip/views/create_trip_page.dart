import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/trip/views/widgets/create_trip/choose_travel_partner_page.dart';
import '../viewmodels/create_trip_viewmodel.dart';
import 'widgets/create_trip/choose_destination_page.dart';
import 'widgets/create_trip/choose_travel_style_page.dart';
import '../../../core/widgets/app_sticky_header.dart';
import 'package:tripora/core/widgets/app_sticky_header_delegate.dart';
import '../../../core/widgets/calendar_range_picker.dart';
import 'package:tripora/core/widgets/app_text_field.dart';

class CreateTripPage extends StatelessWidget {
  const CreateTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateTripViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---------- Sticky Header ----------
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

            // ----- The rest of the form -----
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        // ----- Calendar Range Picker -----
                        CalendarRangePicker(
                          focusedDay: vm.focusedDay,
                          startDate: vm.startDate,
                          endDate: vm.endDate,
                          onDateRangeChanged: vm.setDateRange,
                          onFocusedDayChanged: vm.setFocusedDay,
                        ),

                        const SizedBox(height: 10),
                        Text(
                          vm.startDate != null && vm.endDate != null
                              ? "Selected: ${vm.startDate!.toLocal().toString().split(' ')[0]} → ${vm.endDate!.toLocal().toString().split(' ')[0]}"
                              : "Select your trip range",
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    AppTextField(label: "Trip Name", onChanged: vm.setTripName),
                    const SizedBox(height: 30),

                    AppTextField(
                      label: "Destination",
                      text: vm.trip.destination, // reactive from ViewModel
                      readOnly: true,
                      chooseButton: true,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: context.read<CreateTripViewModel>(),
                              child: const ChooseDestinationPage(),
                            ),
                          ),
                        );

                        if (result != null && result is String) {
                          vm.setDestination(
                            result,
                          ); // 👈 directly update CreateTripViewModel
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      label: "Travel Style (Optional)",
                      text: vm.trip.travelStyle, // reactive from ViewModel
                      readOnly: true,
                      chooseButton: true,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: context.read<CreateTripViewModel>(),
                              child: const ChooseTravelStylePage(),
                            ),
                          ),
                        );

                        if (result != null && result is String) {
                          vm.setTravelStyle(
                            result,
                          ); // 👈 directly update CreateTripViewModel
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      label: "Type of Travel Partner (Optional)",
                      text: vm.trip.travelPartner, // reactive from ViewModel
                      readOnly: true,
                      chooseButton: true,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: context.read<CreateTripViewModel>(),
                              child: const ChooseTravelPartnerPage(),
                            ),
                          ),
                        );

                        if (result != null && result is String) {
                          vm.setTravelPartner(
                            result,
                          ); // 👈 directly update CreateTripViewModel
                        }
                      },
                    ),
                    const SizedBox(height: 30),

                    AppTextField(
                      label: "Number of Travelers (Optional)",
                      isNumber: true,
                      onChanged: (value) {
                        final intValue =
                            int.tryParse(value) ?? 0; // safely parse
                        vm.setNumTravellers(intValue);
                      },
                    ),

                    const SizedBox(height: 50),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: const StadiumBorder(),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 12,
                        ),
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
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

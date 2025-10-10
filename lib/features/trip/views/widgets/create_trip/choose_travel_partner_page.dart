import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_button.dart';
import '../../../viewmodels/create_trip_viewmodel.dart';

class ChooseTravelPartnerPage extends StatelessWidget {
  const ChooseTravelPartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateTripViewModel>(context);
    final theme = Theme.of(context);

    final travelPartner = [
      {"name": "Solo", "image": "solo"},
      {"name": "Couple", "image": "couple"},
      {"name": "Family", "image": "family"},
      {"name": "Friends", "image": "friends"},
      {"name": "Business", "image": "business"},
      {"name": "Group Tour", "image": "group_tour"},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            // ----- Header
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Custom "AppBar" Section
              Text(
                "Choose your travel partner",
                style: theme.textTheme.headlineMedium?.weight(
                  ManropeFontWeight.semiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Select the your travel style so that we can make personalized recommendations for you.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Grid section
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: travelPartner.length,
                  itemBuilder: (context, index) {
                    final name = travelPartner[index]['name'];
                    final image = travelPartner[index]['image'];
                    final selected = vm.trip.travelPartner == name;
                    return GestureDetector(
                      onTap: () {
                        vm.setTravelPartner(name ?? '');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(30),
                          // border: Border.all(
                          //   color: selected
                          //       ? theme.colorScheme.primary
                          //       : Colors.transparent,
                          //   width: 3,
                          // ),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/travel_partner/${image}.png',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: selected
                                ? null // ✅ No dark overlay when selected
                                : ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.darken,
                                  ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          name ?? '',
                          textAlign: TextAlign.center,
                          style: selected
                              ? theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: ManropeFontWeight.extraBold,
                                )
                              : theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(0.7),
                                  fontWeight: ManropeFontWeight.semiBold,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Bottom Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 90, left: 90, bottom: 30),
        child: AppButton.primary(
          text: "Done",
          minHeight: 40,
          minWidth: 20,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

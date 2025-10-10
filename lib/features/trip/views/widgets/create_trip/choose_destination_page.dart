import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_button.dart';
import '../../../viewmodels/create_trip_viewmodel.dart';

class ChooseDestinationPage extends StatelessWidget {
  const ChooseDestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateTripViewModel>(context);
    final theme = Theme.of(context);

    final destinations = [
      {"name": "Selangor", "image": "selangor"},
      {"name": "Kuala Lumpur", "image": "kl"},
      {"name": "Penang", "image": "penang"},
      {"name": "Sabah", "image": "sabah"},
      {"name": "Sarawak", "image": "sarawak"},
      {"name": "Melaka", "image": "melaka"},
      {"name": "Pahang", "image": "pahang"},
      {"name": "Kedah", "image": "kedah"},
      {"name": "Johor", "image": "johor"},
      {"name": "Perak", "image": "perak"},
      {"name": "Terengganu", "image": "terengganu"},
      {"name": "Kelantan", "image": "kelantan"},
      {"name": "Negeri Sembilan", "image": "negeri_sembilan"},
      {"name": "Putrajaya", "image": "putrajaya"},
      {"name": "Labuan", "image": "labuan"},
      {"name": "Perlis", "image": "perlis"},
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
                "Choose your destination",
                style: theme.textTheme.headlineMedium?.weight(
                  ManropeFontWeight.semiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap to select a state in Malaysia that you wish to visit.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Grid section
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final name = destinations[index]['name'];
                    final image = destinations[index]['image'];
                    final selected = vm.trip.destination == name;
                    return GestureDetector(
                      onTap: () {
                        vm.setDestination(name ?? '');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/destination_selection/${image}.png',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: selected
                                ? null // ✅ No dark overlay when selected
                                : ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/utils/constants.dart';
import '../../../viewmodels/trip_viewmodel.dart';

class ChooseDestinationPage extends StatefulWidget {
  const ChooseDestinationPage({super.key});

  @override
  State<ChooseDestinationPage> createState() => _ChooseDestinationPageState();
}

class _ChooseDestinationPageState extends State<ChooseDestinationPage> {
  String? selectedDestination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: destinationsImageCoordinates.length,
                  itemBuilder: (context, index) {
                    final name =
                        destinationsImageCoordinates[index]['destination']
                            as String;
                    final image =
                        destinationsImageCoordinates[index]['imageName']
                            as String;
                    final isSelected = selectedDestination == name;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDestination = name;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/destination_selection/$image.png',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: isSelected
                                ? null
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
                          name!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: isSelected
                                ? ManropeFontWeight.extraBold
                                : ManropeFontWeight.semiBold,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 90, left: 90, bottom: 30),
        child: AppButton.primary(
          text: "Done",
          onPressed: () => Navigator.pop(context, selectedDestination),
        ),
      ),
    );
  }
}

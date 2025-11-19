import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';

class ChooseTravelStylePage extends StatefulWidget {
  const ChooseTravelStylePage({super.key});

  @override
  State<ChooseTravelStylePage> createState() => _ChooseTravelStylePageState();
}

class _ChooseTravelStylePageState extends State<ChooseTravelStylePage> {
  String? selectedTravelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final travelStyles = [
      {"name": "Leisure & Relaxation", "image": "leisure_relaxation"},
      {"name": "Adventure & Outdoor", "image": "adventure_outdoor"},
      {"name": "Urban Exploration", "image": "urban_exploration"},
      {"name": "Cultural & Historical", "image": "cultural_historical"},
      {"name": "Food & Culinary", "image": "food_culinary"},
      {"name": "Nature", "image": "nature"},
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
                "Choose your travel style",
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
                  itemCount: travelStyles.length,
                  itemBuilder: (context, index) {
                    final name = travelStyles[index]['name'];
                    final image = travelStyles[index]['image'];
                    final selected = selectedTravelStyle == name;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTravelStyle = name ?? '';
                        });
                      },

                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/travel_style/${image}.png',
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
          onPressed: () => Navigator.pop(context, selectedTravelStyle),
        ),
      ),
    );
  }
}

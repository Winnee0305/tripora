import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/trip/viewmodels/etiquette_education_viewmodel.dart';

class EtiquetteEducationSection extends StatelessWidget {
  const EtiquetteEducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EtiquetteEducationViewModel(),
      child: Consumer<EtiquetteEducationViewModel>(
        builder: (context, vm, _) {
          return
          // Etiquette Dialog Card - Clickable
          GestureDetector(
            onTap: () => vm.refreshTip(),
            child: Container(
              decoration: AppWidgetStyles.cardDecoration(context).copyWith(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/tripora.JPG',
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main tip text
                        Text(
                          vm.currentTip,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: ManropeFontWeight.regular,
                                height: 1.6,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                        const SizedBox(height: 8),
                        // Source attribution and tap hint on same line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '— Cultural Atlas',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.5),
                                    fontWeight: ManropeFontWeight.medium,
                                  ),
                            ),
                            Text(
                              'Tap for another tip',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

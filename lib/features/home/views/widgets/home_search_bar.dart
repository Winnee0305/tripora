import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styels.dart';
import 'package:flutter/cupertino.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.only(left: 24),
        decoration: AppWidgetStyles.cardDecoration(
          context,
        ).copyWith(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for destinations, hotels...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: ManropeFontWeight.light,
                  ),
                  border: InputBorder.none,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: ManropeFontWeight.medium,
                ),
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(CupertinoIcons.search, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

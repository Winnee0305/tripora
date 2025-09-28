import 'package:flutter/material.dart';

class ThemePreviewPage extends StatelessWidget {
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text("This is heading1", style: theme.textTheme.headlineLarge),
            Text("This is heading2", style: theme.textTheme.headlineMedium),
            Text("This is heading3", style: theme.textTheme.headlineSmall),
            Text("This is subheading", style: theme.textTheme.titleLarge),
            Text("This is body", style: theme.textTheme.bodyMedium),
            Text("This is caption", style: theme.textTheme.labelMedium),
            SizedBox(height: 80),
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.onPrimary,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.secondary,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.onSurface,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.surface,
            ),
          ],
        ),
      ),
    );
  }
}

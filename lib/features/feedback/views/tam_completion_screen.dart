import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';

class TAMCompletionScreen extends StatelessWidget {
  final VoidCallback onDone;

  const TAMCompletionScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppStickyHeader(
              title: 'User Feedback',
              showRightButton: false,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  children: [
                    // Success icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 50,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Thank you title
                    Text(
                      'Thank you!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Body text
                    Text(
                      'Your feedback helps us improve the AI travel planning experience and make Tripora more useful for everyone.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),

            // Done button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 26.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  AppButton.primary(onPressed: onDone, text: 'Done'),
                  const SizedBox(height: 12),
                  Text(
                    'Your responses are anonymous and will be used only for improving the app.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

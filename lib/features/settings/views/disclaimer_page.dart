import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppStickyHeader(title: 'Disclaimer'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Use',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tripora is a travel planning and itinerary management application designed to help users organize and plan their trips effectively. This disclaimer outlines the terms under which this service is provided.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Warranty',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tripora is provided on an "as is" and "as available" basis. We make no warranties, expressed or implied, regarding the app or its content. This includes warranties of merchantability, fitness for a particular purpose, and non-infringement.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Limitation of Liability',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'To the fullest extent permitted by law, Tripora and its developers shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or business opportunities, arising from or related to the use or inability to use the app.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Third-Party Services',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tripora may integrate with third-party services and APIs (such as flight data providers, mapping services, and weather services). We are not responsible for the accuracy, reliability, or availability of these external services. Any issues arising from third-party integrations should be directed to the respective service providers.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'User Data & Privacy',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your personal data is stored securely using Firebase services. We are committed to protecting your privacy in accordance with applicable data protection laws. However, no security measure is 100% secure. By using Tripora, you acknowledge that you understand and accept the risks associated with data storage and transmission.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'User Responsibility',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Users are responsible for maintaining the confidentiality of their account credentials and for all activities conducted under their account. You agree to notify us immediately of any unauthorized use of your account.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Changes to This Disclaimer',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We reserve the right to modify this disclaimer at any time. Changes will be effective immediately upon posting to the app. Your continued use of Tripora following the posting of revised terms means you accept and agree to the changes.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Contact Us',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'If you have questions or concerns about this disclaimer, please contact us through the app or visit our feedback section.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Text(
              "Copyright © 2025 Tripora. All rights reserved.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: ManropeFontWeight.light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:tripora/features/settings/views/widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SettingsViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header
            const AppStickyHeader(title: 'Settings'),
            const SizedBox(height: 22),

            // Settings list (scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.person,
                      title: 'Account',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),

                    SettingsTile(
                      icon: Icons.notifications,
                      title: 'Notification settings',
                      trailing: Switch(
                        value: vm.notifications,
                        onChanged: (v) => vm.toggleNotifications(v),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SettingsTile(
                      icon: Icons.tune,
                      title: 'User preferences',
                      onTap: () {},
                    ),
                    const SizedBox(height: 26),
                  ],
                ),
              ),
            ),

            // Logout button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Logged out ')));
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

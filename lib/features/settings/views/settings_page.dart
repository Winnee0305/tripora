import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:tripora/features/settings/views/widgets/settings_tile.dart';
import 'package:tripora/features/settings/views/account_page.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/feedback/views/tam_form.dart';
import 'package:tripora/features/feedback/viewmodels/tam_viewmodel.dart';

class SettingsPage extends StatefulWidget {
  final UserData user;

  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Check feedback status on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsVm = context.read<SettingsViewModel>();
      settingsVm.checkUserFeedbackStatus(widget.user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsVm = Provider.of<SettingsViewModel>(context);
    final userVm = Provider.of<UserViewModel>(context);

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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AccountPage(
                              user: widget.user,
                              settingsViewModel: settingsVm,
                              userViewModel: userVm,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    SettingsTile(
                      icon: Icons.notifications,
                      title: 'Notification settings',
                      trailing: Switch(
                        value: settingsVm.notifications,
                        onChanged: (v) => settingsVm.toggleNotifications(v),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SettingsTile(
                      icon: Icons.tune,
                      title: 'User preferences',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),

                    Stack(
                      children: [
                        SettingsTile(
                          icon: Icons.feedback_outlined,
                          title: 'Feedback & suggestions',
                          onTap: () {
                            if (settingsVm.hasCompletedFeedback) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You have already completed the survey. Thank you for your feedback!',
                                  ),
                                  backgroundColor: Colors.blue,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => TAMViewModel(),
                                  child: TAMForm(
                                    userId: widget.user.uid,
                                    onComplete: () {
                                      // Update feedback status after completion
                                      settingsVm.checkUserFeedbackStatus(
                                        widget.user.uid,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (!settingsVm.hasCompletedFeedback)
                          Positioned(
                            // Red dot indicator
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
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
                label: const Text('Log Out'),

                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await settingsVm.logout();
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    ); // go back to root, and allow AuthLayout to handle redirection
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

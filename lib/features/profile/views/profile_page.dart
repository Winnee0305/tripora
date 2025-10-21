import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_tab.dart';
import 'package:tripora/core/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/profile/viewmodels/profile_view_model.dart';
import 'package:tripora/features/profile/views/profile_collects_content.dart';
import 'package:tripora/features/profile/views/profile_shared_trips_content.dart';
import 'package:tripora/features/profile/views/widgets/profile_section.dart';
import 'package:tripora/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:tripora/features/settings/views/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userVm = context.watch<UserViewModel>();

    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(user: userVm.user!),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----- Sticky top bar (back button and settings button)
                  AppStickyHeader(
                    title: '',
                    showRightButton: true,
                    rightButtonIcon: const Icon(Icons.settings),
                    onRightButtonPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => SettingsViewModel(),
                            child: const SettingsPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  // ----- Profile section
                  ProfileSection(vm: vm),
                  const SizedBox(height: 0),

                  // ----- Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: AppTab(
                      tabs: ["Shared Trips", "Collects"],
                      selectedIndex: vm.selectedIndex,
                      onTabSelected: vm.selectTab,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: theme.colorScheme.onSurface.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),

                  // ----- Tab content area
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: vm.selectedIndex == 0
                          ? ProfileSharedTripsContent()
                          : ProfileCollectsContent(vm: vm),
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

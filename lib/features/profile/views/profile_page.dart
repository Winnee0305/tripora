import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/repositories/collected_post_repository.dart';
import 'package:tripora/core/repositories/collected_poi_repository.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_tab.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/profile/viewmodels/collects_viewmodel.dart';
import 'package:tripora/features/profile/viewmodels/collects_poi_viewmodel.dart';
import 'package:tripora/features/profile/viewmodels/shared_trips_viewmodel.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/profile/viewmodels/profile_view_model.dart';
import 'package:tripora/features/profile/views/profile_collects_content.dart';
import 'package:tripora/features/profile/views/profile_places_collects_content.dart';
import 'package:tripora/features/profile/views/profile_shared_trips_content.dart';
import 'package:tripora/features/profile/views/widgets/profile_section.dart';
import 'package:tripora/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:tripora/features/settings/views/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _profileVm;

  Future<void> _refreshProfileStats() async {
    // Refresh the profile stats when returning from itinerary page
    if (mounted) {
      debugPrint('📊 Refreshing profile stats...');
      await _profileVm.refreshCounts();
      debugPrint('✅ Profile stats refreshed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userVm = context.watch<UserViewModel>();

    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(user: userVm.user!),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          // Capture the viewmodel reference
          _profileVm = vm;

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

                  const SizedBox(height: 18),

                  // ----- Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTab(
                      // tabs: ["Shared Trips", "Collects"],
                      tabs: ["Shared Trips", "Collects", "Places"],
                      selectedIndex: vm.selectedIndex,
                      onTabSelected: vm.selectTab,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: theme.colorScheme.onSurface.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  // ----- Tab content area
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: vm.selectedIndex == 0
                          ? ChangeNotifierProvider(
                              create: (_) => SharedTripsViewModel(
                                FirestoreService(),
                                userVm.user!.uid,
                              ),
                              child: ProfileSharedTripsContent(
                                onNavigateBack: _refreshProfileStats,
                              ),
                            )
                          : vm.selectedIndex == 1
                          ? ChangeNotifierProvider(
                              create: (_) => CollectsViewModel(
                                CollectedPostRepository(FirestoreService()),
                                FirestoreService(),
                                userVm.user!.uid,
                              ),
                              child: ProfileCollectsContent(
                                onNavigateBack: _refreshProfileStats,
                              ),
                            )
                          : ChangeNotifierProvider(
                              create: (_) => CollectsPoiViewModel(
                                CollectedPoiRepository(FirestoreService()),
                                FirestoreService(),
                                userVm.user!.uid,
                              ),
                              child: ProfilePlacesCollectsContent(
                                onNavigateBack: _refreshProfileStats,
                              ),
                            ),
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

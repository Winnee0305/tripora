import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/widgets/app_tab.dart';
import 'home_discover_tab.dart';
import 'home_inspirations_tab.dart';
import 'home_travelers_voice_tab.dart';
import '../viewmodels/destinations_viewmodel.dart';

// ViewModel
class HomeTabsViewModel extends ChangeNotifier {
  int _selectedIndex = 2;
  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

// Screen Widget
class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => HomeTabsViewModel(),
      child: Consumer<HomeTabsViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tabs Indicator
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: AppTab(
                  tabs: ["Discover", "Inspirations", "Traveler's Voice"],
                  selectedIndex: viewModel.selectedIndex,
                  onTabSelected: viewModel.selectTab,
                  activeColor: theme.colorScheme.primary,
                  inactiveColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.4,
                  ),
                ),
              ),

              // Tab Content
              Expanded(
                child: Builder(
                  builder: (_) {
                    switch (viewModel.selectedIndex) {
                      case 0:
                        return const SingleChildScrollView(
                          child: HomeDiscoverTab(),
                        );
                      case 1:
                        return SingleChildScrollView(
                          child: ChangeNotifierProvider(
                            create: (_) => DestinationViewModel(),
                            child: const HomeInspirationsTab(),
                          ),
                        );
                      case 2:
                        return const HomeTravelersVoiceTab();
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// views/place_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_loading_page.dart';
import 'package:tripora/features/poi/views/poi_details_screen.dart';
import '../viewmodels/poi_page_viewmodel.dart';
import 'poi_header_screen.dart';
import 'poi_reviews_screen.dart';
import 'poi_nearby_screen.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class PoiPage extends StatelessWidget {
  final String placeId;
  const PoiPage({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        // Try to read UserViewModel if available, otherwise pass null
        String? userId;
        try {
          final userVm = context.read<UserViewModel>();
          userId = userVm.user?.uid;
        } catch (_) {
          // UserViewModel not in scope, proceed without it
          userId = null;
        }
        return PoiPageViewmodel(placeId, userId: userId);
      },
      child: Consumer<PoiPageViewmodel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: AppLoadingPage());
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Image + Title Section
                    SizedBox(
                      height: 450,
                      width: double.infinity,
                      child: PoiHeaderScreen(vm: vm),
                    ),

                    // Details section (description, location, operating hours)
                    PoiDetailsScreen(vm: vm),
                    const SizedBox(height: 30),
                    // Reviews section
                    PoiReviewsScreen(vm: vm),

                    // Nearby Attractions section
                    PoiNearbyScreen(vm: vm),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

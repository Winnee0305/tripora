import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/for_you_viewmodel.dart';
import 'package:tripora/features/home/viewmodels/home_viewmodel.dart';
import 'widgets/home_header_section.dart';
import 'package:tripora/core/reusable_widgets/app_navigation_bar.dart';
import 'package:tripora/features/home/views/widgets/make_bookings_section.dart';
import 'package:tripora/features/home/views/widgets/continue_trip_section.dart';
import 'package:tripora/features/home/views/widgets/for_you_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              HomeHeaderSection(),
              const SizedBox(height: 30),
              MakeBookingsSection(),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                create: (_) => ForYouViewModel(),
                child: const ForYouSection(),
              ),
              const SizedBox(height: 30),
              ContinueTripSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: vm.updateIndex,
      ),
    );
  }
}

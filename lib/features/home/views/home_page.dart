import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/services/ai_agents_service.dart';
import 'package:tripora/features/home/viewmodels/for_you_viewmodel.dart';
import 'package:tripora/features/home/viewmodels/home_viewmodel.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'widgets/home_header_section.dart';
import 'package:tripora/features/navigation/views/navigation_bar.dart';
import 'package:tripora/features/home/views/widgets/book_now_section.dart';
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
              BookNowSection(),
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

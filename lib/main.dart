import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/main_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/trip/views/trip_info_page.dart';
import 'features/packing/views/packing_page.dart';
import 'features/packing/viewmodels/packing_page_viewmodel.dart';
import 'features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'features/itinerary/views/itinerary_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavigationViewModel())],
      child: const TriporaApp(),
    ),

    // ChangeNotifierProvider(
    //   create: (_) => PackingPageViewModel(),
    //   child: MaterialApp(
    //     theme: AppTheme.lightTheme,
    //     debugShowCheckedModeBanner: false,
    //     home: PackingPage(),
    //   ),
    // ),
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => ItineraryPageViewModel()),
    //   ],
    //   child: const TriporaApp(),
    // );
  );
}

class TriporaApp extends StatelessWidget {
  const TriporaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      home: const MainScreen(),
      // home: TripInfoPage(
      //   tripTitle: 'Melaka 2 days family trip',
      //   destination: 'Melacca, Malaysia',
      //   startDate: DateTime(2025, 8, 13),
      //   endDate: DateTime(2025, 8, 14),
      // ),
      // home: const PackingPage(),
      // home: const ItineraryPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:tripora/features/login/views/auth_page.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/main_screen.dart';
import 'package:tripora/features/trip/views/create_trip_page.dart';
import 'core/theme/app_theme.dart';
import 'features/trip/views/trip_info_page.dart';
import 'features/packing/views/packing_page.dart';
import 'features/packing/viewmodels/packing_page_viewmodel.dart';
import 'features/itinerary/viewmodels/itinerary_content_viewmodel.dart';
import 'features/notes_itinerary/views/notes_itinerary_page.dart';
import 'features/trip/viewmodels/create_trip_viewmodel.dart';
import 'features/expense/views/expense_page.dart';
import 'features/home/viewmodels/home_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // make it transparent
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.light, // iOS
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
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
    // MultiProvider(
    //   providers: [ChangeNotifierProvider(create: (_) => CreateTripViewModel())],
    //   child: const TriporaApp(),
    // ),
    // ChangeNotifierProvider(
    //   create: (_) => ExpensePageViewModel(
    //     tripStartDate: DateTime(2025, 8, 13),
    //     tripEndDate: DateTime(2025, 8, 14),
    //   ),
    //   child: const TriporaApp(),
    // ),
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
      navigatorObservers: [StatusBarObserver()],
      routes: {'/login': (context) => const AuthPage()},

      // home: const CreateTripPage(),
      // home: const MainScreen(),
      home: const AuthPage(),

      // home: TripInfoPage(
      //   tripTitle: 'Melaka 2 days family trip',
      //   destination: 'Melacca, Malaysia',
      //   startDate: DateTime(2025, 8, 13),
      //   endDate: DateTime(2025, 8, 14),
      // ),
      // home: const PackingPage(),
      // home: const ItineraryPage(),
      // home: const ExpensePage(),
    );
  }
}

class StatusBarObserver extends NavigatorObserver {
  void _applyDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _applyDarkStatusBar();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _applyDarkStatusBar();
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _applyDarkStatusBar();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

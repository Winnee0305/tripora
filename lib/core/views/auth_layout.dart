import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/repositories/expense_repository.dart';
import 'package:tripora/core/repositories/itinerary_repository.dart';
import 'package:tripora/core/repositories/lodging_repository.dart';
import 'package:tripora/core/repositories/flight_repository.dart';
import 'package:tripora/core/repositories/packing_repository.dart';
import 'package:tripora/core/repositories/trip_repository.dart';
import 'package:tripora/core/repositories/user_repository.dart';
import 'package:tripora/core/reusable_widgets/app_loading_page.dart';
import 'package:tripora/core/services/firebase_auth_service.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/core/services/firebase_storage_service.dart';
import 'package:tripora/features/auth/views/auth_page.dart';
import 'package:tripora/features/expense/viewmodels/expense_viewmodel.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';
import 'package:tripora/features/packing/viewmodels/packing_viewmodel.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  // final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    final firestore = context.read<FirestoreService>();
    final storage = context.read<FirebaseStorageService>();

    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authServiceValue, child) {
        return StreamBuilder(
          stream: authServiceValue.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            debugPrint('🔁 Auth state changed: ${snapshot.data}');
            // --- Loading auth state ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoadingPage();
            }
            // --- User logged in ---
            else if (snapshot.hasData) {
              final user = snapshot.data!;
              final userRepo = UserRepository(firestore, user.uid, storage);
              final tripRepo = TripRepository(firestore, user.uid, storage);
              final itineraryRepo = ItineraryRepository(firestore, user.uid);
              final lodgingRepo = LodgingRepository(
                FirebaseFirestore.instance,
                user.uid,
              );
              final flightRepo = FlightRepository(
                FirebaseFirestore.instance,
                user.uid,
              );
              final expenseRepo = ExpenseRepository(firestore, user.uid);
              final packingRepo = PackingRepository(firestore, user.uid);

              widget = MultiProvider(
                providers: [
                  ChangeNotifierProvider<UserViewModel>(
                    create: (_) {
                      final vm = UserViewModel(userRepo);
                      vm.loadUser(context);
                      return vm;
                    },
                  ),
                  ChangeNotifierProvider<TripViewModel>(
                    create: (_) {
                      final vm = TripViewModel(tripRepo);
                      vm.loadTrips();
                      return vm;
                    },
                  ),
                  ChangeNotifierProvider<ItineraryViewModel>(
                    create: (_) {
                      final vm = ItineraryViewModel(
                        itineraryRepo,
                        lodgingRepo,
                        flightRepo,
                      );
                      return vm;
                    },
                  ),
                  ChangeNotifierProvider<ExpenseViewModel>(
                    create: (_) {
                      final vm = ExpenseViewModel(expenseRepo);
                      return vm;
                    },
                  ),
                  ChangeNotifierProvider<PackingViewModel>(
                    create: (_) {
                      final vm = PackingViewModel(packingRepo);
                      return vm;
                    },
                  ),
                ],
                child: const NavigationShell(),
              );
            } else {
              debugPrint("returning AuthPage");
              // --- No user logged in ---
              widget = const AuthPage();
            }
            return widget;
          },
        );
      },
    );
  }
}

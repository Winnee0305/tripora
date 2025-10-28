import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/services/firebase_auth_service.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/core/services/firebase_storage_service.dart';
import 'package:tripora/core/views/auth_layout.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:tripora/features/auth/views/auth_page.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'core/theme/app_theme.dart';
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
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => FirebaseStorageService()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: const TriporaApp(),
    ),
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
      routes: {'/login': (context) => const AuthPage()},
      home: const AuthLayout(),
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

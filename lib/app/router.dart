
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/auth/screens/login_screen.dart';
import 'package:myapp/features/main_screen.dart';
import 'package:myapp/features/perfumes/screens/perfume_details_screen.dart';
import 'package:myapp/features/perfumes/screens/perfume_edit_screen.dart';
import 'package:myapp/models/perfume.dart';
import 'package:myapp/services/auth_service.dart';
import 'dart:async';

class AppRouter {
  final AuthService authService;

  AppRouter(this.authService);

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
    routes: [
       GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
        routes: [
          // Perfume routes
          GoRoute(
            path: 'perfumes/add',
            builder: (context, state) => const PerfumeEditScreen(),
          ),
          GoRoute(
            path: 'perfumes/edit',
            builder: (context, state) {
              final perfume = state.extra as Perfume?;
              return PerfumeEditScreen(perfume: perfume);
            },
          ),
           GoRoute(
            path: 'perfumes/details',
            builder: (context, state) {
              final perfume = state.extra as Perfume;
              return PerfumeDetailsScreen(perfume: perfume);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final bool loggedIn = authService.currentUser != null;
      final bool isLoggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !isLoggingIn) {
        return '/login';
      }

      if (loggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

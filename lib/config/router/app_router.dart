import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/home/home.dart';

import '../../features/auth/auth.dart';
import 'app_router_notifier.dart';


final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
      initialLocation: '/splash',
      refreshListenable: goRouterNotifier,
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),

        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),

        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        GoRoute(
          path: '/reset_password',
          builder: (context, state) => const ResetPassword(),
        ),

        // Home empieza aca
        GoRoute(
          path: '/home_screen',
          builder: (context, state) => const HomeScreen(),
        )
      ],
      redirect: (context, state) async {
        final String isGoingTo = state.matchedLocation;
        final AuthStatus authStatus = goRouterNotifier.authStatus;
        final RegisterStatus registerStatus = goRouterNotifier.registerStatus;

        print('------------------');
        print("AuthStatus: $authStatus");
        print("RegisterStatus: $registerStatus");
        print("Going to: $isGoingTo");

        if (authStatus == AuthStatus.authenticated &&
            registerStatus == RegisterStatus.registered) {
          if (isGoingTo == '/login' || isGoingTo == '/register') {
            return '/home';
          }

          if (isGoingTo == '/splash') {
            return '/home';
          }
        }

        if (authStatus == AuthStatus.notAuthenticated &&
            registerStatus == RegisterStatus.notRegistered) {
          if (isGoingTo == '/splash') {
            return '/login';
          }

          if (isGoingTo == '/splash') {
            return '/login';
          }
        }
        return null;
      });
});

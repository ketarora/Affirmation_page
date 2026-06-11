import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_view.dart';
import '../screens/library_view.dart';
import '../screens/studio_view.dart';
import '../screens/community/community_view.dart';
import '../screens/profile/profile_view.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeView()),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => const NoTransitionPage(child: LibraryView()),
          ),
          GoRoute(
            path: '/studio',
            pageBuilder: (context, state) => const NoTransitionPage(child: StudioView()),
          ),
          GoRoute(
            path: '/community',
            pageBuilder: (context, state) => const NoTransitionPage(child: CommunityView()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileView()),
          ),
        ],
      ),
    ],
  );
});

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/library')) currentIndex = 1;
    if (location.startsWith('/studio')) currentIndex = 2;
    if (location.startsWith('/community')) currentIndex = 3;
    if (location.startsWith('/profile')) currentIndex = 4;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0: context.go('/'); break;
          case 1: context.go('/library'); break;
          case 2: context.go('/studio'); break;
          case 3: context.go('/community'); break;
          case 4: context.go('/profile'); break;
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey.shade400,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 20,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.spa_outlined), activeIcon: Icon(Icons.spa), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), activeIcon: Icon(Icons.library_books), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Studio'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Vibes'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Me'),
      ],
    );
  }
}

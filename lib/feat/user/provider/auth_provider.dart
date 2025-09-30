import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/common/view/root_tab.dart';
import 'package:flutter_restaurant/common/view/splash_screen.dart';
import 'package:flutter_restaurant/feat/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_restaurant/feat/user/model/user_model.dart';
import 'package:flutter_restaurant/feat/user/provider/user_me_provider.dart';
import 'package:flutter_restaurant/feat/user/view/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) {
    return AuthProvider(ref: ref);
  },
);

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, __) => RootTab(),
      routes: [
        GoRoute(
          path: 'restaurant/:rid',
          name: RestaurantDetailScreen.routeName,
          builder: (_, state) => RestaurantDetailScreen(
            id: state.pathParameters['rid']!,
            title: '',
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
  ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작할 때 토큰이 존재하는지 확인하고 로그인 스크린으로 갈지, 홈으로 갈지
  FutureOr<String?> redirectLogic(BuildContext context, GoRouterState state) {
    // String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final loginIn = state.location == '/login';

    if (user == null) {
      return loginIn ? null : '/login';
    }

    if (user is UserModel) {
      return loginIn || state.location == '/splash' ? '/' : null;
    }

    if (user is UserModelError) {
      return !loginIn ? '/login' : null;
    }

    if (user is UserModelLoading) {
      return null;
    }

    return null;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/feat/user/model/user_model.dart';
import 'package:flutter_restaurant/feat/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // SplashScreen
  /*
  String? redirectLogic(GoRouterState state) {
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

    return null;
  }
  */
}

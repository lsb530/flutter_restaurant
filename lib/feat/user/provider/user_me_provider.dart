import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/feat/user/model/user_model.dart';
import 'package:flutter_restaurant/feat/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final UserMeRepository repository;
  final FlutterSecureStorage secureStorage;

  UserMeStateNotifier({
    required this.repository,
    required this.secureStorage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기
    getMe();
  }

  Future<void> getMe() async {
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    if(accessToken == null || refreshToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }
}

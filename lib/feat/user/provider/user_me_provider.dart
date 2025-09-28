import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/secure_storage/secure_storage.dart';
import 'package:flutter_restaurant/feat/user/model/user_model.dart';
import 'package:flutter_restaurant/feat/user/repository/auth_repository.dart';
import 'package:flutter_restaurant/feat/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userMeRepository = ref.watch(userMeRepositoryProvider);
    final secureStorage = ref.watch(secureStorageProvider);

    return UserMeStateNotifier(
      authRepository: authRepository,
      repository: userMeRepository,
      secureStorage: secureStorage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage secureStorage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.secureStorage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기
    getMe();
  }

  Future<void> getMe() async {
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    if (accessToken == null || refreshToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await secureStorage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      await secureStorage.write(
        key: REFRESH_TOKEN_KEY,
        value: resp.refreshToken,
      );

      final userResp = await repository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        secureStorage.delete(key: ACCESS_TOKEN_KEY),
        secureStorage.delete(key: REFRESH_TOKEN_KEY),
      ],
    );
  }
}

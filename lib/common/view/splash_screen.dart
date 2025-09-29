import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/colors.dart';
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/layout/default_layout.dart';
import 'package:flutter_restaurant/common/secure_storage/secure_storage.dart';
import 'package:flutter_restaurant/common/view/root_tab.dart';
import 'package:flutter_restaurant/feat/user/view/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    initializeApp();
  }

  void initializeApp() async {
    await showLoadingIndicatorForAWhile();
    // deleteToken();
    await checkToken();
  }

  Future<void> showLoadingIndicatorForAWhile() async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
  }

  Future<void> deleteToken() async {
    final secureStorage = ref.read(secureStorageProvider);

    await secureStorage.deleteAll();
  }

  Future<void> checkToken() async {
    final secureStorage = ref.read(secureStorageProvider);

    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    try {
      final resp = await dio.post(
        'http://$hostPort/auth/token',
        options: Options(
          headers: {'authorization': 'Bearer $refreshToken'},
        ),
      );
      print('-------- 요청 성공 --------');

      await secureStorage.write(
        key: ACCESS_TOKEN_KEY,
        value: resp.data['accessToken'],
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
        (route) => false,
      );
    } catch (e) {
      print('-------- 에러 발생 --------');
      print(e);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

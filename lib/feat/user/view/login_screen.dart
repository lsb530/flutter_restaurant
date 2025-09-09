import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/component/custom_text_form_field.dart';
import 'package:flutter_restaurant/common/const/colors.dart';
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/layout/default_layout.dart';
import 'package:flutter_restaurant/common/util/json_viewer.dart';
import 'package:flutter_restaurant/common/view/root_tab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // localhost
    final emulatorIp = '10.0.2.2:3000'; // android
    final simulatorIp = '127.0.0.1:3000'; // ios

    final hostPort = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // ID:PW
                    final testIdPw = 'test@codefactory.ai:testtest';
                    final inputIdPw = '$username:$password';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String token = stringToBase64.encode(inputIdPw);

                    final resp = await dio.post(
                      'http://$hostPort/auth/login',
                      options: Options(
                        headers: {'authorization': 'Basic $token'},
                      ),
                    );

                    // JsonViewer.printPretty(resp.data);

                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    secureStorage.write(
                      key: ACCESS_TOKEN_KEY,
                      value: accessToken,
                    );
                    secureStorage.write(
                      key: REFRESH_TOKEN_KEY,
                      value: refreshToken,
                    );

                    if (!context.mounted) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // primary  // deprecated
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: () async {
                    final refreshToken =
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTc1NzM4MDI4MSwiZXhwIjoxNzU3NDY2NjgxfQ.MOue8F5URhMQzZbUzuShFWUQYG5oNc5CbvcBNlV1ZUE';

                    final resp = await dio.post(
                      'http://$hostPort/auth/token',
                      options: Options(
                        headers: {'authorization': 'Bearer $refreshToken'},
                      ),
                    );

                    JsonViewer.printPretty(resp.data);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n'
      '오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}

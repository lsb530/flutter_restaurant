import 'dart:convert';

import 'package:flutter_restaurant/common/const/data.dart';
import 'package:intl/intl.dart';

class DataUtils {
  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }

  static String pathToUrl(String value) {
    return 'http://$hostPort$value';
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(plain);
  }

  /// 숫자를 통화 형식으로 포맷
  /// 기본값: locale=ko_KR, symbol=₩, decimalDigits=0
  static String formatCurrency(
      num value, {
        String locale = 'ko_KR',
        String symbol = '₩',
        int decimalDigits = 0,
      }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value);
  }
}
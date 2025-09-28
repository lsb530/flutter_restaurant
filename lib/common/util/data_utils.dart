import 'dart:convert';

import 'package:flutter_restaurant/common/const/data.dart';

class DataUtils {
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
}
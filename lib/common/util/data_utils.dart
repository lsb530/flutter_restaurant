import 'package:flutter_restaurant/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$hostPort$value';
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
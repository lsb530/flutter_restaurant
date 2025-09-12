import 'package:flutter_restaurant/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$hostPort$value';
  }
}
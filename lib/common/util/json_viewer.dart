import 'dart:convert';

class JsonViewer {
  static void printPretty(dynamic data, {String indent = '  '}) {
    try {
      String prettyJson = JsonEncoder.withIndent(indent).convert(data);
      print(prettyJson);
    } catch (e) {
      print('JSON 변환 실패: $e');
      print('원본 데이터: $data');
    }
  }
}
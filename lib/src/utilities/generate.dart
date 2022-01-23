import 'dart:math';
import 'dart:convert';

class GenerateValue{
  String genRandomString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) =>  random.nextInt(255));
    return base64UrlEncode(values);
  }
}


import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:get_version/get_version.dart';
// import 'package:licorice_indo/generated/l10n.dart';
// import 'package:licorice_indo/src/flashjob/utils/pref_manager.dart';
// import 'package:licorice_indo/src/utils/config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'error_code.dart';
import 'exception.dart';

//used: goi dong nay trong file repository
//  ApiProvider _apiProvider = getIt.get<ApiProvider>();

void printWrapped(String text) {
  final pattern = new RegExp('.{1,20000}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class ApiProvider {
  var dio = new Dio(BaseOptions(
      connectTimeout: 30000,
      headers: {
        'country': 'vi',
        'platform': Platform.isAndroid ? '2' : '1',
        'Accept': '*/*',
      },
      contentType: Headers.jsonContentType));

  void _addInterceptors(Dio dio, {String? licoriceToken}) {
    dio..interceptors.clear();
    dio
      ..interceptors.add(InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) =>
                  _requestInterceptor(options, handler,
                      licoriceToken: licoriceToken)))
      ..interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ));
  }

  void _requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler,
      {String? licoriceToken}) async {
    String token = '';
    if (licoriceToken != null) {
      token = licoriceToken;
      options.headers.addAll({'licorice-token': licoriceToken});
    } else {
      // token = await PrefManager.getAuthToken();
      token = '';
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    // String userAgent = await FkUserAgent.getPropertyAsync('userAgent');
    // options.headers.addAll({'user-agent': userAgent});
    // String versionName = await _getCurrentVersion();
    // options.headers.addAll({'version_name': versionName});
    handler.next(options);
  }

  // Future<String> _getCurrentVersion() async {
  //   String versionName = '';
  //   try {
  //     versionName = await GetVersion.projectVersion;
  //   } on PlatformException {
  //     versionName = '';
  //   }
  //   return versionName;
  // }

  Future<dynamic> request(
      {String? rawData,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? data,
      FormData? formParams,
      required String method,
      required String url,
      String? licoriceToken}) async {
    var responseJson;
    try {
      _addInterceptors(dio, licoriceToken: licoriceToken);
      final response = await dio.request(url,
          queryParameters: queryParams,
          data: (formParams != null)
              ? formParams
              : (data != null)
                  ? data
                  : rawData,
          options: Options(
              method: method,
              validateStatus: (code) {
                return code! >= 200 && code < 300;
              }));
      responseJson = _formatRes(response.statusCode, response.data);
    } on SocketException {
      throw ErrorException(ErrorCode.NO_NETWORK, 'S.current.MSG_HINT_NETWORK');
    } on DioError catch (e) {
      debugPrint('error.type = ${e.type}');
      debugPrint('error = $e');
      await Future.delayed(Duration(milliseconds: 200));
      if (e.error is SocketException) {
        throw ErrorException(ErrorCode.NO_NETWORK, 'S.current.MSG_HINT_NETWORK');
      }
      throw ErrorException(e.response?.statusCode, e.message);
    }
    return responseJson;
  }

  Future get(String url,
      {Map<String, dynamic>? params, String? licoriceToken}) async {
    return await request(
        method: Method.get,
        url: url,
        queryParams: params,
        licoriceToken: licoriceToken);
  }

  Future postMultiPart(String url, FormData formData,
      {String? licoriceToken}) async {
    return await request(
        method: Method.post,
        url: url,
        formParams: formData,
        licoriceToken: licoriceToken);
  }

  Future putMultiPart(String url, FormData formData,
      {String? licoriceToken}) async {
    return await request(
        method: Method.put,
        url: url,
        formParams: formData,
        licoriceToken: licoriceToken);
  }

  Future post(String url,
      {Map<String, dynamic>? params, String? licoriceToken}) async {
    return await request(
        method: Method.post,
        url: url,
        data: params,
        licoriceToken: licoriceToken);
  }

  Future put(String url,
      {Map<String, dynamic>? params, String? licoriceToken}) async {
    return await request(
        method: Method.put,
        url: url,
        data: params,
        licoriceToken: licoriceToken);
  }
  Future delete(String url,
      {Map<String, dynamic>? params, String? licoriceToken}) async {
    return await request(
        method: Method.delete,
        url: url,
        data: params,
        licoriceToken: licoriceToken);
  }
  Future patch(String url,
      {Map<String, dynamic>? params, String? licoriceToken}) async {
    return await request(
        method: Method.patch,
        url: url,
        data: params,
        licoriceToken: licoriceToken);
  }

  dynamic _formatRes(int? code, dynamic data) {
    switch (code) {
      case ErrorCode.HTTP_OK:
        bool isSuccess = data['status'];
        if (isSuccess)
          return data['data'];
        else {
          int errorCode = data['error']['code'];
          String errorMessage = data['error']['message'];
          throw ErrorException(errorCode, errorMessage);
        }
      case ErrorCode.HTTP_BAD_REQUEST:
        throw BadRequestException('response.body.toString()');
      case ErrorCode.HTTP_UNAUTHORIZED:
      case ErrorCode.HTTP_FORBIDDEN:
        throw UnauthorisedException('response.body.toString()');
      case ErrorCode.HTTP_INTENAL_SERVER_ERROR:
      default:
        throw ErrorException(code,
            'Error occured while Communication with Server with StatusCode : $code');
    }
  }
}

class Method {
  static String get get => 'get';

  static String get post => 'post';

  static String get patch => 'patch';

  static String get put => 'put';

  static String get delete => 'delete';
}

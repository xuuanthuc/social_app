import 'package:dio/dio.dart';

class BaseApi {
  static Dio? _dio;
  BaseOptions? _options;

  BaseApi._internal() {
    _options = BaseOptions(
      baseUrl: 'https://land-map-hv2wn47voq-as.a.run.app/api/',
      connectTimeout: 5000,
      receiveTimeout: 5000,
      validateStatus: (status) {
        return (status ?? 501) < 500 && status != 401;
      },
    );
    _dio = Dio(_options);
    _dio?.interceptors.add(LogInterceptor(responseBody: true));
    _dio?.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      String? token = '';
      if (token != null) {
        options.headers['x-token'] = token;
      }
      handler.next(options);
    }));
  }
  static final BaseApi instance = BaseApi._internal();

  Future<Response> postApi(String path, {dynamic data}) async {
    final res = await _dio!
        .post(
      path,
      data: data,
    )
        .catchError((onError) {
      final DioError err = onError;
      if (err.error.toString().contains('401')) {
        // AuthController.instance?.logout(expriedToken: true);
      }
      return err.response!;
    });
    return res;
  }

  Future<Response> postFormDataApi(String path, {FormData? data}) async {
    final res = await _dio!
        .post(path,
            data: data,
            options: Options(
                contentType: "multipart/form-data",
                headers: {"Content-Type": "multipart/form-data"}))
        .catchError((onError) {
      final DioError err = onError;
      if (err.error.toString().contains('401')) {
        // AuthController.instance?.logout(expriedToken: true);
      }
      return err.response!;
    });
    return res;
  }

  Future<Response> getApi(String path) async {
    final res = await _dio!.get(path).catchError((onError) {
      final DioError err = onError;
      if (err.error.toString().contains('401')) {
        // AuthController.instance?.logout(expriedToken: true);
      }
    });
    return res;
  }

  Dio get dio => _dio!;
}

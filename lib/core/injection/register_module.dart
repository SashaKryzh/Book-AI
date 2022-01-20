import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  String get baseUrl => 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

  @singleton
  @preResolve
  Future<Dio> dio(@Named('baseUrl') String baseUrl) async {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 5000,
    );

    final _dio = Dio(options);

    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    ]);

    return _dio;
  }
}

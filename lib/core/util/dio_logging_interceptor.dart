import 'package:dio/dio.dart';
import '../../config/flavor_config.dart';

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print("--> ${options.method.isNotEmpty ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl) + (options.path)}");
      print('Headers:');
      options.headers.forEach((k, v) => print('$k: $v'));
      if (options.queryParameters.isNotEmpty) {
        print('queryParameters:');
        options.queryParameters.forEach((k, v) => print('$k: $v'));
      }
      if (options.data != null) {
        print('Body: ${options.data}');
      }
      print("--> END ${options.method.isNotEmpty ? options.method.toUpperCase() : 'METHOD'}");
    }

    // Call the next interceptor in the chain
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print('<-- ${response.statusCode} ${((response.requestOptions.baseUrl + response.requestOptions.path))}');
      print('Headers:');
      response.headers.forEach((k, v) => print('$k: $v'));
      print('Response: ${response.data}');
      print('<-- END HTTP');
    }
    // Call the next interceptor in the chain
    handler.next(response);
  }

  @override
  void onError(DioException dioError, ErrorInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "<-- ${dioError.message} ${(dioError.response?.requestOptions != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL')}");
      print("${dioError.response != null ? dioError.response!.data : 'Unknown Error'}");
      print('<-- End error');
    }
    // Call the next interceptor in the chain
    handler.next(dioError);
  }
}

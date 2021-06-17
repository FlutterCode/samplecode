import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http/io_client.dart';
import 'package:milanproject/provider/helper/app_exceptions.dart';
import 'package:milanproject/provider/helper/data_provider_base.dart';
import 'package:milanproject/provider/interfaces/api_provider_contract.dart';

class ApiDataProvider extends DataProviderBase
    implements ApiDataProviderContract {
  Dio dio;

  ApiDataProvider.initialize() {
    dio = Dio()
      ..options.connectTimeout = 60000
      ..options.receiveTimeout = 60000
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    /// For Android Platform, Self SSL Certificate require,
    ///
    /// To Avoid HandshakeException: Handshake error
    if (Platform.isAndroid) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.interceptors.add(InterceptorsWrapper(onError: (DioError error) async {
      if (error.response?.statusCode == 401) {
        //User unauthorized
        RequestOptions options = error.response.request;
        // Lock to block the incoming request until the token updated
        dio.lock();
        dio.interceptors.responseLock.lock();
        dio.interceptors.errorLock.lock();

        // tokens are updated, hit request again
        return await dio.request(options.path, options: options);
      } else if (error.response?.statusCode == 417) {
        return "Something Went Wrong Try again";
      }
      return error;
    }));
  }

  @override
  Future<dynamic> get(
      String url, Function(dynamic) successResponseParser) async {
    var responseJson;
    try {
      final response = await getHttpClient().get(url);
      responseJson = returnResponse(response, successResponseParser);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  IOClient getHttpClient() {
    HttpClient httpClient = new HttpClient();

    /// For Android Platform, Self SSL Certificate require,
    ///
    /// To Avoid HandshakeException: Handshake error
    if (Platform.isAndroid) {
      httpClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    }
    IOClient ioClient = new IOClient(httpClient);
    return ioClient;
  }
}

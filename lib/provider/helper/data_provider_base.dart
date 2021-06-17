import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_helper.dart';
import 'app_exceptions.dart';

/// Generic class for interpreting errors and parsing the response
class DataProviderBase extends ApiHelper {
  /// Method to mask and log exception
  dynamic returnResponse(
      http.Response response, Function(dynamic) successResponseParser) {
    switch (response.statusCode) {
      case 200:
        // Decode and parse the JSON string
        var responseData =
            successResponseParser(json.decode(response.body.toString()));
        return responseData;
      case 204:
        // No content
        var responseData = 'No Content';
        return responseData;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

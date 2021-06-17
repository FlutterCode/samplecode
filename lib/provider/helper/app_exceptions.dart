/// Class for masking the exceptions
class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "${_prefix ?? ''}$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class RequestedServiceSoldException extends AppException {
  RequestedServiceSoldException([String message])
      : super(message, "The requested class of service is sold out");
}

class RequiredParametersException extends AppException {
  RequiredParametersException([String message])
      : super(message, "The requested Parameters are missing");
}

class TokenExpireException extends AppException {
  TokenExpireException([String message])
      : super(message, "Token is Expire Try Again");
}

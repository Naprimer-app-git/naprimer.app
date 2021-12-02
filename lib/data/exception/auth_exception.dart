import 'package:get/get.dart';
import 'base_exception.dart';

class AuthException implements BaseException {
  @override
  final int statusCode;
  @override
  final String message;

  AuthException(this.statusCode, this.message);

  factory AuthException.fromResponse(Response response) {
    int statusCode = response.statusCode ?? -1;
    String errorMessage = response.body['message'] ?? "";
    String message = 'unknown exception';

    switch (statusCode) {
      case 400:
        if (errorMessage == "email or password can not be null") {
          message = 'Email or password can not be empty';
        } else if (errorMessage == "email or password is wrong") {
          message = 'Email or password is wrong';
        } else {
          message = 'Server error: $errorMessage';
        }
        break;
      case 401:
        message = 'User already registered';
        break;
      case 404:
        message = 'User not found';
        break;
      case 500:
        message = 'Server error: $errorMessage';
    }

    return AuthException(statusCode, message);
  }
}

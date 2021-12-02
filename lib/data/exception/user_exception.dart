import 'package:get/get.dart';

import 'base_exception.dart';

class UserException implements BaseException {
  @override
  final int statusCode;
  @override
  final String message;

  UserException(this.statusCode, this.message);

  factory UserException.fromResponse(Response response) {
    int statusCode = response.statusCode ?? -1;
    String errorMessage = response.body['message'] ?? "";
    String message = 'unknown exception';

    switch (statusCode) {
      case 400:
        message = "User id is required";
        break;
      case 401:
        message = 'User not authorized';
        break;
      case 404:
        message = 'User not found';
        break;
      case 500:
        message = 'Server error: $errorMessage';
    }

    return UserException(statusCode, message);
  }
}

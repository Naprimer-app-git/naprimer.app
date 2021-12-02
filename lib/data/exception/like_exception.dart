import 'package:get/get.dart';
import 'package:naprimer_app_v2/data/exception/base_exception.dart';

class LikeException implements BaseException {
  @override
  final int statusCode;
  @override
  final String message;

  LikeException(this.statusCode, this.message);

  factory LikeException.fromResponse(Response response) {
    int statusCode = response.statusCode ?? -1;
    String errorMessage = response.body['message'] ?? "";
    String message = 'unknown exception';
    switch (statusCode) {
      case 404:
        message = 'Video not found';
        break;
      case 500:
        message = 'Server error: $errorMessage';
    }

    return LikeException(statusCode, message);
  }
}

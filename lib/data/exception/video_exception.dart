import 'package:get/get.dart';
import 'package:naprimer_app_v2/data/exception/base_exception.dart';

class FetchVideosException implements BaseException {
  @override
  final int statusCode;
  @override
  final String message;

  FetchVideosException(this.statusCode, this.message);

  factory FetchVideosException.fromResponse(Response response) {
    int statusCode = response.statusCode ?? -1;
    String errorMessage = response.body['message'] ?? "";
    String message = 'unknown exception';

    switch (statusCode) {
      case 400:
        message = 'User not found';
        break;
      case 404:
        message = 'Video not found';
        break;
      case 500:
        message = 'Server error: $errorMessage';
    }

    return FetchVideosException(statusCode, message);
  }
}

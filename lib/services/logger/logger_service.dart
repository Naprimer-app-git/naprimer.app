import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoggerService {
  static late Logger _logger;
  static late bool _isSentryEnabled;
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  init({bool isSentryEnabled = false}) {
    _isSentryEnabled = isSentryEnabled;
    _logger = Logger();
  }

  LoggerService._internal();

  static debugLog({
    required Object exception,
    StackTrace? stackTrace,
    String? customMessage,
  }) {
    String message = 'exception: $exception';
    message =
        stackTrace != null ? '$message, \nstackTrace: $stackTrace' : message;
    message = customMessage != null ? '$customMessage\n$message' : message;
    _logger.d(message);
    if (_isSentryEnabled) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/pages/app.dart';

void main() async {
  LoggerService loggerService = LoggerService();
  loggerService.init(isSentryEnabled: true);
  // await runWithSentry();
  runApp(App());
}

Future<void> runWithSentry() async {
  await SentryFlutter.init(
    (options) => options
      ..dsn =
        'your dsn here',
    appRunner: () => runApp(App()),
  );
}

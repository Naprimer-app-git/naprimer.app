import 'package:flutter/cupertino.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';

import 'app/pages/app.dart';

void main() async {
  LoggerService loggerService = LoggerService();
  loggerService.init();

  runApp(App());
}

import 'package:logger/logger.dart';

Logger getLogger() {
  return CustomLogger();
}

class CustomLogger extends Logger {
  CustomLogger() : super(printer: PrettyPrinter(methodCount: 0));
}

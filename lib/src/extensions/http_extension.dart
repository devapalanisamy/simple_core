import 'package:http/http.dart';

extension HttpResponseExtension on Response {
  bool get success {
    if (statusCode >= 200 && statusCode < 300) {
      return true;
    }
    return false;
  }
}

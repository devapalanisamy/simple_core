import 'package:core/src/navigation/routing_data.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    final Uri uriData = Uri.parse(this);
    return RoutingData(
      route: uriData.path,
      queryParameters: uriData.queryParameters,
    );
  }
}

extension NullableStringExtension on String? {
  bool get isNotNullAndNotEmpty {
    return this != null && this!.isNotEmpty;
  }
}

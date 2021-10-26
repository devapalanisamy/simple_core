class RoutingData {
  RoutingData({required this.route, Map<String, String>? queryParameters})
      : _queryParameters = queryParameters;
  final String route;
  final Map<String, String>? _queryParameters;

  String? operator [](String key) => _queryParameters![key];
}

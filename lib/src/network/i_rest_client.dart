import 'package:http/http.dart';

abstract class IRestClient {
  Future<Response> get({
    required String baseUrl,
    required String path,
    Map<String, String>? parameters,
    String? token,
  });
  Future<Response> post({
    required String baseUrl,
    required String path,
    required String request,
    String? token,
  });
  Future<Response> delete({
    required String baseUrl,
    required String path,
    String? token,
  });
  Future<Response> put({
    required String baseUrl,
    required String path,
    required String request,
    String? token,
  });
  Future<Response> patch({
    required String baseUrl,
    required String path,
    required String request,
    String? token,
  });
}

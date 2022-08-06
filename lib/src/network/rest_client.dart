import 'dart:io';

import 'package:http/http.dart';
import 'package:core/src/network/i_rest_client.dart';

class RestClient extends IRestClient {
  RestClient(
    this._client,
  );
  final Client _client;

  final Duration timeoutDuration = const Duration(seconds: 60);

  @override
  Future<Response> delete({required String baseUrl, required String path, String? token}) async {
    try {
      final Map<String, String> header = <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      return await _client
          .delete(
        Uri.https(baseUrl, path),
        headers: header,
      )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('408: Timed out');
      });
    } on Exception catch (e) {
      if (e is SocketException) {
        throw Exception('500: Server unavailable');
      }
      rethrow;
    }
  }

  @override
  Future<Response> get(
      {required String baseUrl, required String path, Map<String, String>? parameters, String? token}) async {
    try {
      final Map<String, String> header = <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      return await _client
          .get(
        Uri.https(baseUrl, path, parameters),
        headers: header,
      )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('408: Timed out');
      });
    } on Exception catch (e) {
      if (e is SocketException) {
        throw Exception('500: Server unavailable');
      }
      rethrow;
    }
  }

  @override
  Future<Response> patch(
      {required String baseUrl, required String path, required String request, String? token}) async {
    try {
      final Map<String, String> header = <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      return await _client
          .patch(
        Uri.https(baseUrl, path),
        headers: header,
        body: request,
      )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('408: Timed out');
      });
    } on Exception catch (e) {
      if (e is SocketException) {
        throw Exception('500: Server unavailable');
      }
      rethrow;
    }
  }

  @override
  Future<Response> post({required String baseUrl, required String path, required String request, String? token}) async {
    try {
      final Map<String, String> header = <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      return await _client
          .post(
        Uri.https(baseUrl, path),
        headers: header,
        body: request,
      )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('408: Timed out');
      });
    } on Exception catch (e) {
      if (e is SocketException) {
        throw Exception('500: Server unavailable');
      }
      rethrow;
    }
  }

  @override
  Future<Response> put({required String baseUrl, required String path, required String request, String? token}) async {
    try {
      final Map<String, String> header = <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      return await _client
          .put(
        Uri.https(baseUrl, path),
        headers: header,
        body: request,
      )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('408: Timed out');
      });
    } on Exception catch (e) {
      if (e is SocketException) {
        throw Exception('500: Server unavailable');
      }
      rethrow;
    }
  }
}

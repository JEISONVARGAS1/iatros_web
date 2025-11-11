import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/core/util/service/server.dart';

class CenterApi {
  static const String connectionError = "Error en la conexión";
  final String token;

  CenterApi({this.token = ""});

  Map<String, String> get _headers {
    if (token.isEmpty) {
      return Server().headers;
    } else {
      return {
        ...Server().headers,
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    }
  }

  Future<QueryResponseModel> get({
    required String urlSpecific,
    bool isCustomUrl = false,
  }) async {
    try {
      Uri url = Uri.parse(Server().productApi(urlSpecific));

      if (isCustomUrl) url = Uri.parse(urlSpecific);

      final response = await http.get(url, headers: _headers);
      final dataDecode = response.body.isNotEmpty
          ? json.decode(utf8.decode(response.bodyBytes))
          : [];

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        return QueryResponseModel(data: dataDecode);
      } else {
        return QueryResponseModel(
          data: [],
          isSuccessful: false,
          message: connectionError,
        );
      }
    } on http.ClientException catch (e) {
      return QueryResponseModel(
        data: [],
        isSuccessful: false,
        message: e.message.toString(),
      );
    }
  }

  Future<QueryResponseModel> post({
    required String urlSpecific,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Server().productApi(urlSpecific)),
        headers: _headers,
        body: json.encode(body),
      );

      final dataDecode = response.body.isNotEmpty
          ? json.decode(utf8.decode(response.bodyBytes))
          : [];

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        return QueryResponseModel(data: dataDecode);
      } else {
        return QueryResponseModel(
          data: [],
          message: "Error en la petición",
          isSuccessful: false,
        );
      }
    } catch (_) {
      return QueryResponseModel(
        data: [],
        isSuccessful: false,
        message: connectionError,
      );
    }
  }

  Future<QueryResponseModel> patch({
    required String urlSpecific,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse(Server().productApi(urlSpecific)),
        headers: _headers,
        body: json.encode(body),
      );

      final dataDecode = response.body.isNotEmpty
          ? json.decode(utf8.decode(response.bodyBytes))
          : [];

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        return QueryResponseModel(data: dataDecode);
      } else {
        return QueryResponseModel(
          data: [],
          message: "Error en la actualización",
          isSuccessful: false,
        );
      }
    } catch (_) {
      return QueryResponseModel(
        data: [],
        isSuccessful: false,
        message: connectionError,
      );
    }
  }

  Future<QueryResponseModel> delete({required String urlSpecific}) async {
    try {
      final response = await http.delete(
        Uri.parse(Server().productApi(urlSpecific)),
        headers: _headers,
      );

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        return QueryResponseModel(data: []);
      } else {
        return QueryResponseModel(
          data: [],
          message: "Error en la eliminación",
          isSuccessful: false,
        );
      }
    } catch (_) {
      return QueryResponseModel(
        data: [],
        isSuccessful: false,
        message: connectionError,
      );
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ezamjena_mobile/widets/api_exceptions.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';

import '../utils/utils.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint;

  String? publicUrl;
  HttpClient client = new HttpClient();
  IOClient? http;
  Duration get _timeout => const Duration(seconds: 15);

  BaseProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5238/");
    print("baseurl: $_baseUrl");

    if (_baseUrl!.endsWith("/") == false) {
      _baseUrl = _baseUrl! + "/";
    }

    _endpoint = endpoint;
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
    publicUrl = "$_baseUrl$_endpoint";
  }

  Future<Response> _safe(Future<Response> future, {String? path}) async {
    try {
      final res = await future.timeout(_timeout);
      if (res.statusCode == 204) return res;

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res;
      }

      String? serverMsg;
      try {
        final b = res.body;
        if (b.isNotEmpty) {
          final decoded = jsonDecode(b);
          if (decoded is Map && decoded['message'] is String) {
            serverMsg = decoded['message'] as String;
          } else if (decoded is String) {
            serverMsg = decoded;
          }
        }
      } catch (_) {
        serverMsg = res.body;
      }

      throw ApiException(
        statusCode: res.statusCode,
        serverMessage: serverMsg,
        userMessage: friendlyMessage(
          status: res.statusCode,
          serverMessage: serverMsg,
          path: path,
        ),
      );
    } on SocketException {
      throw NetworkException('Provjerite internet vezu i pokušajte ponovo.');
    } on TimeoutException {
      throw NetworkException('Veza je istekla. Pokušajte ponovo.');
    }
  }

  Future<T?> getById(int? id, [dynamic additionalData]) async {
    final url = Uri.parse("$_baseUrl$_endpoint/$id");
    final res = await _safe(http!.get(url, headers: createHeaders()),
        path: 'GET $_endpoint/$id');

    if (res.statusCode == 204 || res.body.isEmpty) return null;
    final data = jsonDecode(res.body);
    return fromJson(data);
  }

  Future<List<T>> get([Map<String, dynamic>? search]) async {
    var uri = Uri.parse('$_baseUrl$_endpoint');
    if (search != null && search.isNotEmpty) {
      final qp = search.map((k, v) => MapEntry(k, v.toString()));
      uri = uri.replace(queryParameters: qp);
    }

    final res = await _safe(
      http!.get(uri, headers: createHeaders()),
      path: 'GET $_endpoint',
    );

    if (res.statusCode == 204 || res.body.isEmpty) return <T>[];
    final data = jsonDecode(res.body);
    return (data ?? []).map<T>((e) => fromJson(e)).toList();
  }

  Future<T?> insert(dynamic request) async {
    final uri = Uri.parse("$_baseUrl$_endpoint");
    final res = await _safe(
      http!.post(uri, headers: createHeaders(), body: jsonEncode(request)),
      path: 'POST $_endpoint',
    );

    if (res.statusCode == 204 || res.body.isEmpty) return null;
    return fromJson(jsonDecode(res.body)) as T;
  }

  Future<T?> update(int? id, [dynamic request]) async {
    final uri = Uri.parse("$_baseUrl$_endpoint/$id");
    final res = await _safe(
      http!.put(uri, headers: createHeaders(), body: jsonEncode(request)),
      path: 'PUT $_endpoint/$id',
    );

    if (res.statusCode == 204 || res.body.isEmpty) return null;
    return fromJson(jsonDecode(res.body)) as T;
  }

  Future<String> delete(int id) async {
    final url = Uri.parse("$_baseUrl$_endpoint/$id");
    final res = await _safe(
      http!.delete(url, headers: createHeaders()),
      path: 'DELETE $_endpoint/$id',
    );

    // Neki API-jevi vraćaju prazan body pri 204 – vrati prazan string
    return res.body.isNotEmpty ? res.body.toString() : '';
  }

  Map<String, String> createHeaders() {
    String? username = Authorization.username;
    String? password = Authorization.password;

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }

  T fromJson(data) {
    throw Exception("Override method");
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  bool isValidResponseCode(Response response) {
    if (response.statusCode == 200) {
      return response.body.isNotEmpty;
    } else if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw ApiException(
        statusCode: 400,
        userMessage: 'Neispravan zahtjev. Provjerite unesene podatke.',
      );
    } else if (response.statusCode == 401) {
      throw ApiException(
        statusCode: 401,
        userMessage:
            'Prijava nije uspjela. Provjerite korisničko ime i lozinku.',
      );
    } else if (response.statusCode == 403) {
      throw ApiException(
        statusCode: 403,
        userMessage: 'Nemate dozvolu za ovu radnju.',
      );
    } else if (response.statusCode == 404) {
      throw ApiException(
        statusCode: 404,
        userMessage: 'Traženi resurs nije pronađen.',
      );
    } else if (response.statusCode == 500) {
      throw ApiException(
        statusCode: 500,
        userMessage: 'Došlo je do greške na serveru. Pokušajte kasnije.',
      );
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        userMessage: 'Neočekivana greška. Pokušajte ponovo.',
      );
    }
  }
}

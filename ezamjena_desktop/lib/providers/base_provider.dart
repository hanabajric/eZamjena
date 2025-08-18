import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import '../utils/friendly_error.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint;

  String? publicUrl;
  HttpClient client = HttpClient();
  IOClient? http;

  // timeout za sve zahtjeve
  final Duration _timeout = const Duration(seconds: 12);

  BaseProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5238/");
    if (!_baseUrl!.endsWith("/")) _baseUrl = '$_baseUrl/';
    _endpoint = endpoint;

    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
    publicUrl = "$_baseUrl$_endpoint";
  }

  void _notify() => notifyListeners();

  // ---------- CENTRALNO DEKODIRANJE + MAPIRANJE GREŠAKA ----------
  dynamic _decodeOrThrow(Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.statusCode == 204 || res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }

    String? msg;
    try {
      final m = jsonDecode(res.body);
      msg = m['message'] ?? m['title'] ?? m['detail'];
    } catch (_) {}

    switch (res.statusCode) {
      case 400:
        throw FriendlyError(
            'Neispravan zahtjev', msg ?? 'Provjerite unesene podatke.');
      case 401:
        throw FriendlyError(
            'Neuspješna prijava', msg ?? 'Pogrešni kredencijali.');
      case 403:
        throw FriendlyError(
            'Zabranjeno', msg ?? 'Nemate dozvolu za ovu radnju.');
      case 404:
        throw FriendlyError(
            'Nije pronađeno', msg ?? 'Traženi resurs nije pronađen.');
      default:
        if (res.statusCode >= 500) {
          throw FriendlyError(
              'Greška na serveru', msg ?? 'Pokušajte ponovo kasnije.');
        }
        throw FriendlyError(
            'Greška', msg ?? 'Neuspješan zahtjev (${res.statusCode}).');
    }
  }

  Never _throwNetwork(Object e) {
    if (e is SocketException) {
      throw FriendlyError('Nema veze sa serverom',
          'Provjerite internet ili da li je API pokrenut.');
    }
    if (e is TimeoutException) {
      throw FriendlyError(
          'Isteklo vrijeme', 'Server se nije javio na vrijeme.');
    }
    throw FriendlyError('Neočekivana greška', e.toString());
  }
  // ---------------------------------------------------------------

  Future<T?> getById(int? id, [dynamic additionalData]) async {
    final url = Uri.parse("$_baseUrl$_endpoint/$id");
    final headers = createHeaders();

    try {
      final res = await http!.get(url, headers: headers).timeout(_timeout);
      final data = _decodeOrThrow(res);
      return data == null ? null : fromJson(data);
    } on FriendlyError {
      rethrow;
    } catch (e) {
      _throwNetwork(e);
    }
  }

  Future<List<T>> get([dynamic search]) async {
    var url = "$_baseUrl$_endpoint";
    if (search != null) {
      final queryString = getQueryString(search);
      url = "$url?$queryString";
    }
    final uri = Uri.parse(url);
    final headers = createHeaders();

    try {
      final res = await http!.get(uri, headers: headers).timeout(_timeout);
      final data = _decodeOrThrow(res);
      // očekujemo listu
      return (data as List).map((x) => fromJson(x)).cast<T>().toList();
    } on FriendlyError {
      rethrow;
    } catch (e) {
      _throwNetwork(e);
    }
  }

  Future<T?> insert(dynamic request) async {
    final uri = Uri.parse("$_baseUrl$_endpoint");
    final headers = createHeaders();

    try {
      final res = await http!
          .post(uri, headers: headers, body: jsonEncode(request))
          .timeout(_timeout);
      final data = _decodeOrThrow(res);
      _notify();
      return data == null ? null : fromJson(data);
    } on FriendlyError {
      rethrow;
    } catch (e) {
      _throwNetwork(e);
    }
  }

  Future<T?> update(int? id, [dynamic request]) async {
    final uri = Uri.parse("$_baseUrl$_endpoint/$id");
    final headers = createHeaders();

    try {
      final res = await http!
          .put(uri, headers: headers, body: jsonEncode(request))
          .timeout(_timeout);
      final data = _decodeOrThrow(res);
      _notify();
      return data == null ? null : fromJson(data);
    } on FriendlyError {
      rethrow;
    } catch (e) {
      _throwNetwork(e);
    }
  }

  Future<String> delete(int id) async {
    final url = Uri.parse("$_baseUrl$_endpoint/$id");
    final headers = createHeaders();

    try {
      final res = await http!.delete(url, headers: headers).timeout(_timeout);
      _decodeOrThrow(res); // samo validacija; ako je 2xx proći će
      _notify();
      return res.body.toString();
    } on FriendlyError {
      rethrow;
    } catch (e) {
      _throwNetwork(e);
    }
  }

  Map<String, String> createHeaders() {
    final username = Authorization.username;
    final password = Authorization.password;
    final basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    return {
      "Content-Type": "application/json",
      "Authorization": basicAuth,
    };
  }

  T fromJson(data) {
    throw Exception("Override method");
  }

  String getQueryString(Map params,
      {String prefix = '', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      var k = key;
      if (inRecursion) {
        if (k is int)
          k = '[$k]';
        else
          k = '.$k';
      }
      if (value is String || value is num || value is bool) {
        query +=
            '${query.isNotEmpty ? '&' : ''}$k=${Uri.encodeComponent(value.toString())}';
      } else if (value is DateTime) {
        final formatted = DateFormat('yyyy-MM-ddTHH:mm:ss').format(value) + 'Z';
        query +=
            '${query.isNotEmpty ? '&' : ''}$k=${Uri.encodeComponent(formatted)}';
      } else if (value is List || value is Map) {
        final map = value is List ? value.asMap() : value as Map;
        map.forEach((kk, vv) {
          query += getQueryString({kk: vv},
              prefix: '${query.isNotEmpty ? '&' : ''}$k', inRecursion: true);
        });
      }
    });
    return query;
  }
}

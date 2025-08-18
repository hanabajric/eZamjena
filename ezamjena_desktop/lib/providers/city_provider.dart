// providers/city_provider.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ezamjena_desktop/providers/base_provider.dart';
import '../model/city.dart';
import '../utils/friendly_error.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("Grad");

  @override
  City fromJson(data) => City.fromJson(data);

  Future<List<City>> getAnonymousCities([Map<String, dynamic>? search]) async {
    var url = publicUrl!;
    if (search != null && search.isNotEmpty) {
      final qs = getQueryString(search);
      url = "$url?$qs";
    }

    final uri = Uri.parse(url);

    try {
      final res = await http!.get(uri); // ↩︎ bez auth headera

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = res.body.isEmpty ? '[]' : res.body;
        final data = jsonDecode(body) as List;
        return data.map((x) => fromJson(x)).cast<City>().toList();
      }

      String? msg;
      try {
        final m = jsonDecode(res.body);
        msg = m['message'] ?? m['title'] ?? m['detail'];
      } catch (_) {}

      if (res.statusCode >= 500) {
        throw FriendlyError(
            'Greška na serveru', msg ?? 'Pokušajte ponovo kasnije.');
      }
      throw FriendlyError(
          'Greška', msg ?? 'Neuspješan zahtjev (${res.statusCode}).');
    } on FriendlyError {
      rethrow;
    } on SocketException {
      throw FriendlyError('Nema veze sa serverom',
          'Provjerite internet ili da li je API pokrenut.');
    } on TimeoutException {
      throw FriendlyError(
          'Isteklo vrijeme', 'Server se nije javio na vrijeme.');
    } catch (e) {
      throw FriendlyError('Neočekivana greška', e.toString());
    }
  }
}

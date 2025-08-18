// providers/user_provider.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/user.dart';
import 'base_provider.dart';
import '../utils/friendly_error.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("Korisnik");

  @override
  User fromJson(data) => User.fromJson(data);

  bool _passwordChanged = false;
  bool get passwordChanged => _passwordChanged;
  void setPasswordChanged(bool value) {
    _passwordChanged = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getLoggedInUserId() async {
    final url = Uri.parse("$publicUrl/user-role");
    try {
      final res = await http!.get(url, headers: createHeaders());

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return {'userId': data['userId'], 'userRole': data['userRole']};
      }

      String? msg;
      try {
        final m = jsonDecode(res.body);
        msg = m['message'] ?? m['title'] ?? m['detail'];
      } catch (_) {}
      if (res.statusCode == 401)
        throw FriendlyError(
            'Neuspješna prijava', msg ?? 'Pogrešni kredencijali.');
      if (res.statusCode == 403)
        throw FriendlyError(
            'Zabranjeno', msg ?? 'Nemate dozvolu za ovu radnju.');
      if (res.statusCode >= 500)
        throw FriendlyError('Greška na serveru', msg ?? 'Pokušajte kasnije.');
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

  Future<User?> insertUserWithoutAuth(dynamic request) async {
    final uri = Uri.parse(publicUrl!);

    try {
      final res = await http!.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        return fromJson(data);
      }

      String? msg;
      try {
        final m = jsonDecode(res.body);
        msg = m['message'] ?? m['title'] ?? m['detail'];
      } catch (_) {}
      if (res.statusCode >= 500)
        throw FriendlyError('Greška na serveru', msg ?? 'Pokušajte kasnije.');
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

  Future<User?> adminUpdate(int? id, dynamic request) async {
    final uri = Uri.parse("$publicUrl/AdminUpdate/$id");
    try {
      final res = await http!.put(
        uri,
        headers: createHeaders(),
        body: jsonEncode(request),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        final user = fromJson(data);
        notifyListeners(); // obavijesti UI da je update urađen
        return user;
      }

      String? msg;
      try {
        final m = jsonDecode(res.body);
        msg = m['message'] ?? m['title'] ?? m['detail'];
      } catch (_) {}
      if (res.statusCode == 400)
        throw FriendlyError(
            'Neispravan zahtjev', msg ?? 'Provjerite unesene podatke.');
      if (res.statusCode == 403)
        throw FriendlyError(
            'Zabranjeno', msg ?? 'Nemate dozvolu za ovu radnju.');
      if (res.statusCode == 404)
        throw FriendlyError('Nije pronađeno', msg ?? 'Korisnik nije pronađen.');
      if (res.statusCode >= 500)
        throw FriendlyError('Greška na serveru', msg ?? 'Pokušajte kasnije.');
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

  void clearUserData() {
    _passwordChanged = false;
    notifyListeners();
  }
}

import 'dart:convert';

import '../model/user.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("Korisnik");

  @override
  User fromJson(data) {
    // TODO: implement fromJson
    return User.fromJson(data);
  }

  bool _passwordChanged = false;

  bool get passwordChanged => _passwordChanged;

  void setPasswordChanged(bool value) {
    _passwordChanged = value;
    notifyListeners();
  }

  Future<int> getLoggedInUserId() async {
    var url = Uri.parse("$publicUrl/user-role");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);

      return data['userId'];
    } else {
      throw Exception("An error occured!");
    }
  }

  Future<User?> insertUserWithoutAuth(dynamic request) async {
    var url = "$publicUrl"; // Promijenite ovo prema vašim potrebama
    var uri = Uri.parse(url);

    var jsonRequest = jsonEncode(request);

    // U ovom slučaju, ne dodajemo nikakve headere, uključujući Authorization header

    var response = await http!.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonRequest,
    );

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data) as User;
    } else {
      return null;
    }
  }

  Future<User?> adminUpdate(int? id, dynamic request) async {
    var url = "$publicUrl/AdminUpdate/$id"; // Promijenjeni URL za AdminUpdate
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    try {
      var response =
          await http!.put(uri, headers: headers, body: jsonEncode(request));

      if (isValidResponseCode(response)) {
        var data = jsonDecode(response.body);
        print("Response data: $data");
        if (data != null && data is Map<String, dynamic>) {
          return fromJson(data) as User;
        } else {
          throw Exception('Invalid JSON data');
        }
      } else {
        print("Invalid response: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during the update: $e");
      return null;
    }
  }
}

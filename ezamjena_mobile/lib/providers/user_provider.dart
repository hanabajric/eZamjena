import 'dart:convert';

import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/utils/utils.dart';

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

  Future<Map<String, dynamic>> getLoggedInUserId() async {
    var url = Uri.parse("$publicUrl/user-role");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);

      return {'userId': data['userId'], 'userRole': data['userRole']};
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

  void clearUserData() {
    // Reset all internal data to their initial states
    // For example, if you store the user object, you should reset it:
    // this.currentUser = null;
    // Additionally, reset the passwordChanged flag if needed
    _passwordChanged = false;

    // Notify all listeners of the change
    notifyListeners();
  }
}

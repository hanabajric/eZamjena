import 'dart:convert';

import '../model/user.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider<User> {
  
  UserProvider() : super("Korisnik");

  @override
  User fromJson(data) {
    // TODO: implement fromJson
    return User();
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
  
}
import 'dart:convert';
import 'package:ezamjena_desktop/providers/base_provider.dart';

import '../model/buy.dart';

class BuyProvider extends BaseProvider<Buy> {
  BuyProvider() : super("Kupovina");

  @override
  Buy fromJson(data) {
    return Buy.fromJson(data);
  }

  @override
  Future<List<Buy>> get([dynamic search]) async {
    var url = "http://localhost:5238/Kupovina";
    if (search != null) {
      String queryString = getQueryString(search);
      url += "?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => Buy.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}

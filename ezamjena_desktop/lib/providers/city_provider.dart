import 'dart:convert';
import 'package:ezamjena_desktop/providers/base_provider.dart';

import '../model/city.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("Grad");

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }

  Future<List<City>> getAnonymousCities([dynamic search]) async {
    var url = "$publicUrl";
    if (search != null) {
      String queryString = getQueryString(search);
      url = url + "?" + queryString;
    }

    var uri = Uri.parse(url);

    var response = await http!.get(uri); // Nema dodavanja headersa

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data.map((x) => fromJson(x)).cast<City>().toList();
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }
}

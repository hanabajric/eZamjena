import 'dart:convert';
import 'package:ezamjena_mobile/providers/base_provider.dart';

import '../model/city.dart';

class CityProvider extends BaseProvider<City>{
  CityProvider(): super("Grad");
 
 
   @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}
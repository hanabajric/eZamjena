import 'dart:convert';
import 'package:ezamjena_desktop/providers/base_provider.dart';

import '../model/buy.dart';

class BuyProvider extends BaseProvider<Buy> {
  BuyProvider() : super("Kupovina");

  @override
  Buy fromJson(data) {
    return Buy.fromJson(data);
  }
}

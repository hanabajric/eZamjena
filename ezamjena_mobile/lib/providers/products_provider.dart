import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ezamjena_mobile/model/product.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';

import 'base_provider.dart';

//class ProductProvider with ChangeNotifier {
class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Proizvod");

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }

  Future<List<Product>> getRecommendedProducts(int? userId) async {
    var url = Uri.parse("$publicUrl/Recommend/$userId");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body) as List;
      List<Product> products = data.map((item) => fromJson(item)).toList();
      return products;
    } else {
      throw Exception("Failed to load recommended products.");
    }
  }
}

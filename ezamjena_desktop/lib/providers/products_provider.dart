import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:ezamjena_desktop/model/product.dart';
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
}

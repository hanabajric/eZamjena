import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';

import '../model/product_category.dart';
import 'base_provider.dart';

class ProductCategoryProvider extends BaseProvider<ProductCategory> {
  ProductCategoryProvider() : super("KategorijaProizvodum");

  @override
  ProductCategory fromJson(data) {
    return ProductCategory.fromJson(data);
  }
}

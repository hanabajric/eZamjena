import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ezamjena_mobile/model/product.dart';
import 'package:ezamjena_mobile/model/rating.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';

import 'base_provider.dart';

//class ProductProvider with ChangeNotifier {
  class RatingProvider extends BaseProvider<Rating> {
  RatingProvider() : super("Ocjena");
 
   @override
  Rating fromJson(data) {
    return Rating.fromJson(data);
  }
}

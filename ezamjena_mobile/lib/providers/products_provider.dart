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
  // HttpClient client = new HttpClient();
  // IOClient? http;
  // ProductProvider() {
  //   print("called ProductProvider");
  //   client.badCertificateCallback = (cert, host, port) => true;
  //   http = IOClient(client);
  // }

  // Future<List<Product>> get(dynamic searchObject) async {
  //   print("called ProductProvider.GET METHOD");
  //   var url = Uri.parse("https://192.168.1.25:49153/Proizvod");

  //   String username = "hana123";
  //   String password = "hana12345";

  //   String basicAuth =
  //       "Basic ${base64Encode(utf8.encode('$username:$password'))}";

  //   var headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": basicAuth
  //   };

  //   var response = await http!.get(url, headers: headers);

  //   if (response.statusCode < 400) {
  //     var data = jsonDecode(response.body);
  //     List<Product> list =
  //         data.map((x) => Product.fromJson(x)).cast<Product>().toList();
  //     return list;
  //   } else {
  //     throw Exception("User not allowed");
  //   }
   @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
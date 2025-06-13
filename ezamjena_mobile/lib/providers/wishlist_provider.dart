import 'package:flutter/material.dart';
import 'package:ezamjena_mobile/model/wishlist.dart';
import 'base_provider.dart';

class WishlistProvider extends BaseProvider<Wishlist> {
  WishlistProvider() : super("ListaZelja");
  @override
  Wishlist fromJson(data) {
    return Wishlist.fromJson(data);
  }

  Future<Wishlist?> getOrCreateWishlist(int userId) async {
    debugPrint('[WL] → GET   ?korisnikId=$userId');
    // ①  ispravno ime parametra →   "KorisnikId"
    final list = await get({'KorisnikId': userId}); // ključ KAO u Swagger-u
    if (list.isNotEmpty) return list.first;

    debugPrint('[WL] ← ${list.length} item(s) za user=$userId');

    if (list != null && list.isNotEmpty) return list.first;

    // ②  nije postojalo → kreiramo
    final body = {
      "korisnikId": userId, // payload ostaje camelCase
      "createdAt": DateTime.now().toIso8601String(),
    };

    debugPrint('[WL] → POST  $body');
    final json = await insert(body);
    debugPrint('[WL] ← kreirana WL  $json');

    return Wishlist.fromJson(json as Map<String, dynamic>);
  }
}

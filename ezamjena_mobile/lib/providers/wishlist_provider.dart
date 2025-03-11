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
    try {
      var response = await get({"korisnikId": userId});

      if (response != null && response.isNotEmpty) {
        return response
            .first; // ✅ Response je već Wishlist, ne treba ponovni fromJson
      } else {
        // Ako lista ne postoji, kreiraj novu
        var newWishlist = {
          "korisnikId": userId,
          "createdAt": DateTime.now().toIso8601String(),
        };

        try {
          var createdWishlist = await insert(newWishlist);
          return Wishlist.fromJson(createdWishlist as Map<String, dynamic>);
        } catch (e) {
          print("Greška pri kreiranju liste želja: $e");
          return null;
        }
      }
    } catch (e) {
      print("Greška pri dohvaćanju liste želja: $e");
      return null;
    }
  }
}

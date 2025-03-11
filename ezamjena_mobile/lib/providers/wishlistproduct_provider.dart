import 'package:flutter/material.dart';
import 'package:ezamjena_mobile/model/wishlist_item.dart';
import 'wishlist_provider.dart';
import 'base_provider.dart';

class WishlistProductProvider extends BaseProvider<WishlistItem> {
  WishlistProductProvider() : super("ListaZeljaProizvod");

  @override
  WishlistItem fromJson(data) {
    return WishlistItem.fromJson(data);
  }

  List<WishlistItem> _wishlistProducts = [];
  bool _isLoading = false;

  List<WishlistItem> get wishlistProducts => _wishlistProducts;
  bool get isLoading => _isLoading;

  // Dodavanje proizvoda na wishlist
  Future<void> addToWishlist(int userId, int productId) async {
    try {
      // Prvo dohvatiti ili kreirati listu želja
      var wishlistProvider = WishlistProvider();
      var wishlist = await wishlistProvider.getOrCreateWishlist(userId);

      if (wishlist != null) {
        var wishlistItem = {
          'listaZeljaId': wishlist.id,
          'proizvodId': productId,
          'vrijemeDodavanja': DateTime.now().toIso8601String(),
        };

        var newItem =
            await insert(wishlistItem); // Koristi insert iz BaseProvider
        if (newItem != null) {
          _wishlistProducts.add(newItem);
          notifyListeners();
        }
      }
    } catch (e) {
      print("Greška pri dodavanju proizvoda u wishlist: $e");
    }
  }

  Future<void> fetchWishlistProducts(int wishlistId) async {
    _isLoading = true;
    notifyListeners();

    try {
      var data = await get({"listaZeljaId": wishlistId});

      print("[DEBUG] API Response Type: ${data.runtimeType}");
      print("[DEBUG] API Response Data: $data");

      if (data is List) {
        if (data.isNotEmpty && data.first is WishlistItem) {
          print("[DEBUG] API je vratio listu WishlistItem objekata.");
          _wishlistProducts =
              data.cast<WishlistItem>(); // Samo ih dodaj u listu
        } else {
          print("[DEBUG] API je vratio JSON listu, parsiram...");
          _wishlistProducts = data
              .map(
                  (item) => WishlistItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } else {
        print("[ERROR] API nije vratio listu! Tip: ${data.runtimeType}");
      }
    } catch (e, stacktrace) {
      print("[ERROR] Greška pri dohvaćanju proizvoda iz wishlist: $e");
      print("[STACKTRACE] $stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeFromWishlist(int wishlistItemId) async {
    try {
      await delete(wishlistItemId);
      _wishlistProducts.removeWhere((item) => item.id == wishlistItemId);
      notifyListeners();
    } catch (e) {
      print("Greška pri uklanjanju proizvoda iz wishlist: $e");
    }
  }
}

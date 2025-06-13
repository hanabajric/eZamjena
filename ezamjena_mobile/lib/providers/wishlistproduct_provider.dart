import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //  ←  READ / WATCH
import 'package:collection/collection.dart'; //  ←  firstWhereOrNull
import 'package:ezamjena_mobile/model/wishlist_item.dart';
import 'package:ezamjena_mobile/providers/wishlist_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'base_provider.dart';

class WishlistProductProvider extends BaseProvider<WishlistItem> {
  WishlistProductProvider() : super('ListaZeljaProizvod');

  @override
  WishlistItem fromJson(data) => WishlistItem.fromJson(data);

/*────────────────────  STATE  ────────────────────*/
  final List<WishlistItem> _items = [];
  int? _wlId;
  bool _loading = false;

  bool get isLoading => _loading;
  List<WishlistItem> get wishlistProducts => List.unmodifiable(_items);
  bool containsProduct(int id) => _items.any((e) => e.proizvodId == id);

  void clear() {
    // ←  JEDINA “reset” metoda
    _items.clear();
    _wlId = null;
    _loading = false;
    notifyListeners();
  }

/*──────────────  INIT  &  FETCH  ──────────────*/
  Future<void> ensureWishlistExists(BuildContext ctx) async {
    final uid = LoggedInUser.userId;
    if (uid == null) return;

    final wlProv = ctx.read<WishlistProvider>();
    final wl = await wlProv.getOrCreateWishlist(uid);
    if (wl == null) return;

    _wlId = wl.id;
    await fetchWishlistProducts(_wlId!);
  }

  Future<void> fetchWishlistProducts(int listaZeljaId) async {
    _loading = true;
    notifyListeners();
    debugPrint('[WLP] → GET   ?ListaZeljaId=$listaZeljaId');
    try {
      final data = await get({
        // parametar mora biti ISTOG imena
        'ListaZeljaId': listaZeljaId // kao u swagger-u
      });
      debugPrint('[WLP] ← dobio ${data.length} item(a)');

      _items
        ..clear()
        ..addAll(data.map((e) => e is WishlistItem
            ? e
            : WishlistItem.fromJson(e as Map<String, dynamic>)));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

/*──────────────  ADD  /  REMOVE  ──────────────*/
  Future<void> addToWishlist(BuildContext ctx, int productId) async {
    if (_wlId == null) await ensureWishlistExists(ctx);
    if (_wlId == null || containsProduct(productId)) return;

    final body = {
      'listaZeljaId': _wlId,
      'proizvodId': productId,
      'vrijemeDodavanja': DateTime.now().toIso8601String(),
      'korisnikId': LoggedInUser.userId,
    };

    try {
      final wi = await insert(body); //  BaseProvider vraća WishlistItem
      _items.add(wi as WishlistItem); //  ←  više nema cast-a na Map
      notifyListeners();
    } catch (e) {
      debugPrint('[Wishlist] insert failed → $e'); // npr. duplikat
    }
  }

  Future<void> removeFromWishlistByProductId(int id) async {
    final w = _items.firstWhereOrNull((e) => e.proizvodId == id);
    if (w == null) return;

    await delete(w.id);
    _items.remove(w);
    notifyListeners();
  }

  Future<void> removeFromWishlist(int wishlistItemId) async {
    await delete(wishlistItemId);
    _items.removeWhere((e) => e.id == wishlistItemId);
    notifyListeners();
  }
}

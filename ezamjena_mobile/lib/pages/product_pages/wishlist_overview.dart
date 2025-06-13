import 'package:ezamjena_mobile/providers/wishlist_provider.dart';
import 'package:ezamjena_mobile/providers/wishlistproduct_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = "/wishlist";

  const WishlistScreen({Key? key}) : super(key: key);

  @override
  WishlistScreenState createState() => WishlistScreenState();
}

class WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWishlist();
    });
  }

  Future<void> _fetchWishlist() async {
    final wlp = context.read<WishlistProductProvider>();
    final wlProv = context.read<WishlistProvider>();

    wlp.clear();

    final uid = LoggedInUser.userId;
    if (uid == null) return;

    final wl = await wlProv.getOrCreateWishlist(uid);
    if (wl != null && wl.id != null) {
      await wlp.fetchWishlistProducts(wl.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moja Wishlista")),
      body: Consumer2<WishlistProvider, WishlistProductProvider>(
        builder: (context, wishlistProvider, wishlistProductProvider, child) {
          if (wishlistProductProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          var wishlistProducts = wishlistProductProvider.wishlistProducts;
          if (wishlistProducts.isEmpty) {
            return Center(child: Text("Nema proizvoda u wishlist-i."));
          }

          return ListView.builder(
            itemCount: wishlistProducts.length,
            itemBuilder: (context, index) {
              final item = wishlistProducts[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: SizedBox(
                    width: 60,
                    child: (item.proizvod.slika != null &&
                            item.proizvod.slika!.isNotEmpty)
                        ? imageFromBase64String(item.proizvod.slika!)
                        : Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                  ),
                  title: Text(item.proizvod.naziv ?? ""),
                  subtitle: Text(item.proizvod.opis ?? ""),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await wishlistProductProvider.removeFromWishlist(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Proizvod uklonjen iz liste želja")),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

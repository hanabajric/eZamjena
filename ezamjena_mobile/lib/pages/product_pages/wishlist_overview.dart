import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/master_page.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/wishlistproduct_provider.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = "/wishlist";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchWishlist());
  }

  Future<void> _fetchWishlist() async {
    setState(() => _loading = true);

    final wlp = context.read<WishlistProductProvider>();
    final wlProv = context.read<WishlistProvider>();

    wlp.clear();
    final uid = LoggedInUser.userId;
    if (uid != null) {
      final wl = await wlProv.getOrCreateWishlist(uid);
      if (wl != null && wl.id != null) {
        await wlp.fetchWishlistProducts(wl.id!);
      }
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;

    return MasterPageWidget(
      child: _loading
          ? Center(child: SpinKitFadingCircle(color: purple, size: 60))
          : Consumer<WishlistProductProvider>(
              builder: (_, wlp, __) {
                // ⬇️ prikazuj samo proizvode “u prodaji”
                final items = wlp.wishlistProducts
                    .where((wp) => (wp.proizvod.statusProizvodaId ?? 0) == 1)
                    .toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(),
                      const SizedBox(height: 16),
                      if (items.isEmpty)
                        _emptyCard()
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (_, i) =>
                              _wishItemCard(items[i], purple),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // ── UI helpers ──────────────────────────────────────────────────
  Widget _header() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            'Moja wishlista',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );

  Widget _emptyCard() => Card(
        margin: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Vaša lista želja je trenutačno prazna.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );

  Widget _wishItemCard(dynamic item, Color purple) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // slika
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey.shade200,
                  child: (item.proizvod.slika != null &&
                          item.proizvod.slika!.isNotEmpty)
                      ? imageFromBase64String(item.proizvod.slika!)
                      : const Icon(Icons.image_not_supported,
                          size: 28, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),

              // naziv + opis
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.proizvod.naziv ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.description_outlined,
                            size: 16, color: purple),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.proizvod.opis ?? '',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // brisanje
              IconButton(
                tooltip: 'Ukloni',
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () async {
                  await context
                      .read<WishlistProductProvider>()
                      .removeFromWishlist(item.id);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Proizvod uklonjen iz liste želja')),
                  );
                },
              ),
            ],
          ),
        ),
      );
}

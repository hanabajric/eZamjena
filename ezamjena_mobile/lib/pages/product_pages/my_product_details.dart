import 'package:ezamjena_mobile/pages/payment/payment_page.dart';
import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyProductDetailsPage extends StatefulWidget {
  static const String routeName = "/my_product_details";
  final String id;

  const MyProductDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  State<MyProductDetailsPage> createState() => _MyProductDetailsPageState();
}

class _MyProductDetailsPageState extends State<MyProductDetailsPage> {
  ProductProvider? _productProvider = null;
  late String id;
  Product? data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  Future loadData() async {
    setState(() => _loading = true);
    print('Loading data...');
    final tempData = await _productProvider?.getById(int.parse(id));
    if (mounted && tempData != null) {
      setState(() {
        data = tempData;
        _loading = false;
      });
    }
    print('Data loaded successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: _loading
          // ─── Loader u primarnoj boji ───────────────────────────────
          ? Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 60,
              ),
            )
          // ─── Sadržaj kad se podaci učitaju ─────────────────────────
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerRow(),
                  const SizedBox(height: 16),
                  _productCard(),
                ],
              ),
            ),
    );
  }

/*──────────────── HEADER ────────────────*/
  Widget _headerRow() => const Row(
        children: [
          BackButton(),
          Text('  Nazad', style: TextStyle(fontSize: 20)),
        ],
      );

/*──────────── NICE-LOOKING CARD ─────────*/
  Widget _productCard() {
    if (data == null) return const SizedBox.shrink();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data!.naziv ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: data!.slika != null
                        ? imageFromBase64String(data!.slika!)
                        : const Icon(Icons.image, size: 64, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _kv('Kategorija', data!.nazivKategorijeProizvoda),
                      _kv('Procijenjena cijena', '${data!.cijena} KM'),
                      _kv('Korisnik', data!.nazivKorisnika),
                      _kv('Stanje', data!.stanjeNovo! ? 'Novo' : 'Polovno'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              data!.opis ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

/*──────────── helper za ključ-vrijednost ────────────*/

  Widget _kv(String label, String? value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(Icons.circle, size: 6, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                        // etiketa – BOLD
                        text: '$label: ',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: value ?? ''), // vrijednost – normal
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

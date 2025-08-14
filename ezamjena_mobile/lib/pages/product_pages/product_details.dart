import 'package:ezamjena_mobile/model/report.dart';
import 'package:ezamjena_mobile/pages/payment/payment_page.dart';
import 'package:ezamjena_mobile/providers/report_provider.dart';
import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../model/trade.dart';
import '../../providers/buy_provider.dart';
import '../../providers/exchange_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = "/product_details";
  final String id;
  //Product? data;
  const ProductDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductProvider? _productProvider = null;
  ReportProvider? _reportProvider;
  late String id;
  Product? data;
  List<Product> list = [];
  Product? selectedProduct;
  ExchangeProvider? _exchangeProvider = null;
  Trade trade = Trade();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _productProvider = context.read<ProductProvider>();
    _reportProvider = context.read<ReportProvider>();
    loadData();
  }

  Future loadData() async {
    setState(() => _loading = true);
    print('Loading data...');
    final tempData = await _productProvider?.getById(int.parse(id));
    print('Temp data: $tempData');

    final tempList = await _productProvider?.get(null);
    print('Temp list: $tempList');

    //final tempBuy = await _buyProvider?.get(null);
    //print('Temp list of buys: $tempBuy');

    list = tempList!
        .where((product) =>
            product.korisnikId == LoggedInUser.userId &&
            product.statusProizvodaId == 1)
        .toList();
    if (mounted && tempData != null) {
      setState(() {
        data = tempData;

        selectedProduct = list.isNotEmpty ? list[0] : null;
        _loading = false;
      });
    }

    print('Data loaded successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: _loading
          ? Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 60,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerRow(),
                    const SizedBox(height: 16),
                    _productCard(),
                    const SizedBox(height: 24),
                    _swapSection(),
                    const SizedBox(height: 24),
                    _buySection(),
                  ],
                ),
              ),
            ),
    );
  }

// ➏  Izvučeni helperi samo za bolju čitljivost  ──────────────────────────────
  Widget _headerRow() => Row(
        children: const [
          BackButton(),
          Text('  Nazad', style: TextStyle(fontSize: 20)),
        ],
      );

  /// ➐  LJEPŠI PRIKAZ PROIZVODA  (zamjenjuje  productInfoWidget) ──────────────
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
            Align(
              alignment: Alignment.topRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(60, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(fontSize: 13),
                ),
                icon: const Icon(Icons.flag_outlined, size: 20),
                label: const Text('Prijavi'),
                onPressed: _openReportDialog,
              ),
            ),
            const SizedBox(height: 8),
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

  void _openReportDialog() {
    final _formKey = GlobalKey<FormState>();
    final _reasonCtl = TextEditingController();
    final _messageCtl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Prijavi proizvod'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _reasonCtl,
                decoration: const InputDecoration(
                  labelText: 'Razlog*',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obavezno polje' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageCtl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Poruka (opcionalno)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD5473C), width: 1.3),
              foregroundColor: const Color(0xFFD5473C),
              textStyle: const TextStyle(fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Otkaži'),
          ),
          ElevatedButton(
            child: const Text('Pošalji'),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              final req = (Report()
                    ..proizvodId = data!.id!
                    ..prijavioKorisnikId = LoggedInUser.userId!
                    ..razlog = _reasonCtl.text.trim()
                    ..poruka = _messageCtl.text.trim().isEmpty
                        ? null
                        : _messageCtl.text.trim())
                  .toJson();

              try {
                await _reportProvider!.insert(req);
                if (mounted) {
                  Navigator.pop(context); // zatvori modal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prijava poslana!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Greška: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

/*──────── helper za prikaz “Kategorija: Igračke”, … – boldiraj etiketu ──────*/
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
                        text: '$label: ',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: value ?? ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _swapSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: 'Odaberite vaš predmet za ',
                      style: TextStyle(fontSize: 15)),
                  TextSpan(
                      text: 'zamjenu',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ' (preporučeno iste ili slične procjenjene cijene):',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // ➊  D R O P D O W N
                Expanded(
                  child: list.isNotEmpty
                      ? DropdownButtonFormField<Product>(
                          value: selectedProduct,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: list
                              .map((p) => DropdownMenuItem<Product>(
                                    value: p,
                                    child: Text(p.naziv ?? ''),
                                  ))
                              .toList(),
                          onChanged: (p) => setState(() => selectedProduct = p),
                        )
                      : const Text('Trenutno nemate proizvode'),
                ),

                const SizedBox(width: 16),

                // ➋  G U M B
                ElevatedButton(
                  onPressed: list.isNotEmpty
                      ? _sendSwapRequest
                      : null, // ili data == null … za "Kupi"
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // bijela pozadina
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),

                    // ⬇️ DODAJ OVO
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.5),
                  ),
                  child: const Text('Pošaljite zahtjev'), // ili 'Kupi'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//  pomoćna metoda koja je nekad bila “inline” u onPressed handleru
  Future<void> _sendSwapRequest() async {
    trade
      ..datum = DateTime.now()
      ..proizvod1Id = selectedProduct?.id
      ..proizvod2Id = data?.id
      ..statusRazmjeneId = 1;

    _exchangeProvider = context.read<ExchangeProvider>();
    await _exchangeProvider?.insert(trade.toJson());

    showDialog(
      context: context,
      builder: (_) => AlertDialogWidget(
        title: 'Zahtjev poslan',
        message:
            'Uspješno ste poslali zahtjev za proizvod ${data?.naziv ?? ''}.',
        context: context,
      ),
    );
  }

// ─────────────────────────────────────────────────────────────────────────────
//  BUY  (“kupovina”)  SEKCIJA
// ─────────────────────────────────────────────────────────────────────────────
  Widget _buySection() {
    final purple = Theme.of(context).primaryColor; // = deepPurple

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: 'Ili izvršite ', style: TextStyle(fontSize: 15)),
                  TextSpan(
                      text: 'kupovinu',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' proizvoda:', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // ─── O D U S T A N I ────────────────────────────────────────
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5473C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text('Odustani'),
                  ),
                ),

                const SizedBox(width: 16),

                // ─── K U P I  – s obrubom + “rukica” ───────────────────────
                Expanded(
                  child: ElevatedButton(
                    onPressed: data == null
                        ? null
                        : () => Navigator.pushNamed(
                              context,
                              "${PaymentPage.routeName}/${data!.id}",
                            ),

                    // ručno građen ButtonStyle da ubacimo i side i cursor
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(purple),

                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),

                      // ↙︎ ljubičasti obrub
                      side: MaterialStateProperty.all(
                          BorderSide(color: purple, width: 1.5)),

                      // ↙︎ pokazivač “rukica” kad je aktivno
                      mouseCursor: MaterialStateProperty.resolveWith(
                        (states) => states.contains(MaterialState.disabled)
                            ? SystemMouseCursors.basic
                            : SystemMouseCursors.click,
                      ),
                    ),
                    child: const Text('Kupi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

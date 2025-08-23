import 'dart:async';

import 'package:ezamjena_mobile/model/user.dart';
import 'package:ezamjena_mobile/providers/user_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/trade.dart';
import '../../providers/exchange_provider.dart';
import '../../utils/utils.dart';
import '../../widets/empty_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ExchangeRequestsPage extends StatefulWidget {
  static const String routeName = "/exchange_requests";

  const ExchangeRequestsPage({Key? key}) : super(key: key);

  @override
  State<ExchangeRequestsPage> createState() => _ExchangeRequestsPageState();
}

class _ExchangeRequestsPageState extends State<ExchangeRequestsPage> {
  List<Trade> requests = [];
  ExchangeProvider? _exchangeProvider;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _exchangeProvider = context.read<ExchangeProvider>();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() => _loading = true);
    try {
      final tmp = await _exchangeProvider?.get(null);
      if (!mounted) return;
      setState(() {
        requests = (tmp ?? [])
            .where((trade) =>
                trade.proizvod2?.korisnikId == LoggedInUser.userId &&
                trade.statusRazmjeneId == 1)
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri učitavanju zahtjeva: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;

    return MasterPageWidget(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 8),
              if (_loading)
                Center(child: SpinKitFadingCircle(color: purple, size: 60))
              else if (requests.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: EmptyState(
                    icon: Icons.swap_horizontal_circle_outlined,
                    title: 'Trenutno nemate zahtjeve za razmjenu.',
                    subtitle:
                        'Kada neko pošalje zahtjev za razmjenu, pojavit će se ovdje.',
                    actionText: 'Osvježi',
                    onAction: _fetchRequests,
                  ),
                )
              else
                _requestsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            'Zahtjevi za razmjenu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );

  Widget _requestsGrid() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 u redu
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1 / 1,
          ),
          itemCount: requests.length,
          itemBuilder: (_, i) => _requestCard(requests[i]),
        ),
      );

  Widget _requestCard(Trade trade) {
    final purple = Theme.of(context).primaryColor;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (trade.proizvod2?.slika != null &&
                        trade.proizvod2!.slika!.isNotEmpty)
                    ? imageFromBase64String(trade.proizvod2!.slika!)
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 36),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trade.proizvod2?.naziv ?? 'Nepoznat proizvod',
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'za ${trade.proizvod1?.naziv ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Odbij',
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    // TODO: tvoja logika “odbij”
                    // nakon akcije samo refresh:
                    await _fetchRequests();
                  },
                ),
                IconButton(
                  tooltip: 'Prihvati',
                  icon: Icon(Icons.check, color: purple),
                  onPressed: () async {
                    await _acceptTrade(trade);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptTrade(Trade trade) async {
    setState(() => _loading = true);
    try {
      trade.statusRazmjeneId = 2;
      final payload = {
        "statusRazmjeneId": 2,
        "datum": DateTime.now().toIso8601String(),
        "proizvod1Id": trade.proizvod1Id,
        "proizvod2Id": trade.proizvod2Id,
      };

      await _exchangeProvider!.update(trade.id, payload);
      await _updateUserActiveProducts(trade.korisnik1Id!);
      await _updateUserActiveProducts(trade.korisnik2Id!);

      await _fetchRequests();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Zahtjev je uspješno prihvaćen.")),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Greška pri prihvatanju: $e")),
      );
    }
  }

  // Ažuriranje broja aktivnih proizvoda za korisnika
  Future<void> _updateUserActiveProducts(int userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = await userProvider.getById(userId);
    if (userData == null) return;

    final updatedActiveProducts = (userData.brojAktivnihArtikala ?? 0) - 1;
    final updateUser = {
      ...userData.toJson(),
      'brojAktivnihArtikala': updatedActiveProducts,
    };

    await userProvider.update(userId, updateUser);
  }
}
